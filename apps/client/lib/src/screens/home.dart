import 'package:client/main.dart';
import 'package:client/src/services/app_services.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/widgets/auto_scroll.dart';
import 'package:client/src/widgets/input_field.dart';
import 'package:client/src/widgets/screen_padding.dart';
import 'package:client/src/widgets/snack_alert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? name = supabase.auth.currentUser?.userMetadata?["full_name"];
    return Scaffold(
      appBar: LogoutAppBar(
        label: "Hello${name != null ? ", ${name.split(" ")[0]}" : ""}!",
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
      leadingWidth: context.canPop() ? null : 0,
      centerTitle: context.canPop(),
      actions: [
        IconButton(
            onPressed: () async {
              try {
                await supabase.auth.signOut();
              } catch (e) {
                if (context.mounted) {
                  initSnackBar(context, "Oops... Something went wrong!",
                      SnackAlertType.warning);
                }
              }
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
    final appServices = Provider.of<AppServices>(context, listen: false);
    Future.delayed(Duration.zero, () {
      appServices.getQRCodes(
          silent: true,
          error: (_) {
            if (context.mounted) {
              initSnackBar(
                  context, "Something went wrong", SnackAlertType.warning);
            }
          });
    });
    return Consumer<AppServices>(builder: (_, appServices, __) {
      return Column(
        children: [
          StyledTextField(
            hintText: "Search for QR codes",
            prefixIcon: Icon(
              Icons.search,
              color: CustomPalette.primary[50],
            ),
          ),
          const SizedBox(height: 20),
          ...appServices.qrcodes
              .map(
                (value) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: QRCodeListItem(
                    name: value["name"],
                    url: value["url"],
                    scans: value["total_scans"],
                    qrcodeUrl: value["logo_url"],
                    id: value["redirect_id"],
                  ),
                ),
              )
              .toList()
        ],
      );
    });
  }

  // Future<void> getQRCodes({Function(dynamic)? callback}) async {
  //   try {
  //     final user = supabase.auth.currentUser;
  //     final value = await supabase
  //         .from("qrcode_details")
  //         .select("*")
  //         .eq("user", user?.id);
  //     print(value);
  //     callback?.call(value);
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     if (mounted) {
  //       initSnackBar(context, "Something went wrong", SnackAlertType.warning);
  //     }
  //   }
  // }
}

class QRCodeListItem extends StatelessWidget {
  const QRCodeListItem(
      {super.key,
      this.name,
      this.url,
      this.scans,
      this.qrcodeUrl,
      required this.id});

  final String? name;
  final String? url;
  final int? scans;
  final String? qrcodeUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed("qrcode-item", pathParameters: {
          "id": id,
        });
      },
      child: Container(
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
                  CodeNetworkImage(
                    imageUrl: qrcodeUrl,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomPalette.primary,
                                  ),
                        ),
                        Text(
                          url ?? "",
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
            ScanBadge(value: scans ?? 0),
          ],
        ),
      ),
    );
  }
}

class CodeNetworkImage extends StatelessWidget {
  const CodeNetworkImage({super.key, this.imageUrl});

  final String? imageUrl;

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
          imageUrl ??
              "https://sjuqrwtxfuztuyzbviwr.supabase.co/storage/v1/object/public/qrcode/qrl_pixel_logo.png",
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
