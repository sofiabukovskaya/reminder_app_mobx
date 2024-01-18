import 'package:flutter/material.dart';

enum TextFieldDialogButtonType { cancel, confirm }

typedef DialogOptionBuilder = Map<TextFieldDialogButtonType, String> Function();

final textController = TextEditingController();

Future<String?> showTextFieldDialog({
  required BuildContext buildContext,
  required String title,
  required String? hintText,
  required DialogOptionBuilder dialogOptionBuilder,
}) {
  textController.clear();
  final options = dialogOptionBuilder();
  return showDialog<String>(
    context: buildContext,
    builder: (buildContext) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
        actions: options.entries
            .map(
              (option) => TextButton(
                onPressed: () {
                  switch (option.key) {
                    case TextFieldDialogButtonType.cancel:
                      Navigator.of(buildContext).pop();
                      break;

                    case TextFieldDialogButtonType.confirm:
                      Navigator.of(buildContext).pop(textController.text);
                      break;
                  }
                },
                child: Text(option.value),
              ),
            )
            .toList(),
      );
    },
  );
}
