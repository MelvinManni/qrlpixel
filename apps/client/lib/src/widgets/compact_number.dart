import 'package:client/src/utils.dart';
import 'package:flutter/material.dart';

class CompactNumber extends StatelessWidget {
  const CompactNumber({super.key, this.style, this.number, this.align});

  final TextStyle? style;
  final num? number;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      compactNumber(number),
      textAlign: align,
      style: style,
    );
  }
}
