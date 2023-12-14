import 'package:client/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppServices with ChangeNotifier {
  dynamic user_summary;
  dynamic user_scan_summary;
  dynamic qrcode;
  List<dynamic> qrcodes = [];
  bool itemIsloading = false;
  bool analysisIsLoading = false;
  bool isLoading = false;

  Future<void> getQRCodes(
      {Function(dynamic)? callback,
      Function(dynamic)? error,
      bool silent = false}) async {
    if (!silent) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final user = supabase.auth.currentUser;
      final value = await supabase
          .from("qrcode_details")
          .select("*")
          .eq("user", user?.id);

      qrcodes = value;
      callback?.call(value);
    } catch (e) {
      if (kDebugMode) print(e);
      error?.call(e);
    } finally {
      notifyListeners();
    }
  }
}
