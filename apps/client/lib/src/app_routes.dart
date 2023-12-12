import 'package:client/src/screens/loading.dart';
import 'package:client/src/screens/login.dart';
import 'package:client/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: "login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/signup",
      name: "signup",
      builder: (context, state) => const SizedBox(),
    ),
    GoRoute(
      path: "/forgot-password",
      name: "forgot-password",
      builder: (context, state) => const SizedBox(),
    ),
    GoRoute(
      path: "/change-password",
      name: "change-password",
      builder: (context, state) => const SizedBox(),
    ),
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
