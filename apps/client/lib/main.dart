import 'package:client/src/router/root_routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
    await Supabase.initialize(
    url: 'https://sjuqrwtxfuztuyzbviwr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNqdXFyd3R4ZnV6dHV5emJ2aXdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIzMjI5NDgsImV4cCI6MjAxNzg5ODk0OH0.VWfdM4Qc3SRKbA5M-93DZ1yse7qSlYer7Q-0CMHvH1U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const MaterialRouterApp(),
    );
  }
}

final supabase = Supabase.instance.client;

