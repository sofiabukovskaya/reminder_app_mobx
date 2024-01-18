import 'package:flutter/material.dart';
import 'package:reminder_app_mobx/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) =>
    showGenericDialog<bool>(
      context: context,
      title: 'Delete account',
      content: 'Are you sure you wanna delete an account?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete account': true,
      },
    ).then(
      (value) => value ?? true,
    );
