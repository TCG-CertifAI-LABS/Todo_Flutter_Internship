import 'package:flutter/material.dart';

Future<void> showWarningDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required Future<void> Function() commit,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () async {
              if (context.mounted) Navigator.of(context).pop();
              await commit();
            },
            child: Text("Approve", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}
