import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class GetMessagesUseCase {
  GetMessagesUseCase(this._repo);
  final ChatRepository _repo;

  Future<List<MessageEntity>> call(String chatLocalId) {
    return _repo.getMessages(chatLocalId);
  }
}
