import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class EnterButtonWidget extends StatelessWidget {
  const EnterButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        final isSignIn = controller.authMode == AuthMode.signIn;

        if (isSignIn) {
          return ElevatedButton(
            onPressed: () async => await controller.loginEmail(),
            child: const Text('Entrar'),
          );
        }

        return ElevatedButton(
          onPressed: () async => await controller.registerEmail(),
          child: const Text('Cadastrar'),
        );
      },
    );
  }
}
