import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class LoginSocialButtonWidget extends StatelessWidget {
  const LoginSocialButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        spacing: 4,
        children: [
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Ou continue com',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: controller.loginGoogle,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(AppImages.google, height: 60, width: 60),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
