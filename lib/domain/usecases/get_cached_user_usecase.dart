import 'package:dartz/dartz.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class GetCachedUserUseCase {
  GetCachedUserUseCase(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, UserEntity?>> call() {
    return _repo.getCachedUser();
  }
}
