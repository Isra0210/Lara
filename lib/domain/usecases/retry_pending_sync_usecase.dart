import 'package:lara/domain/repositories/chat_repository.dart';

class RetryPendingSyncUseCase {
  RetryPendingSyncUseCase(this._repo);
  final ChatRepository _repo;

  Future<void> call() {
    return _repo.retryPendingSync();
  }
}
