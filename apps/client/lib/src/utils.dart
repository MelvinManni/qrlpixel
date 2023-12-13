import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

String formatDate(dynamic date, [DateFormatEnum? format]) {
  if (date.runtimeType == String) {
    date = DateTime.parse(date);
  } else if (date.runtimeType != DateTime) {
    return "";
  }

  if (format == DateFormatEnum.long) {
    return DateFormat.yMMMMd().format(date).toString();
  }
  return DateFormat.yMMMd().format(date).toString();
}

bool checkIfValueIsEmptyStringOrNull(String? a) {
  if (a == null) {
    return true;
  }

  return a.trim().isEmpty;
}

//
//
enum DateFormatEnum { short, long }
