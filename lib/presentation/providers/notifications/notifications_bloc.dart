import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/domain/entities/push_message.dart';
import 'package:push_notification/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationsStatusChanged);
    //verificar estado de notificaciones
    _checkPermitionsFCM();
    //listener para notifications foreground
    _onForeGroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  void _notificationsStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _remoteMessageHandler(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = mapperRemoteMessageToEntity(message);
    print(notification.toString());
  }

  PushMessage mapperRemoteMessageToEntity(RemoteMessage message) {
    return PushMessage(
        messageId: _getMessageId(message),
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        sentDate: message.sentTime ?? DateTime.now(),
        data: message.data,
        imageUrl: _getImageUrl(message.notification!));
  }

  String _getMessageId(RemoteMessage message) =>
      message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';

  String? _getImageUrl(RemoteNotification notification) => Platform.isAndroid
      ? notification.android?.imageUrl
      : notification.apple?.imageUrl;

  void _onForeGroundMessage() {
    FirebaseMessaging.onMessage.listen(_remoteMessageHandler);
  }

  void _checkPermitionsFCM() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  Future<void> _getFCMToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void requestPermssion() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }
}
