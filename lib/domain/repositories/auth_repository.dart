import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<User?> get watchAuthState;

  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle({
    String? emailPasswordToLink,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity>> getCachedUser();
}
