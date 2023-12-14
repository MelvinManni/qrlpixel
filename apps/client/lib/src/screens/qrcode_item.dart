import 'package:client/main.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/compact_number.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QRCodeItemScreen extends StatefulWidget {
  const QRCodeItemScreen({super.key, this.id});

  final String? id;

  @override
  State<QRCodeItemScreen> createState() => _QRCodeItemScreenState();
}

class _QRCodeItemScreenState extends State<QRCodeItemScreen> {
  dynamic qrcode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getQRCode(callback: (value) {
        setState(() {
          qrcode = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.canPop() ? context.pop() : context.go('/app');
          },
        ),
        title: Text(qrcode?["name"] ?? widget.id ?? ""),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Skeletonizer(
            enabled: isLoading,
            child: Material(
              color: CustomPalette.white[950],
              child: ScreenPadding(
                top: 20,
                child: Column(
                  children: [
                    Image.network(
                      qrcode?["image_url"] ?? "",
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/logo.png',
                        width: 300,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ChartDetails(
                      id: widget.id,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: CustomPalette.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CustomPalette.primary[50]!.withOpacity(0.1),
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
                              : StatsCol(label: "Name", value: qrcode?["name"]),
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
                                      value:
                                          qrcode?["total_scans"]?.toString() ??
                                              "0",
                                      isBadge: true)),
                              Expanded(
                                  child: StatsCol(
                                      label: "Unique Scans",
                                      value:
                                          qrcode?["unique_scans"]?.toString() ??
                                              "0",
                                      isBadge: true)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: StatsCol(
                                      label: "Mobile",
                                      value:
                                          qrcode?["mobile_count"]?.toString() ??
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getQRCode({Function(dynamic)? callback}) async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = supabase.auth.currentUser;
      final value = await supabase
          .from("qrcode_details")
          .select("*")
          .eq("user", user?.id)
          .eq("redirect_id", widget.id)
          .maybeSingle();

      if (value == null) {
        if (mounted) {
          initSnackBar(context, "No QR Code found", SnackAlertType.warning);
          Future.delayed(const Duration(seconds: 2), () {
            context.canPop() ? context.pop() : context.go('/app');
          });
        }
        return;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        });
      }

      callback?.call(value);
    } catch (e) {
      if (kDebugMode) print(e);
      if (mounted) {
        initSnackBar(context, "Something went wrong", SnackAlertType.warning);
      }
    }
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

class ChartDetails extends StatefulWidget {
  const ChartDetails({super.key, this.id});

  final String? id;

  @override
  State<ChartDetails> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartDetails> {
  List<Color> gradientColors = [
    CustomPalette.primary,
    CustomPalette.secondary,
  ];
  double maxY = 0;
  List<FlSpot> spots = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getChartData(callback: (value) {
        print(value);
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
        setState(() {
          spots = tempSpot;
          maxY = max;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Accordion(
        label: "Scan Chart",
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: 300,
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
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
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

  Widget leftTitleWidgets(num value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return CompactNumber(number: value, style: style, align: TextAlign.left);
  }

  LineChartData mainData() {
    print(spots);
    print(maxY);
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
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100,
            getTitlesWidget: leftTitleWidgets,
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

  Future<void> _getChartData({Function(dynamic)? callback}) async {
    try {
      final res = await supabase
          .from('scans_data_with_month_year')
          .select('*')
          .eq('redirect_id', widget.id);
      callback?.call(res);
    } catch (e) {
      if (kDebugMode) print(e);
      if (mounted) {
        initSnackBar(context, "Something went wrong", SnackAlertType.warning);
      }
    }
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
