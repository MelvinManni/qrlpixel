import 'package:client/main.dart';
import 'package:client/src/models/qrcode_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppServices with ChangeNotifier {
  QRCodeItemModel qrcode = QRCodeItemModel();
  List<dynamic> qrcodes = [];
  bool qrCodeLoading = false;
  bool analysisLoading = false;
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

  Future<void> getChartData(String id) async {
    try {
      final value = await supabase
          .from('scans_data_with_month_year')
          .select('*')
          .eq('redirect_id', id);

      final data = value as List<dynamic>;
      double max = 0;
      List<FlSpot> tempSpot = [];
      for (var i = 0; i < data.length; i++) {
        final item = data[i];
        final y = (item["scans_count"] as int).toDouble();
        final x = (item["month"] as int).toDouble();
        final spot = FlSpot(x, y);
        tempSpot.add(spot);
        if (y > max) {
          max = y;
        }
      }

      qrcode.setChart(tempSpot);
      qrcode.setMaxY(max);
    } catch (e) {
      qrcode.setChart([]);
      qrcode.setMaxY(0);
      if (kDebugMode) print(e);
    }
  }

  Future<void> getQRCode(
    String id, {
    Function(dynamic)? callback,
    Function(dynamic)? error,
    bool silent = false,
  }) async {
    if (!silent) {
      qrCodeLoading = true;
      notifyListeners();
    }
    try {
      final userId = supabase.auth.currentUser?.id;
      final value = await supabase
          .from("qrcode_details")
          .select("*")
          .eq("user", userId)
          .eq("redirect_id", id)
          .maybeSingle();
      await getChartData(id);
      callback?.call(null);
      if (value == null) {
        error?.call(null);
        return;
      } else {
        qrcode.setDetails(value);
        qrCodeLoading = false;
        notifyListeners();
      }

      callback?.call(value);
    } catch (e) {
      if (kDebugMode) print(e);
      error?.call(e);
    }
  }
}
