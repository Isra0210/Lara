import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lara/core/core.dart';
import 'package:lara/core/ui/theme/app_theme.dart';
import 'package:lara/presentation/presentation.dart';

class LaraApp extends StatelessWidget {
  const LaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lara',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: SplashPage.route,
      getPages: AppRouter.routes,
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      onInit: () {
        FlutterNativeSplash.remove();
      },
    );
  }
}
