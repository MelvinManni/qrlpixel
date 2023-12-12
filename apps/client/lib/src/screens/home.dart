import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello, User!"),
        leadingWidth: 0,
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                clearStackAndNavigate(context, '/login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white,
            child: ScreenPadding(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 26, left: 33, right: 33),
                    decoration: BoxDecoration(
                      color: CustomPalette.primary[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CustomPalette.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    ]),
                  ),
                  const Text("Hello"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
