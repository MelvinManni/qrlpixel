import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: AutoScrollChild(
              child: Material(
        color: CustomPalette.white,
        child: ScreenPadding(
            child: Column(
          children: [],
        )),
      ))),
    );
  }
}
