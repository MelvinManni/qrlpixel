import 'package:client/src/router/app_routes.dart';
import 'package:client/src/screens/forgot_password.dart';
import 'package:client/src/screens/login.dart';
import 'package:client/src/screens/reset_password.dart';
import 'package:client/src/screens/signup.dart';
import 'package:client/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final rootRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: "login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/signup",
      name: "signup",
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: "/forgot-password",
      name: "forgot-password",
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: "/reset-password",
      name: "reset-password",
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    appShellRoute,
  ],
);

class MaterialRouterApp extends StatelessWidget {
  const MaterialRouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: MyTheme.themeData,
      routerConfig: rootRouter,
    );
  }
}
