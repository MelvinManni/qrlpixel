import 'package:client/main.dart';
import 'package:client/src/models/qrcode_item.dart';
import 'package:client/src/models/user_summary.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppServices with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  UserSummary userSummary = UserSummary();
  QRCodeItemModel qrcode = QRCodeItemModel();
  List<dynamic> qrcodes = [];
  bool qrCodeLoading = false;
  bool userSummaryLoading = false;
  bool isLoading = false;

  Future<void> getQRCodes(
      {Function(dynamic)? callback,
      Function(dynamic)? error,
      String? search,
      bool silent = false}) async {
    if (!silent) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final user = supabase.auth.currentUser;
      final query =
          supabase.from("qrcode_details").select("*").eq("user", user?.id);

      if (search != null && search.isNotEmpty) {
        query.or('name.ilike.$search, description.ilike.$search');
      }

      final value = await query.order('created_at', ascending: false).limit(10);

      qrcodes = value;
      notifyListeners();
      callback?.call(value);
    } catch (e) {
      if (kDebugMode) print(e);
      error?.call(e);
    } finally {
      isLoading = false;
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

  Future<void> getUserSummaryChart() async {
    final user = supabase.auth.currentUser;

    try {
      final value = await supabase
          .from('user_scans_summary_by_month_year_view')
          .select("*")
          .eq('user_id', user?.id);
      value as List<dynamic>;
      double max = 0;
      List<BarChartGroupData> tempSpot = [];

      for (var i = 0; i < value.length; i++) {
        final item = value[i];
        final y = (item["scans_count"] as int).toDouble();
        final x = (item["month"] as int);
        final spot = BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(
              toY: y,
              gradient: const LinearGradient(
                colors: [
                  CustomPalette.secondary,
                  CustomPalette.primary,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            )
          ],
          showingTooltipIndicators: [0],
        );
        tempSpot.add(spot);
        if (y > max) {
          max = y;
        }
      }

      userSummary.setChart(tempSpot);
      userSummary.setMaxY(max);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> getUserSummary({
    bool silent = false,
    Function(dynamic)? callback,
    Function(dynamic)? error,
  }) async {
    if (!silent) {
      userSummaryLoading = true;
      notifyListeners();
    }
    try {
      final user = supabase.auth.currentUser;
      final value = await supabase
          .from('user_summary')
          .select("*")
          .eq('user_id', user?.id)
          .maybeSingle();

      if (value == null) {
        error?.call(null);
        return;
      } else {
        userSummary.setSummary(value);
        userSummaryLoading = false;
        notifyListeners();
      }

      callback?.call(value);
    } catch (e) {
      if (kDebugMode) print(e);
      error?.call(e);
    }
  }
}
