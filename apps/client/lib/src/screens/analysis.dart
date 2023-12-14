import 'package:client/src/screens/qrcode_item.dart';
import 'package:client/src/services/app_services.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

GlobalKey<ScaffoldState> analysisScafoldKey = GlobalKey<ScaffoldState>();

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appServices = Provider.of<AppServices>(context, listen: false);
      appServices.getUserSummary(error: (_) {
        if (mounted) {
          initSnackBar(context, "Something went wrong!", SnackAlertType.error);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: analysisScafoldKey,
      appBar: AppBar(
        title: const Text("Analysis"),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
              color: CustomPalette.white,
              child: ScreenPadding(
                child: Column(
                  children: [
                    Consumer<AppServices>(builder: (_, appServices, __) {
                      final summary = appServices.userSummary.summary;
                      return Skeletonizer(
                        enabled: appServices.userSummaryLoading,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: AnalysisCard(
                                  label: "Scans",
                                  value: compactNumber(summary?["total_scans"]),
                                )),
                                Expanded(
                                    child: AnalysisCard(
                                  label: "Unique Scans",
                                  value:
                                      compactNumber(summary?["unique_scans"]),
                                )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: AnalysisCard(
                                  label: "Top Location",
                                  value: summary?["top_country"] ?? "N/A",
                                )),
                                Expanded(
                                    child: AnalysisCard(
                                  label: "Last Scan",
                                  size: 14,
                                  value: formatDate(summary?["last_scan_at"],
                                      withTime: true),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    }),
                    const Accordion(
                        label: "Scanned Bar Chart", child: CountryBarChart()),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  const AnalysisCard({
    super.key,
    this.label,
    this.value,
    this.size,
  });

  final String? label;
  final String? value;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomPalette.primary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label ?? "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CustomPalette.white.withOpacity(0.6),
                  ),
            ),
            Text(
              value ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CustomPalette.white,
                  fontWeight: FontWeight.w600,
                  fontSize: size ?? 16),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryBarChart extends StatelessWidget {
  const CountryBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppServices>(builder: (_, appServices, __) {
      final chartData = appServices.userSummary.chart;
      final maxY = appServices.userSummary.maxY;
      return Container(
        margin: const EdgeInsets.all(8),
        child: AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              titlesData: titlesData,
              borderData: borderData,
              barGroups: chartData,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
            ),
          ),
        ),
      );
    });
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: CustomPalette.primary,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'JAN';
        break;
      case 2:
        text = 'FEB';
        break;
      case 3:
        text = 'MAR';
        break;
      case 4:
        text = 'APR';
        break;
      case 5:
        text = 'MAY';
        break;
      case 6:
        text = 'JUN';
        break;
      case 7:
        text = 'JUL';
        break;
      case 8:
        text = 'AUG';
        break;
      case 9:
        text = 'SEP';
        break;
      case 10:
        text = 'OCT';
        break;
      case 11:
        text = 'NOV';
        break;
      case 12:
        text = 'DEC';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}
