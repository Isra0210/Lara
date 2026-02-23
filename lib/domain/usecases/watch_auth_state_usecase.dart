import 'package:firebase_auth/firebase_auth.dart';
import 'package:lara/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._repo);
  final AuthRepository _repo;

  Stream<User?> get user => _repo.watchAuthState;
}
