import 'package:flutter/material.dart';

Future<T?> runAndDisplaySnackbar<T>({
  required BuildContext context,
  required Future<T> Function() func,
  SnackBar Function()? onSuccessSnackBar,
  SnackBar Function(Object error)? onErrorSnackBar,
}) async {
  T? res;

  try {
    res = await func();
    if (onSuccessSnackBar != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(onSuccessSnackBar());
      }
    }
  } catch (e) {
    if (onErrorSnackBar != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(onErrorSnackBar(e));
      }
    }
  }

  return res;
}
