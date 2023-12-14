import 'package:fl_chart/fl_chart.dart';

class UserSummary {
  List<BarChartGroupData> chart;
  dynamic summary;
  double maxY;

  UserSummary({
    this.chart = const [],
    this.summary,
    this.maxY = 0,
  });

  setChart(List<BarChartGroupData> val) {
    chart = val;
  }

  setSummary(dynamic val) {
    summary = val;
  }

  setMaxY(double val) {
    maxY = val;
  }
}
