import 'package:client/src/screens/qrcode_item.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

GlobalKey<ScaffoldState> analysisScafoldKey = GlobalKey<ScaffoldState>();

class _AnalysisScreenState extends State<AnalysisScreen> {
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
                    const Row(
                      children: [
                        Expanded(
                            child: AnalysisCard(
                          label: "Scans",
                          value: "75",
                        )),
                        Expanded(
                            child: AnalysisCard(
                          label: "Unique Scans",
                          value: "25",
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: AnalysisCard(
                          label: "Top Location",
                          value: "US",
                        )),
                        Expanded(
                            child: AnalysisCard(
                          label: "Last Scan",
                          value: formatDate(DateTime.now()),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const CountryBarChart(),
                    const ChartDetails(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class AnalysisCard extends StatelessWidget {
  const AnalysisCard({super.key, this.label, this.value});

  final String? label;
  final String? value;

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
                  fontSize: 16),
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
    return Container(
      margin: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(),
        ),
      ),
    );
  }
}
