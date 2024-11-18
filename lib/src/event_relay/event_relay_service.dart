import 'dart:async';

import 'package:ccl_core/ccl_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class EventRelayService {
  static const String TAG = 'EventRelayService';

  final Map<String, PublishSubject<dynamic>> _channels = {};

  // Tracks active requests
  final Map<String, Completer<dynamic>> _pendingRequests = {};

  /// Publish an event to a specific channel with optional payload
  void _publish(String key, [dynamic payload]) {
    if (_channels.containsKey(key)) {
      Log.d(TAG, 'Publish to: $key, Payload: $payload',
          references: ['_publish']);
      _channels[key]!.add(payload);
    }
  }

  /// Subscribe to a specific channel
  Stream<T> _subscribe<T>(String key) {
    Log.d(TAG, 'Subscribe to: $key', references: ['_subscribe']);
    _ensureChannelExists(key);
    return _channels[key]!.stream.cast<T>();
  }

  /// Send a request downstream and wait for a response upstream
  Future<T> sendRequest<T>(
    String key, {
    dynamic requestPayload,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final responseKey = 'er-key-$key';
    final requestId = const Uuid().v4(); // Unique ID for this request
    final completer = Completer<T>();

    _pendingRequests[requestId] = completer;

    // Attach metadata for response handling
    final request = {
      'requestId': requestId,
      'payload': requestPayload,
      'responseKey': responseKey,
    };

    // Automatically subscribe to response channel
    final responseSubscription =
        _subscribe<Map>(responseKey).listen((response) {
      final requestId = response['requestId'] as String;
      final payload = response['payload'];

      // Resolve the completer if it exists
      if (_pendingRequests.containsKey(requestId)) {
        _pendingRequests[requestId]!.complete(payload);
        _pendingRequests.remove(requestId);
      }
    });

    // Clean up listener after timeout or completion
    completer.future.whenComplete(() {
      responseSubscription.cancel();
    }).timeout(timeout, onTimeout: () {
      final error = TimeoutException(
        'Request timed out after $timeout',
        timeout,
      );
      if (!completer.isCompleted) {
        completer.completeError(error);
        responseSubscription.cancel();
      }
      throw error;
    });

    // Publish the request to the target
    _publish(key, request);

    // Wait for the response
    return completer.future;
  }

  /// Send a response upstream
  void _sendResponse(String responseKey, String requestId,
      [dynamic responsePayload]) {
    final response = {
      'requestId': requestId,
      'payload': responsePayload,
    };

    Log.d(TAG,
        'Sending response for response key $responseKey. Payload: $responsePayload',
        references: ['_sendResponse']);

    _publish(responseKey, response);
  }

  /// Subscribe to requests on a channel and provide responses
  StreamSubscription handleRequest<T, R>(
      String key, Future<R> Function(T requestPayload) handler) {
    Log.d(TAG, 'Request handler for $key', references: ['handleRequest']);

    return _subscribe<Map>(key).listen((request) async {
      final requestId = request['requestId'] as String;
      final payload = request['payload'] as T;
      final responseKey = request['responseKey'] as String;

      Log.d(TAG, 'Request received to handler for response key $responseKey',
          references: ['handleRequest']);

      try {
        // Process the request and send a response
        final response = await handler(payload);
        _sendResponse(responseKey, requestId, response);
      } catch (e, stackTrace) {
        _sendResponse(responseKey, requestId, {'error': e.toString()});
        Log.e(TAG, 'Error processing request: $e\n$stackTrace',
            references: ['handleRequest'],
            exception: e,
            stackTrace: stackTrace);
      }
    });
  }

  /// Ensure a channel exists before using it
  void _ensureChannelExists(String key) {
    if (!_channels.containsKey(key)) {
      _channels[key] = PublishSubject<dynamic>();
    }
  }

  /// Complete all channels and cleanup
  void closeAll() {
    for (final subject in _channels.values) {
      subject.close();
    }
    _channels.clear();
    _pendingRequests.clear();
  }
}
