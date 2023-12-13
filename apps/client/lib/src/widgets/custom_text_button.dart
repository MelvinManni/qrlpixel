import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.child,
      this.onPressed,
      this.loading = false,
      this.disabled = false});

  final Widget child;
  final VoidCallback? onPressed;
  final bool loading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !disabled && !loading;
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      child: child,
    );
  }
}
