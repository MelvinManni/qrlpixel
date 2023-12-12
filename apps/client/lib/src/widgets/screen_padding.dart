import 'package:flutter/material.dart';

class ScreenPadding extends StatelessWidget {
  const ScreenPadding(
      {super.key, required this.child, this.horizontal, this.top, this.bottom});

  final Widget child;
  final double? horizontal;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints:,
      padding: EdgeInsets.only(
          left: horizontal ?? 16,
          right: horizontal ?? 16,
          top: top ?? 0,
          bottom: bottom ?? 10),
      child: child,
    );
  }
}
