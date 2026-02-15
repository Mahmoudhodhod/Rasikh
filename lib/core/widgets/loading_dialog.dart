import 'package:flutter/material.dart';
import 'gradient_loading_indicator.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: GradientLoadingIndicator(),
      );
    },
  );
}
