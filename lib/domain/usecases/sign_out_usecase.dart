import 'package:dartz/dartz.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  SignOutUsecase(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, void>> call() {
    return _repo.signOut();
  }
}
