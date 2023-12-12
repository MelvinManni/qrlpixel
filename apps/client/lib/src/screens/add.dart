import 'package:client/src/screens/home.dart';
import 'package:flutter/material.dart';

class AddNewQRCodeScreen extends StatelessWidget {
  const AddNewQRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: LogoutAppBar(
        label: 'Add New QR Code',
      ),
    );
  }
}
