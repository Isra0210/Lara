import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lara/core/errors/error_mapper.dart';
import 'package:lara/core/errors/exceptions.dart';
import 'package:lara/core/errors/failure.dart';
import 'package:lara/data/datasources/local/auth_local_datasource.dart';
import 'package:lara/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lara/data/models/user_model.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDatasource _remote;
  final AuthLocalDataSource _local;

  @override
  Stream<User?> get watchAuthState => _remote.watchAuthState();

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _remote.registerWithEmail(email, password);
      if (cred.user == null) throw NullUserException();

      final fbModel = UserModel.fromFirebaseUser(cred.user!);
      final modelUpdated = {
        ...fbModel.toMap(),
        'createdAt': Timestamp.now(),
        'displayName': name,
      };

      final model = UserModel.fromJson(modelUpdated);

      await _remote.createUserDocument(modelUpdated, cred.user!.uid);
      await _local.cacheUser(model.toMapCache());
      return right(model);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _remote.signInWithEmail(email, password);
      if (cred.user == null) throw NullUserException();

      final userDoc = await _remote.getOrCreateUserDocument(user: cred.user!);

      final model = UserModel.fromJson(userDoc);

      await _local.cacheUser(model.toMapCache());
      return right(model);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle({
    String? emailPasswordToLink,
  }) async {
    try {
      final cred = await _remote.signInWithGoogleAndLinkIfNeeded(
        passwordToLinkIfRequired: emailPasswordToLink,
      );

      if (cred.user == null) throw NullUserException();

      final userDoc = await _remote.getOrCreateUserDocument(user: cred.user!);

      final model = UserModel.fromJson(userDoc);

      await _local.cacheUser(model.toMapCache());
      return right(model);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remote.signOut();
      await _local.clear();
      // ignore: void_checks
      return right(unit);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUser() async {
    try {
      final u = await _local.getCachedUser();
      return right(u!);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
