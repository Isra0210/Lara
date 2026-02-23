import 'package:get/get.dart';

class TextFieldValidator {
  static String? checkIfEmpty(String value) {
    if (value.isEmpty) return 'Campo obrigatório';

    return null;
  }

  static String? checkMinChar(String value, {int minChar = 6}) {
    final checkEmpty = checkIfEmpty(value);

    if (checkEmpty != null) return checkIfEmpty(value);

    if (value.length < minChar) {
      return 'Deve conter pelo menos $minChar caracteres';
    }

    return null;
  }

  static String? checkName(String name) {
    final checkEmpty = checkIfEmpty(name);
    final minChar = checkMinChar(name);
    final regex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$');
    if (checkEmpty != null) return checkIfEmpty(name);
    if (minChar != null) return checkMinChar(name);
    final hasNumber = RegExp(r'[0-9]').hasMatch(name);
    if (hasNumber) {
      return 'O nome não pode conter números';
    }
    if (!regex.hasMatch(name)) return 'O nome só pode conter letras';
    return null;
  }

  static String? checkEmail(String value) {
    final checkEmpty = checkIfEmpty(value);

    if (checkEmpty != null) return checkIfEmpty(value);

    final isValidEmail = GetUtils.isEmail(value);

    if (!isValidEmail) return 'E-mail inválido';

    return null;
  }
}
