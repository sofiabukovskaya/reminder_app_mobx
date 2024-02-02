import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:reminder_app_mobx/dialogs/delete_account_dialog.dart';
import 'package:reminder_app_mobx/dialogs/logout_dialog.dart';
import 'package:reminder_app_mobx/state/app_state.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogoutDialog(context);
            if (shouldLogOut) {
              if (context.mounted) context.read<AppState>().logOut();
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              if (context.mounted) context.read<AppState>().deleteAccount();
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
