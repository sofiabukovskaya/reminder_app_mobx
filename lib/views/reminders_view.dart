import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app_mobx/dialogs/delete_reminder_dialog.dart';
import 'package:reminder_app_mobx/dialogs/show_textfield_dialog.dart';
import 'package:reminder_app_mobx/state/app_state.dart';
import 'package:reminder_app_mobx/views/main_popup_menu_button.dart';

class RemindersView extends StatelessWidget {
  const RemindersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            onPressed: () async {
              final reminderText = await showTextFieldDialog(
                buildContext: context,
                title: 'What do you want me to remind you about?',
                hintText: 'Enter your reminder text here...',
                dialogOptionBuilder: () => {
                  TextFieldDialogButtonType.cancel: 'Cancel',
                  TextFieldDialogButtonType.confirm: 'Save'
                },
              );
              if (reminderText == null) {
                return;
              }
              if (!context.mounted) return;
              context.read<AppState>().createReminder(reminderText);
            },
            icon: const Icon(Icons.add),
          ),
          const MainPopupMenuButton(),
        ],
      ),
    );
  }
}

class ReminderListView extends StatelessWidget {
  const ReminderListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(
      builder: (context) {
        return ListView.builder(
          itemCount: appState.sortedReminders.length,
          itemBuilder: (context, index) {
            final reminder = appState.sortedReminders[index];
            return Observer(
              builder: (context) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: reminder.isDone,
                  onChanged: (isDone) {
                    context
                        .read<AppState>()
                        .modify(reminder, isDone: isDone ?? false);
                    reminder.isDone = isDone ?? false;
                  },
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.text,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final shouldDeleteReminder =
                              await showDeleteReminderDialog(context);
                          if (shouldDeleteReminder) {
                            context.read<AppState>().delete(reminder);
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
