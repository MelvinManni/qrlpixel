import 'package:client/src/router/root_routes.dart';
import 'package:client/src/services/app_services.dart';
import 'package:client/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://sjuqrwtxfuztuyzbviwr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNqdXFyd3R4ZnV6dHV5emJ2aXdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIzMjI5NDgsImV4cCI6MjAxNzg5ODk0OH0.VWfdM4Qc3SRKbA5M-93DZ1yse7qSlYer7Q-0CMHvH1U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void refreshToken() async {
    try {
      if (supabase.auth.currentUser != null) supabase.auth.refreshSession();
    } catch (e) {
      if (kDebugMode) print(e);
      supabase.auth.signOut();
      GoRouter.of(rootNavigatorKey.currentContext!).go('/');
    }
  }

// Listen to changes in supabase auth
  void listenToAuthChange() => supabase.auth.onAuthStateChange.listen((auth) {
        // If the current supabase event is a password recovery, redirect to the reset password page
        if (auth.event == AuthChangeEvent.passwordRecovery) {
          GoRouter.of(rootNavigatorKey.currentContext!).go('/reset-password');
        } else if (auth.session != null) {
          if (rootNavigatorKey.currentContext != null) {
            if (!getCurrentRouteUri(rootNavigatorKey.currentContext!)
                .startsWith('/app')) {
              GoRouter.of(rootNavigatorKey.currentContext!).go('/app');
            }
          }
        } else {
          if (rootNavigatorKey.currentContext != null) {
            GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
          }
        }
      }).onError((_) {
        supabase.auth.signOut();
        if (rootNavigatorKey.currentContext != null) {
          GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
        }
      });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    listenToAuthChange();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppServices()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const MaterialRouterApp(),
      ),
    );
  }
}

final supabase = Supabase.instance.client;
