import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class ForgotPasswordButtonWidget extends StatelessWidget {
  const ForgotPasswordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AuthController>(
      builder: (controller) {
        if (controller.authMode != AuthMode.signIn) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Text(
                'Esqueci a senha',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
