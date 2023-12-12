import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';

bottomModalSheet(Widget child, BuildContext context,
    {double? height, bool? useRoot, bool? dismissable}) {
  showModalBottomSheet<void>(
    context: context,
    isDismissible: dismissable ?? true,
    useRootNavigator: useRoot ?? false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxHeight: height ?? 250,
          minHeight: height ?? 250,
        ),
        decoration: const BoxDecoration(
          color: CustomPalette.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          child: child,
        ),
      );
    },
  );
}
