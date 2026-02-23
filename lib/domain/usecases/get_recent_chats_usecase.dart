import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class GetRecentChatsUseCase {
  GetRecentChatsUseCase(this._repo);
  final ChatRepository _repo;

  Future<List<ChatEntity>> call() {
    return _repo.getRecentChats();
  }
}
