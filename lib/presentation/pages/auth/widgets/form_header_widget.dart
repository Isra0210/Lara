import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<AuthController>(
      builder: (controller) {
        final isSignin = controller.authMode == AuthMode.signIn;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            isSignin ? 'Login' : 'Cadastro',
            style: theme.textTheme.titleLarge,
          ),
        );
      },
    );
  }
}
