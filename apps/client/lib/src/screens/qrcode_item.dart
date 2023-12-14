import 'package:client/src/services/app_services.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/compact_number.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QRCodeItemScreen extends StatelessWidget {
  const QRCodeItemScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      final appServices = Provider.of<AppServices>(context, listen: false);
      appServices.getQRCode(id ?? "", error: (_) {
        if (context.mounted) {
          initSnackBar(context, "Something went wrong", SnackAlertType.warning);
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.canPop() ? context.pop() : context.go('/app');
          },
        ),
        title: Consumer<AppServices>(builder: (_, appServices, __) {
          final qrcode = appServices.qrcode.details;
          return Text(qrcode?["name"] ?? id ?? "");
        }),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Consumer<AppServices>(builder: (_, appServices, __) {
            final qrcode = appServices.qrcode.details;
            return Skeletonizer(
              enabled: appServices.qrCodeLoading,
              child: Material(
                color: CustomPalette.white[950],
                child: ScreenPadding(
                    top: 20,
                    child: Column(
                      children: [
                        Image.network(
                          qrcode?["qrl"] ?? "",
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/logo.png',
                            width: 300,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const ChartDetails(),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: CustomPalette.white,
                              boxShadow: [
                                BoxShadow(
                                  color: CustomPalette.primary[50]!
                                      .withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              qrcode?["name"] == null
                                  ? const SizedBox.shrink()
                                  : StatsCol(
                                      label: "Name", value: qrcode?["name"]),
                              checkIfValueIsEmptyStringOrNull(
                                      qrcode?["description"])
                                  ? const SizedBox.shrink()
                                  : StatsCol(
                                      label: "Description",
                                      value: qrcode?["description"]),
                              qrcode?["url"] == null
                                  ? const SizedBox.shrink()
                                  : StatsCol(
                                      label: "URL",
                                      value: qrcode?["url"],
                                      isUrl: true),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: StatsCol(
                                          label: "Scans",
                                          value: qrcode?["total_scans"]
                                                  ?.toString() ??
                                              "0",
                                          isBadge: true)),
                                  Expanded(
                                      child: StatsCol(
                                          label: "Unique Scans",
                                          value: qrcode?["unique_scans"]
                                                  ?.toString() ??
                                              "0",
                                          isBadge: true)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: StatsCol(
                                          label: "Mobile",
                                          value: qrcode?["mobile_count"]
                                                  ?.toString() ??
                                              "0",
                                          isBadge: true)),
                                  Expanded(
                                      child: StatsCol(
                                          label: "Desktop",
                                          value: qrcode?["desktop_count"]
                                                  ?.toString() ??
                                              "0",
                                          isBadge: true)),
                                ],
                              ),
                              StatsCol(
                                  label: "Top Location",
                                  value: qrcode?["top_location"] ?? "",
                                  isBadge: true)
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class StatsCol extends StatelessWidget {
  const StatsCol(
      {super.key,
      this.label,
      this.value,
      this.isUrl = false,
      this.isBadge = false});

  final String? label;
  final String? value;
  final bool isUrl;
  final bool isBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputLabel(
            label: label ?? "",
            style: TextStyle(color: CustomPalette.primary[50]),
          ),
          isUrl
              ? RichText(
                  text: TextSpan(
                    text: value ?? "",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CustomPalette.link,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go(value ?? "");
                      },
                  ),
                )
              : isBadge
                  ? Container(
                      constraints: const BoxConstraints(minWidth: 40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CustomPalette.primary,
                      ),
                      child: Text(
                        value ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CustomPalette.white),
                      ),
                    )
                  : Text(
                      value ?? "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
        ],
      ),
    );
  }
}

class ChartDetails extends StatelessWidget {
  const ChartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Accordion(
        label: "Scan Chart",
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.only(top: 40),
            height: 350,
            width: 500,
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: Consumer<AppServices>(builder: (_, appServices, __) {
                  return LineChart(
                    mainData(appServices.qrcode.chart, appServices.qrcode.maxY,
                        context),
                  );
                }),
              ),
            ),
          ),
        ));
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('JAN', style: style);
        break;
      case 2:
        text = Text('FEB', style: style);
        break;
      case 3:
        text = Text('MAR', style: style);
        break;
      case 4:
        text = Text('APR', style: style);
        break;
      case 5:
        text = Text('MAY', style: style);
        break;
      case 6:
        text = Text('JUN', style: style);
        break;
      case 7:
        text = Text('JUL', style: style);
        break;
      case 8:
        text = Text('AUG', style: style);
        break;
      case 9:
        text = Text('SEP', style: style);
        break;
      case 10:
        text = Text('OCT', style: style);
        break;
      case 11:
        text = Text('NOV', style: style);
        break;
      case 12:
        text = Text('DEC', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(num value, TitleMeta meta, BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return CompactNumber(number: value, style: style, align: TextAlign.left);
  }

  LineChartData mainData(
      List<FlSpot> spots, double maxY, BuildContext context) {
    final List<Color> gradientColors = [
      CustomPalette.primary,
      CustomPalette.secondary,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: CustomPalette.inactive,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: CustomPalette.inactive,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (val, meta) =>
                bottomTitleWidgets(val, meta, context),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100,
            getTitlesWidget: (val, meta) =>
                leftTitleWidgets(val, meta, context),
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Accordion extends StatefulWidget {
  const Accordion({super.key, this.label, required this.child});

  final String? label;
  final Widget child;

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool isExpanded = false;
  double childHeight = 0;
  final childKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded ? childHeight + 55 : 55,
      duration: const Duration(milliseconds: 200),
      clipBehavior: Clip.none,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: CustomPalette.white,
        boxShadow: [
          BoxShadow(
            color: CustomPalette.primary[50]!.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });

                if (isExpanded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      childHeight = childKey.currentContext!.size!.height;
                    });
                  });
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label ?? "Accordion",
                      style: TextStyle(
                        color: CustomPalette.primary[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    !isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: CustomPalette.primary[50],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            !isExpanded
                ? const SizedBox.shrink()
                : Container(
                    key: childKey,
                    child: widget.child,
                  ),
          ],
        ),
      ),
    );
  }
}
