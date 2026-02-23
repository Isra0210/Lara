import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static void show({Color color = Colors.white}) {
    Get.dialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator(color: color)
              : CircularProgressIndicator(color: color),
        ),
      ),
    );
  }

  static void hidden() => Get.back();
}
