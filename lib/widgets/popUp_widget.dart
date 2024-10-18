import 'package:flutter/material.dart';

Future popUpDialog(
  BuildContext context,
  String title,
  String contentText,
  Widget? content,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: content ??
          Center(
            child: Text(contentText),
          ),
      actions: [
        content != null
            ? Container()
            : TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Confirmar"),
              ),
      ],
    ),
  );
}
