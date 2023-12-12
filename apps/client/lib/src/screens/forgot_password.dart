import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Forgot Password"),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "Please enter the email address associated with your account",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const InputField(
                    hintText: "Enter your eamil",
                  ),
                  TextButton(
                      onPressed: () {
                        context.pushNamed("reset-password");
                      },
                      child: const Text("Continue"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
