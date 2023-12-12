import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/login_illustration.png",
                      width: (MediaQuery.of(context).size.width - 32) * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
