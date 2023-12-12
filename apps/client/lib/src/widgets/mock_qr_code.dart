import 'dart:math';

import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';

class MockQRCodeWidget extends StatelessWidget {
  const MockQRCodeWidget(
      {super.key,
      this.dots = CustomPalette.primary,
      this.cornerDot = CustomPalette.primary,
      this.cornerSquare = CustomPalette.primary,
      this.imagePath});

  final Color dots;
  final Color cornerDot;
  final Color cornerSquare;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRowWithSquare(),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildQRRow(30),
              _buildRowWithSquare(bottom: true),
            ],
          ),
        ),
        Positioned(
            child: FractionallySizedBox(
                widthFactor: 0.3,
                child: LogoContainer(
                  imagePath: imagePath,
                ))),
      ],
    );
  }

  Widget _buildQRRow(int value) {
    List<bool> arr = List.generate(value, (index) => Random().nextBool());
    // RANDOMIZE THE VALUE

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: arr.map((e) => _buildQRDot(e)).toList(),
    );
  }

  Widget buildQRCorner(
      {Color? dot, Color? square, bool right = false, bool bottom = false}) {
    return Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.only(
            left: right ? 10 : 0,
            right: right ? 0 : 10,
            bottom: bottom ? 0 : 10,
            top: bottom ? 10 : 0),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: CustomPalette.white,
          border: Border.all(
            width: 8.0,
            color: cornerSquare,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: cornerDot,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ));
  }

  Widget _buildQRDot(bool color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color ? dots : CustomPalette.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildRowWithSquare({bool bottom = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildQRCorner(
          right: false,
          bottom: bottom,
        ),
        Expanded(
            child: Column(
          children: List.generate(6, (e) => _buildQRRow(16)),
        )),
        buildQRCorner(
          right: true,
          bottom: bottom,
        ),
      ],
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key, this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomPalette.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath ?? "assets/logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
