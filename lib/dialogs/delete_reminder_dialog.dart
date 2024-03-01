import 'package:flutter/material.dart';
import 'package:reminder_app_mobx/dialogs/generic_dialog.dart';

Future<bool> showDeleteReminderDialog(BuildContext context) =>
    showGenericDialog<bool>(
      context: context,
      title: 'Delete reminder',
      content: 'Are you sure you wanna delete a reminder?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete reminder': true,
      },
    ).then(
      (value) => value ?? true,
    );
