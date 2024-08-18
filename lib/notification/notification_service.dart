import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked_annotations.dart';

class NotificationService extends InitializableDependency {
  final BehaviorSubject<int> _notificationCount = BehaviorSubject.seeded(0);

  //region getters setters
  BehaviorSubject<int> get notificationCount => _notificationCount;

  //endregion getters setters

  @override
  Future<void> init() async {}

  void setNotificationCount(int count) => _notificationCount.add(count);

  void incrementNotificationCount([int by = 1]) =>
      _notificationCount.add(_notificationCount.value + by);

  void decrementNotificationCount([int by = 1]) =>
      _notificationCount.add(_notificationCount.value - by);

  void resetNotificationCount() => setNotificationCount(0);
}
