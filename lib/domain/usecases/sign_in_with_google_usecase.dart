import 'package:dartz/dartz.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, UserEntity>> call({String? passwordToLinkIfRequired}) {
    return _repo.signInWithGoogle(
      emailPasswordToLink: passwordToLinkIfRequired,
    );
  }
}
