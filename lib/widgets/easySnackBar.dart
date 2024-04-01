import 'package:flutter/material.dart';

enum SnackbarType { error, info }

class EasySnackbar {
  static show(SnackbarType type, String message, BuildContext context) {
    Color color = Colors.greenAccent;
    if (type == SnackbarType.error) {
      color = Theme.of(context).colorScheme.error;
    } else if (type == SnackbarType.info) {
      color = Colors.lightBlue;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Flexible(child: Text(message)),
        backgroundColor: color,
      ),
    );
  }
}