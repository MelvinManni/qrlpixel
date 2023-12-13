import 'package:flutter/material.dart';

enum SnackAlertType { error, success, info, warning }

initSnackBar(BuildContext context, String message, SnackAlertType type) {
  final snackBar = SnackBar(
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color(
      type == SnackAlertType.success
          ? 0xFFE9FFF3
          : type == SnackAlertType.error
              ? 0xffFFE9E9
              : SnackAlertType.info == type
                  ? 0xffE1FDFF
                  : SnackAlertType.warning == type
                      ? 0xffFFE7E0
                      : 0xffFFF4E5,
    ),
    elevation: 0.5,
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150, left: 5, right: 5),
    duration: const Duration(seconds: 2),
    content: Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      constraints: const BoxConstraints(
        maxHeight: 100,
      ),
      child: Text(
        message,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodyMedium?.merge(
              TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Color(
                  type == SnackAlertType.success
                      ? 0xFF219653
                      : type == SnackAlertType.error
                          ? 0xffE42A2A
                          : SnackAlertType.info == type
                              ? 0xff2F80ED
                              : SnackAlertType.warning == type
                                  ? 0xffF2994A
                                  : 0xff000000,
                ),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
