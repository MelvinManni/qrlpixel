import 'package:client/src/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: "login",
      builder: (context, state) => const SizedBox(),
    ),
    GoRoute(
      path: "signup",
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
