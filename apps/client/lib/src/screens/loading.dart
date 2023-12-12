import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomPalette.primary,
      body: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/logo_white.png",
              width: 100,
            ),
            const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: CustomPalette.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
