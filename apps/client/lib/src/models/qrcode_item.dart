import 'package:fl_chart/fl_chart.dart';

class QRCodeItemModel {
  List<FlSpot> chart;
  dynamic details;
  double maxY;

  QRCodeItemModel({
    this.chart = const [],
    this.details,
    this.maxY = 0,
  });

  setChart(List<FlSpot> val) {
    chart = val;
  }

  setDetails(dynamic val) {
    details = val;
  }

  setMaxY(double val) {
    maxY = val;
  }
}
