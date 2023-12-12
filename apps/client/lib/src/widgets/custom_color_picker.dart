import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPicker extends StatefulWidget {
  final Widget? child;
  final Color pickerColor;
  final void Function(Color) onColorChanged;
  const CustomColorPicker({
    super.key,
    this.child,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
// raise the [showDialog] widget

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titlePadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: widget.pickerColor,
                    onColorChanged: widget.onColorChanged,
                    pickerAreaBorderRadius: BorderRadius.circular(8),
                    // enableLabel: true,
                    // portraitOnly: true,
                  ),
                ),
              );
            },
          );
        },
        child: ThemeColorBadge(
          color: widget.pickerColor,
        ));
  }
}

class ThemeColorBadge extends StatelessWidget {
  final Color? color;
  const ThemeColorBadge({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: const Icon(
        Icons.change_circle_outlined,
        color: CustomPalette.white,
      ),
    );
  }
}
