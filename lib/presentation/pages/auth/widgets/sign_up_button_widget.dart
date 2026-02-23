import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class SignUpButtonWidget extends StatelessWidget {
  const SignUpButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AuthController>(
      builder: (controller) {
        final isSignIn = controller.authMode == AuthMode.signIn;

        if (!isSignIn) {
          return Column(
            children: [
              Text(
                'Já possui uma conta?',
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              OutlinedButton(
                onPressed: () => controller.setAuthMode(AuthMode.signIn),
                child: const Text('Login'),
              ),
            ],
          );
        }

        return Column(
          children: [
            Text(
              'Não tem uma conta?',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
            OutlinedButton(
              onPressed: () => controller.setAuthMode(AuthMode.signUp),
              child: const Text('Cadastrar-se'),
            ),
          ],
        );
      },
    );
  }
}
