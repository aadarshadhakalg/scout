import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Future<T?> openPrompt<T>(
    {required BuildContext context, required Widget child}) {
  return showGeneralDialog(
    context: context,
    transitionBuilder: (context, anim1, anim2, pageBuilder) {
      return FadeScaleTransition(
        animation: anim1,
        child: pageBuilder,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (
      BuildContext _,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return child;
    },
  );
}
