import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoutAppBar(
        label: "Hello, User!",
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
                                width: 120,
                                height: 120,
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
                                              .bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        PieChartSectionData(
                                          color: CustomPalette.secondary,
                                          value: 75 - 25,
                                          title: "66.7%",
                                          // radius: 50,
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                      centerSpaceRadius: 20,
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

class LogoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoutAppBar({
    super.key,
    this.label,
  });

  final String? label;

  @override
  final preferredSize = const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(label ?? ""),
      leadingWidth: 0,
      centerTitle: false,
      actions: [
        IconButton(
            onPressed: () {
              clearStackAndNavigate(context, '/login');
            },
            icon: const Icon(Icons.logout))
      ],
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
    return Column(
      children: [
        StyledTextField(
          hintText: "Search for QR codes",
          prefixIcon: Icon(
            Icons.search,
            color: CustomPalette.primary[50],
          ),
          suffixIcon:
              IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          10,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: QRCodeListItem(),
          ),
        ).toList()
      ],
    );
  }
}

class QRCodeListItem extends StatelessWidget {
  const QRCodeListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: CustomPalette.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: CustomPalette.primary.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const CodeNetworkImage(),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "QR Code Name",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: CustomPalette.primary,
                            ),
                      ),
                      Text(
                        "https://www.figma.com/file/jU3J2z9ZTv0CXJpPoOp0p6/QRLPixel?type=design&node-id=3-1336&mode=design&t=IvtOuzv9ISGRGSKY-0",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: CustomPalette.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 75,
          ),
          const ScanBadge(value: 56),
        ],
      ),
    );
  }
}

class CodeNetworkImage extends StatelessWidget {
  const CodeNetworkImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: CustomPalette.white,
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.network(
          "https://cdn.sanity.io/images/599r6htc/localized/46a76c802176eb17b04e12108de7e7e0f3736dc6-1024x1024.png",
          loadingBuilder: (_, widget, progress) => Skeletonizer(
            enabled: progress != null,
            child: widget,
          ),
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ScanBadge extends StatelessWidget {
  const ScanBadge({super.key, this.value});

  final int? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      // padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: CustomPalette.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value?.toString() ?? "0",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomPalette.primary,
                  ),
            ),
            Text(
              "Scans",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CustomPalette.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}