import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {bool isSuccess = true}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isSuccess ? Colors.green : Colors.red,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
