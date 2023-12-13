import 'package:client/main.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Reset Password"),
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
                      "Please enter your new password, use a strong password.",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InputField(
                          hintText: "Enter new password",
                          obscureText: true,
                          controller: passwordController,
                          validator: passwordTextFieldValidator,
                        ),
                        InputField(
                          hintText: "Verify password",
                          obscureText: true,
                          controller: verifyPasswordController,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _resetPassword,
                    child: const Text("Continue"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    try {
      if (formKey.currentState!.validate()) {
        await supabase.auth.updateUser(UserAttributes(
          password: passwordController.text,
        ));
        if (mounted) {
          initSnackBar(
                  context,
                  "Password reset successful, please login with your new password",
                  SnackAlertType.success)
              .closed
              .then((value) {
            if (mounted) clearStackAndNavigate(context, '/login');
          });
        }
      }
    } catch (e) {
      if (mounted) {
        initSnackBar(context, "Something went wrong!", SnackAlertType.error);
      }
    }
  }
}
