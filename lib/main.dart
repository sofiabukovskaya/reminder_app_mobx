import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app_mobx/dialogs/show_auth_error.dart';
import 'package:reminder_app_mobx/loading/loading_screen.dart';
import 'package:reminder_app_mobx/state/app_state.dart';
import 'package:reminder_app_mobx/views/login_view.dart';
import 'package:reminder_app_mobx/views/register_view.dart';
import 'package:reminder_app_mobx/views/reminders_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Provider(
      create: (_) => AppState()..initialize(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ReactionBuilder(
        builder: (context) {
          return autorun(
            (_) {
              final isLoading = context.read<AppState>().isLoading;
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: 'Loading...',
                );
              } else {
                LoadingScreen.instance().hide();
              }
              final authError = context.read<AppState>().authError;
              if (authError != null) {
                showAuthError(
                  authError,
                  context,
                );
              }
            },
          );
        },
        child: Observer(
          name: 'CurrentScreen',
          builder: (context) {
            switch (context.read<AppState>().currentScreen) {
              case AppScreen.login:
                return const LoginView();

              case AppScreen.register:
                return const RegisterView();
              case AppScreen.reminders:
                return const RemindersView();
            }
          },
        ),
      ),
    );
  }
}
