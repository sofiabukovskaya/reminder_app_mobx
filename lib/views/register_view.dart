import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app_mobx/exstensions/if_debugging.dart';
import 'package:reminder_app_mobx/state/app_state.dart';

class RegisterView extends HookWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'sofitest@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: '123'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email here...',
            ),
            keyboardType: TextInputType.emailAddress,
            keyboardAppearance: Brightness.dark,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Enter your password here...',
            ),
            keyboardAppearance: Brightness.dark,
            obscureText: true,
            obscuringCharacter: '🔘',
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text;
              final password = passwordController.text;
              context
                  .read<AppState>()
                  .register(email: email, password: password);
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppState>().goTo(AppScreen.login);
            },
            child: const Text('Already registered? Log in here!'),
          ),
        ],
      ),
    );
  }
}
