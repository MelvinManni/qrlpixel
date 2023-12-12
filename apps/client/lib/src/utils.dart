import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This function is used to clear the stack and navigate to a new route
clearStackAndNavigate(BuildContext context, String routeName) {
  if (context.mounted) {
    while (context.canPop()) {
      context.pop();
    }

    context.replace(routeName);
  }
}

String getCurrentRouteUri(BuildContext context) {
  return GoRouter.of(context)
      .routerDelegate
      .currentConfiguration
      .uri
      .toString();
}
