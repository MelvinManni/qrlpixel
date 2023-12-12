import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:fl_chart/fl_chart.dart';
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "75 Scans",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: CustomPalette.white,
                                        ),
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ChartLegendRow(
                                        color: CustomPalette.secondary,
                                        label: "75 total scans",
                                      ),
                                      ChartLegendRow(
                                        color: CustomPalette.success,
                                        label: "25 unique scans",
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                            color: CustomPalette.success,
                                            value: 25,
                                            title: "33.3%",
                                            // radius: 50,
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        PieChartSectionData(
                                            color: CustomPalette.secondary,
                                            value: 75 - 25,
                                            title: "66.7%",
                                            // radius: 50,
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ],
                                      centerSpaceRadius: 15,
                                      sectionsSpace: 0,
                                    ),
                                    swapAnimationDuration: const Duration(
                                        milliseconds: 150), // Optional
                                    swapAnimationCurve: Curves.linear,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: CustomPalette.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        ]),
                  ),
                  const SizedBox(height: 80),
                  const QRCodesList()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartLegendRow extends StatelessWidget {
  const ChartLegendRow({
    super.key,
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomPalette.white,
              ),
        ),
      ],
    );
  }
}

class QRCodesList extends StatelessWidget {
  const QRCodesList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StyledTextField(
          hintText: "Search for QR codes",
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.filter_alt),
        )
      ],
    );
  }
}
