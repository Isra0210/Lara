import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/presentation/controller/auth_controller.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Future.delayed(const Duration(seconds: 2)).then((_) {
        authController.watchUserState();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset(AppImages.loadingAnimation)),
    );
  }
}
