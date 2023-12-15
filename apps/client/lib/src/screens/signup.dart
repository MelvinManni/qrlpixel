import 'package:client/main.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/custom_text_button.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool signingUp = false;
  bool signingUpWIthGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/signup_illustration.png",
                      width: (MediaQuery.of(context).size.width - 32) * 0.7,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Hello!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Create your account.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InputField(
                          hintText: "Enter your email",
                          controller: emailController,
                          validator: emailTextFieldValidator,
                        ),
                        InputField(
                          hintText: "Enter your password",
                          controller: passwordController,
                          validator: passwordTextFieldValidator,
                          obscureText: true,
                          marginBottom: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextButton(
                      loading: signingUp,
                      disabled: signingUpWIthGoogle,
                      onPressed: _handleSignup,
                      child: const Text("Continue")),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("or",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: signingUp || signingUp ? null : _oAuthSignup,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomPalette.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            "assets/icons/google.png",
                            width: 16,
                          ),
                        ),
                        const Text(
                          "Register with google",
                          style: TextStyle(color: CustomPalette.text),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Login",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.pushNamed('login');
                                },
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.merge(
                                        const TextStyle(
                                          color: CustomPalette.link,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            )
                          ]),
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

  Future<void> _handleSignup() async {
    setState(() {
      signingUp = true;
    });
    try {
      if (formKey.currentState!.validate()) {
        await supabase.auth.signUp(
            password: passwordController.text, email: emailController.text);

        if (mounted && supabase.auth.currentUser != null) {
          clearStackAndNavigate(context, "/app");
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        initSnackBar(context, e.message, SnackAlertType.error);
      }
    } catch (e) {
      if (mounted) {
        initSnackBar(context, "Something went wrong while logging in...",
            SnackAlertType.error);
      }
    } finally {
      setState(() {
        signingUp = false;
      });
    }
  }

  Future<void> _oAuthSignup() async {
    setState(() {
      signingUpWIthGoogle = true;
    });
    try {
      await supabase.auth.signInWithOAuth(
        Provider.google,
        redirectTo: "io.supabase.qrlpixel://login-callback",
      );

      if (mounted && supabase.auth.currentUser != null) {
        clearStackAndNavigate(context, "/app");
      }
    } on AuthException catch (e) {
      if (mounted) {
        initSnackBar(context, e.message, SnackAlertType.error);
      }
    } catch (e) {
      if (mounted) {
        initSnackBar(context, "Something went wrong while logging in...",
            SnackAlertType.error);
      }
    } finally {
      setState(() {
        signingUpWIthGoogle = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
