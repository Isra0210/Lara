import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    this.controller,
    this.validator,
    this.suffix,
    this.hintText,
    this.maxLenght,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.multiline,
    this.prefix,
    this.labelText,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? suffix;
  final Widget? prefix;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLenght;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLenght,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffix,
        prefixIcon: prefix,
        hintText: hintText,
      ),
    );
  }
}
