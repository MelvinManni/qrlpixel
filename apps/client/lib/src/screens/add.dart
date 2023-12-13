import 'dart:convert';

import 'package:client/main.dart';
import 'package:client/src/screens/home.dart';
import 'package:client/src/services/http_services.dart';
import 'package:client/src/services/json_services.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/bottom_modal_sheet.dart';
import 'package:client/src/widgets/custom_color_picker.dart';
import 'package:client/src/widgets/custom_image_picker.dart';
import 'package:client/src/widgets/custom_text_button.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/mock_qr_code.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewQRCodeScreen extends StatefulWidget {
  const AddNewQRCodeScreen({super.key});

  @override
  State<AddNewQRCodeScreen> createState() => _AddNewQRCodeScreenState();
}

class _AddNewQRCodeScreenState extends State<AddNewQRCodeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  Color dots = CustomPalette.primary;
  Color cornerDot = CustomPalette.primary;
  Color cornerSquare = CustomPalette.primary;
  XFile? imagePicked;
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoutAppBar(
        label: 'Generate New QR Code',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomPalette.secondary,
        onPressed: () {
          bottomModalSheet(
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    MockQRCodeWidget(
                      dots: dots,
                      cornerDot: cornerDot,
                      cornerSquare: cornerSquare,
                      imagePath: imagePicked?.path,
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
          color: CustomPalette.primary,
        ),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              top: 30,
              bottom: 65,
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
                      key: formKey,
                      child: Column(
                        children: [
                          InputField(
                            label: "Name",
                            hintText: "My Website",
                            controller: nameController,
                            validator: (value) {
                              if (checkIfValueIsEmptyStringOrNull(value)) {
                                return "QR Code name cannot be empty!";
                              }
                              return null;
                            },
                          ),
                          InputField(
                            label: "Description",
                            hintText: "My website description",
                            controller: descriptionController,
                          ),
                          InputField(
                            label: "URL",
                            hintText: "https://www.example.com",
                            controller: urlController,
                            onEditingComplete: () {
                              setState(() {
                                urlController.text =
                                    appendHttpIfNotPresent(urlController.text);
                              });
                            },
                            validator: (value) {
                              if (checkIfValueIsEmptyStringOrNull(value)) {
                                return "URL cannot be empty!";
                              }

                              if (!isValidUrl(value ?? "")) {
                                return "Please enter a valid URL!";
                              }
                              return null;
                            },
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
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(),
                          ),
                          const InputLabel(label: "Upload Logo/Image"),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomImagePicker(
                              setImage: (image) {
                                setState(() {
                                  imagePicked = image;
                                });
                              },
                              imagePicked: imagePicked,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomTextButton(
                            loading: loading,
                            onPressed: _generateQRCode,
                            child: const Text("Generate QR Code"),
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

  Future<Map<String, dynamic>?> _getFormMap() async {
    try {
      final mapData = {
        "name": nameController.text,
        "description": descriptionController.text,
        "url": urlController.text,
        "dotsColor": dots.toHex(),
        "edgeDotsColor": cornerDot.toHex(),
        "edgeColor": cornerSquare.toHex()
      };
      if (imagePicked != null) {
        final bytes = await imagePicked!.readAsBytes();
        final base64Image = "data:image/png;base64,${base64Encode(bytes)}";
        mapData["image64"] = base64Image;
      }
      return mapData;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  _generateQRCode() async {
    try {
      final body = await _getFormMap();
      if (formKey.currentState!.validate() && body != null) {
        setState(() {
          loading = true;
        });
        final token = supabase.auth.currentSession?.accessToken;
        final res = await HTTPServices.post("$apiUrl/api/qrcode",
            body: body, token: token);

        final response = JSONServices.decode(res.body);
        print(response);

        if (res.statusCode != 201) {
          if (mounted) {
            initSnackBar(context, response["message"], SnackAlertType.error);
          }
        } else {
          if (mounted) {
            initSnackBar(context, response["message"], SnackAlertType.success);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      if (mounted) {
        initSnackBar(context, "Something went wrong!", SnackAlertType.error);
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    urlController.dispose();
    super.dispose();
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

extension HexColor on Color {
  String toHex() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
