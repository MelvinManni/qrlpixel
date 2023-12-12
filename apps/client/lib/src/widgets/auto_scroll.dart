import 'package:flutter/material.dart';

class AutoScrollChild extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;
  const AutoScrollChild({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8, minWidth: MediaQuery.of(context).size.width),

            child: child,
          ), // your column
        );
      },
    );
  }
}

