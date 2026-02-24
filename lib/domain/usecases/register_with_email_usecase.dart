import 'package:dartz/dartz.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class RegisterWithEmailUsecase {
  RegisterWithEmailUsecase(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repo.registerWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }
}
