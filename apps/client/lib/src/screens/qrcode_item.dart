import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/mock_qr_code.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QRCodeItemScreen extends StatelessWidget {
  const QRCodeItemScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.canPop() ? context.pop() : context.go('/app');
          },
        ),
        title: Text(id ?? ""),
      ),
      body: SafeArea(
        child: AutoScrollChild(
          child: Material(
            color: CustomPalette.white[950],
            child: ScreenPadding(
              top: 20,
              child: Column(
                children: [
                  const MockQRCodeWidget(),
                  const SizedBox(height: 30),
                  const ChartDetails(),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CustomPalette.white,
                        boxShadow: [
                          BoxShadow(
                            color: CustomPalette.primary[50]!.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: const Column(
                      children: [
                        StatsCol(label: "Name", value: "Figma Company Design"),
                        StatsCol(
                            label: "Description",
                            value:
                                "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
                        StatsCol(
                            label: "URL",
                            value:
                                "https://www.figma.com/file/jU3J2z9ZTv0CXJpPoOp0p6/QRLPixel?type=design&node-id=3-1336&mode=design&t=IvtOuzv9ISGRGSKY-0",
                            isUrl: true),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: StatsCol(
                                    label: "Clicks",
                                    value: "45",
                                    isBadge: true)),
                            Expanded(
                                child: StatsCol(
                                    label: "Unique Clicks",
                                    value: "5",
                                    isBadge: true)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: StatsCol(
                                    label: "Mobile",
                                    value: "15",
                                    isBadge: true)),
                            Expanded(
                                child: StatsCol(
                                    label: "Desktop",
                                    value: "30",
                                    isBadge: true)),
                          ],
                        ),
                        StatsCol(
                            label: "Top Country",
                            value: "United State",
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

class ChartDetails extends StatefulWidget {
  const ChartDetails({
    super.key,
  });

  @override
  State<ChartDetails> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartDetails> {
  List<Color> gradientColors = [
    CustomPalette.primary,
    CustomPalette.secondary,
  ];
  @override
  Widget build(BuildContext context) {
    return Accordion(
        label: "Scan Chart",
        child: SizedBox(
          height: 200,
          child: AspectRatio(
            aspectRatio: 1.70,
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
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text('MAR', style: style);
        break;
      case 5:
        text = Text('JUN', style: style);
        break;
      case 8:
        text = Text('SEP', style: style);
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
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
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
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
