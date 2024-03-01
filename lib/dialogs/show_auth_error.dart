import 'package:flutter/material.dart';
import 'package:reminder_app_mobx/auth/auth_error.dart';
import 'package:reminder_app_mobx/dialogs/generic_dialog.dart';

Future<bool> showAuthError(AuthError authError, BuildContext context) =>
    showGenericDialog<bool>(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {
        'Ok': true,
      },
    ).then(
      (value) => value ?? true,
    );
