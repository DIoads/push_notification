import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/presentation/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context
            .select((NotificationsBloc bloc) => Text(bloc.state.status.name)),
        actions: [
          IconButton(
              onPressed: () {
                context.read<NotificationsBloc>().requestPermssion();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: const Center(
        child: Text('hola mundo'),
      ),
    );
  }
}
