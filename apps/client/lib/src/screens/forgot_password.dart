import 'package:client/main.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
                  Form(
                    key: formKey,
                    child: InputField(
                      hintText: "Enter your email address",
                      controller: emailController,
                      validator: emailTextFieldValidator,
                    ),
                  ),
                  TextButton(
                      onPressed: _resetPasswordEmail,
                      child: const Text("Continue"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPasswordEmail() async {
    try {
      if (formKey.currentState!.validate()) {
        await supabase.auth.resetPasswordForEmail(
          emailController.text,
          redirectTo: "io.supabase.qrlpixel://login-callback",
        );
        if (mounted) {
          initSnackBar(
              context,
              "Please check your email for the reset password link",
              SnackAlertType.info);
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      if (mounted) {
        initSnackBar(context, "Something went wrong!", SnackAlertType.error);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
