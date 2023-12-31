import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const apiUrl = "https://qrlpixel.link";

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

String formatDate(dynamic date,
    {DateFormatEnum? format, bool withTime = false}) {
  if (date.runtimeType == String) {
    date = DateTime.parse(date);
  } else if (date.runtimeType != DateTime) {
    return "";
  }

  String returnValue;
  if (format == DateFormatEnum.long) {
    returnValue = DateFormat.yMMMMd().format(date).toString();
  } else {
    returnValue = DateFormat.yMMMd().format(date).toString();
  }

  if (withTime) {
    returnValue += " ${DateFormat.jm().format(date).toString()}";
  }

  return returnValue;
}

bool checkIfValueIsEmptyStringOrNull(String? a) {
  if (a == null) {
    return true;
  }

  return a.trim().isEmpty;
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email.toString().trim());
}

bool isValidUrl(String url) {
  return Uri.parse(url.toString().trim()).isAbsolute;
}

String? emailTextFieldValidator(value) {
  if (checkIfValueIsEmptyStringOrNull(value)) {
    return "Email cannot be empty";
  } else if (!isValidEmail(value!)) {
    return "Please enter a valid email";
  }

  return null;
}

String? passwordTextFieldValidator(value) {
  if (checkIfValueIsEmptyStringOrNull(value)) {
    return "Password cannot be empty";
  }

  if (value!.length < 6) {
    return "Password must be at least 8 characters";
  }
  return null;
}

String appendHttpIfNotPresent(String url) {
  if (!url.startsWith("http://") && !url.startsWith("https://")) {
    return "https://$url";
  }

  return url;
}

String compactNumber(dynamic value) {
  final decimalRegex = RegExp(r'^[-+]?(?:\d*\.\d+|\d+\.?)$');

  if (value.runtimeType == String && !decimalRegex.hasMatch(value) ||
      value == null) {
    value = 0;
  }

  if (value.runtimeType == String) {
    value = double.parse(value);
  }
  return NumberFormat.compact().format(value);
}

//
//
enum DateFormatEnum { short, long, time }
