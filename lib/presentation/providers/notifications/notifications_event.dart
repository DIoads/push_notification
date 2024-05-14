part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  const NotificationsStatusChanged(this.status);
}

class NotificationRecived extends NotificationsEvent {
  final PushMessage message;

  NotificationRecived(this.message);
}
