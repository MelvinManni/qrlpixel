import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/mock_qr_code.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QRCodeItemScreen extends StatelessWidget {
  const QRCodeItemScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.canPop() ? context.pop() : context.go('/app');
          },
        ),
        title: Text(id ?? ""),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white[950],
            child: ScreenPadding(
              top: 20,
              child: Column(
                children: [
                  const MockQRCodeWidget(),
                  const SizedBox(height: 60),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CustomPalette.white,
                        boxShadow: [
                          BoxShadow(
                            color: CustomPalette.primary[50]!.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
