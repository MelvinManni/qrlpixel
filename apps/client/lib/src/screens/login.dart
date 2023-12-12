import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      "assets/login_illustration.png",
                      width: (MediaQuery.of(context).size.width - 32) * 0.7,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Please login to your account.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const InputField(
                    hintText: "Enter your email",
                  ),
                  const InputField(
                    hintText: "Enter your password",
                    obscureText: true,
                    marginBottom: 0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: "Forgot password?",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed('forgot-password');
                          },
                        style: Theme.of(context).textTheme.bodyMedium?.merge(
                              const TextStyle(
                                color: CustomPalette.link,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        clearStackAndNavigate(context, "/app");
                      },
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
                    onPressed: () {},
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
                          "Login with google",
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
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Sign up",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.pushNamed('signup');
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
}
