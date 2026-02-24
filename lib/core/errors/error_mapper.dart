import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lara/core/errors/failure.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is SocketException) {
    return const NetworkFailure('Sem conexão com a internet.');
  }

  if (e is TimeoutException) {
    return const TimeoutFailure('Tempo de resposta excedido (timeout).');
  }

  if (e is PlatformException) {
    return const PlatformFailure(
      'O login do Google precisa ser feito através do botão nativo nesta plataforma.',
    );
  }

  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'google-auth-failed':
        return const GoogleAuthFailure(
          'Operação cancelada',
        );
      case 'permission-denied':
        return const DatabaseFailure(
          'Sem permissão para acessar o banco de dados.',
        );
      case 'unavailable':
        return const NetworkFailure(
          'Serviço de banco de dados temporariamente indisponível.',
        );
      case 'deadline-exceeded':
        return const TimeoutFailure('O tempo para salvar os dados esgotou.');
      case 'too-many-requests':
        return RateLimitFailure(
          'Muitas tentativas. Tente novamente mais tarde.',
          code: e.code,
        );

      case 'invalid-api-key':
      case 'api-key-not-valid.-please-pass-a-valid-api-key.':
        return InvalidApiKeyFailure('Chave inválida (API Key).', code: e.code);

      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure('E-mail ou senha inválidos.', code: e.code);

      case 'email-already-in-use':
        return AuthFailure('Este e-mail já está em uso.', code: e.code);

      case 'user-disabled':
        return AuthFailure('Usuário desabilitado.', code: e.code);

      case 'account-exists-with-different-credential':
        return AuthFailure(
          'Este e-mail já está cadastrado com outro provedor. Faça login pelo método original para vincular.',
          code: e.code,
        );

      default:
        return AuthFailure(e.message ?? 'Falha de autenticação.', code: e.code);
    }
  }

  return UnknownFailure('Erro inesperado.', code: e.toString());
}
