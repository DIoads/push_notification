import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/config/router/app_router.dart';
import 'package:push_notification/config/theme/app_theme.dart';
import 'package:push_notification/presentation/notifications/notifications_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationsBloc.initializeFON();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => NotificationsBloc(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
