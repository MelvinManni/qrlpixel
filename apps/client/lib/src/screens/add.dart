import 'package:client/src/screens/home.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/bottom_modal_sheet.dart';
import 'package:client/src/widgets/custom_color_picker.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/mock_qr_code.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';

class AddNewQRCodeScreen extends StatefulWidget {
  const AddNewQRCodeScreen({super.key});

  @override
  State<AddNewQRCodeScreen> createState() => _AddNewQRCodeScreenState();
}

class _AddNewQRCodeScreenState extends State<AddNewQRCodeScreen> {
  Color dots = CustomPalette.primary;
  Color cornerDot = CustomPalette.primary;
  Color cornerSquare = CustomPalette.primary;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoutAppBar(
        label: 'Generate New QR Code',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomModalSheet(
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    MockQRCodeWidget(
                      dots: dots,
                      cornerDot: cornerDot,
                      cornerSquare: cornerSquare,
                    ),
                  ],
                ),
              ),
              context,
              height: MediaQuery.of(context).size.height * 0.6,
              useRoot: true);
        },
        child: const Icon(
          Icons.preview_outlined,
          color: CustomPalette.white,
        ),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              top: 30,
              child: Column(
                children: [
                  Text(
                    "Empower Your URL with Personalized QR Codes: Easily Generate, Customize, and Share",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                      child: Column(
                    children: [
                      const InputField(
                        label: "Name",
                        hintText: "My Website",
                      ),
                      const InputField(
                        label: "Description",
                        hintText: "My website description",
                      ),
                      const InputField(
                        label: "URL",
                        hintText: "https://www.example.com",
                      ),
                      Wrap(
                        children: [
                          ColorPicker(
                            color: dots,
                            setColor: (color) {
                              setState(() {
                                dots = color;
                              });
                            },
                            label: "Dots Color",
                          ),
                          ColorPicker(
                            color: cornerDot,
                            setColor: (color) {
                              setState(() {
                                cornerDot = color;
                              });
                            },
                            label: "Corner Dots Color",
                          ),
                          ColorPicker(
                            color: cornerSquare,
                            setColor: (color) {
                              setState(() {
                                cornerSquare = color;
                              });
                            },
                            label: "Corner Square Color",
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorPicker extends StatelessWidget {
  const ColorPicker(
      {super.key,
      required this.color,
      required this.setColor,
      required this.label});

  final Color color;
  final String label;
  final Function(Color) setColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InputLabel(label: label),
        CustomColorPicker(
          pickerColor: color,
          onColorChanged: (color) {
            setColor(color);
          },
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
