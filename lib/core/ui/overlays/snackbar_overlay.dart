import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kSmallSize = 6.0;
const kDefaultSize = 8.0;

class SnackbarOverlay {
  static void success(String text, {TextStyle? style}) {
    return _showCustomSnackBar(
      text,
      icon: const Icon(
        CupertinoIcons.check_mark_circled_solid,
        color: Colors.green,
      ),
      style: style,
    );
  }

  static void warning(String text, {TextStyle? style}) {
    return _showCustomSnackBar(
      text,
      icon: Icon(
        CupertinoIcons.exclamationmark_triangle_fill,
        color: Colors.amber.shade700,
      ),
      style: style,
    );
  }

  static void error(String text, {TextStyle? style}) {
    return _showCustomSnackBar(
      text,
      icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red),
      style: style,
    );
  }

  static void _showCustomSnackBar(
    String text, {
    required Icon icon,
    TextStyle? style,
  }) {
    Get.snackbar(
      '',
      '',
      icon: icon,
      backgroundColor: Colors.black54,
      titleText: const SizedBox(),
      messageText: Padding(
        padding: const EdgeInsets.only(bottom: kDefaultSize),
        child: Text(text, style: style ?? const TextStyle(color: Colors.white)),
      ),
      snackStyle: SnackStyle.FLOATING,
      colorText: Colors.white,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        left: kSmallSize,
        right: kSmallSize,
        top: kDefaultSize,
      ),
      borderRadius: kSmallSize,
    );
  }
}
