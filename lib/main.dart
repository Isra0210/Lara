import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lara/firebase_options.dart';
import 'package:lara/lara_app.dart';
import 'package:lara/presentation/bindings/settings_binding.dart';

void main() {
  void handleError(Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  }

  runZonedGuarded<Future<void>>(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    SettingsBinding().dependencies();

    runApp(const LaraApp());
  }, handleError);
}
