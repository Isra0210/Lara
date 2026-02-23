import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_icons.dart';
import 'package:lara/core/ui/widgets/text_field_widget.dart';
import 'package:lara/core/validator/text_field_validator.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class AuthFormWidget extends StatelessWidget {
  const AuthFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Column(
            spacing: 12,
            children: [
              if (controller.authMode == AuthMode.signUp)
                TextFieldWidget(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  controller: controller.nameController,
                  prefix: Icon(size: 20, AppIcons.user),
                  hintText: 'Nome',
                  validator: (value) => TextFieldValidator.checkName(value!),
                ),
              TextFieldWidget(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                prefix: Icon(size: 20, AppIcons.email),
                hintText: 'E-mail',
                validator: (value) => TextFieldValidator.checkEmail(value!),
              ),
              TextFieldWidget(
                textInputAction: TextInputAction.done,
                controller: controller.passwordController,
                prefix: Icon(size: 20, AppIcons.lock),
                hintText: 'Senha',
                obscureText: controller.obscurePassword,
                suffix: InkWell(
                  onTap: controller.toggleObscurePassword,
                  child: Icon(
                    size: 20,
                    controller.obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
                  ),
                ),
                validator: (value) => TextFieldValidator.checkMinChar(value!),
              ),
            ],
          ),
        );
      },
    );
  }
}
