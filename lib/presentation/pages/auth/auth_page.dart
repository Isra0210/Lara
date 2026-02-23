import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/presentation/controller/auth_controller.dart';
import 'package:lara/presentation/pages/auth/widgets/enter_button_widget.dart';
import 'package:lara/presentation/pages/auth/widgets/widgets.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const String route = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Get.find<AuthController>();

  @override
  void initState() {
    controller.nameController = TextEditingController();
    controller.emailController = TextEditingController();
    controller.passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.nameController.dispose();
    controller.emailController.dispose();
    controller.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final backgroundImage = Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundImage,
          const CopyrightWidget(),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth > 600
                    ? constraints.maxWidth * 0.6
                    : constraints.maxWidth;

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow,
                              blurRadius: 4,
                              spreadRadius: 0.4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: const Column(
                          children: [
                            FormHeaderWidget(),
                            Column(
                              spacing: 12,
                              children: [
                                AuthFormWidget(),
                                ForgotPasswordButtonWidget(),
                                EnterButtonWidget(),
                                LoginSocialButtonWidget(),
                                SizedBox(height: 12),
                                SignUpButtonWidget(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
