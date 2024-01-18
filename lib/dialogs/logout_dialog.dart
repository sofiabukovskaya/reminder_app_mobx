import 'package:flutter/material.dart';
import 'package:reminder_app_mobx/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) =>
    showGenericDialog<bool>(
      context: context,
      title: 'Log out',
      content: 'Are you sure you wanna log out from account?',
      optionsBuilder: () => {
        'Cancel': false,
        'Log out': true,
      },
    ).then(
          (value) => value ?? true,
    );
