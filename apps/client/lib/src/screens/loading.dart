import 'package:client/main.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _handleAppInit(context);
    });
    return Scaffold(
      backgroundColor: CustomPalette.primary,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/logo_white.png",
                width: 100,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: CustomPalette.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleAppInit(BuildContext context) async {
    final auth = supabase.auth;
    bool sessionExpired = auth.currentSession?.isExpired ?? true;
    if (sessionExpired && auth.currentUser == null) {
      auth.signOut();
      clearStackAndNavigate(context, "/login");
    } else {
      clearStackAndNavigate(context, "/app");
    }
  }
}
