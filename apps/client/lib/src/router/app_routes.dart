import 'package:client/src/screens/add.dart';
import 'package:client/src/screens/home.dart';
import 'package:client/src/theme/custom_palette.dart';
import 'package:client/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appShellRoute = ShellRoute(
  builder: (context, state, child) => AppRouteShell(child: child),
  routes: [
    GoRoute(
      path: '/app',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/app/add',
      builder: (context, state) => const AddNewQRCodeScreen(),
    ),
    GoRoute(
      path: '/app/analysis',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);

class AppRouteShell extends StatefulWidget {
  const AppRouteShell({super.key, this.child});

  final Widget? child;

  @override
  State<AppRouteShell> createState() => _AppRouteShellState();
}

class _AppRouteShellState extends State<AppRouteShell>
    with TickerProviderStateMixin {
  final tabLocations = ['/app', '/app/add', '/app/analysis'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: !displayBottomNav(getCurrentRouteUri(context))
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: CustomPalette.primary[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _onNavClicked(0);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                            child: ImageIcon(
                              const AssetImage("assets/icons/home.png"),
                              size: 24,
                              color: _getIconColor(0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _onNavClicked(1);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: ImageIcon(
                            const AssetImage("assets/icons/add_circle.png"),
                            size: 24,
                            color: _getIconColor(1),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _onNavClicked(2);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: ImageIcon(
                            const AssetImage("assets/icons/analysis.png"),
                            size: 24,
                            color: _getIconColor(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: widget.child,
    );
  }

  _getIconColor(int index) {
    final path = getCurrentRouteUri(context);

    if (path == tabLocations[index]) {
      return CustomPalette.white;
    } else {
      return CustomPalette.inactive;
    }
  }

  displayBottomNav(String path) {
    return tabLocations.contains(path);
  }

  _onNavClicked(int index) {
    context.go(tabLocations[index]);
  }
}
