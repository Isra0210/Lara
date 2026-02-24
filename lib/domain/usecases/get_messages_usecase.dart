import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class GetMessagesUsecase {
  GetMessagesUsecase(this._repository);
  final ChatRepository _repository;

  Future<List<MessageEntity>> call(String chatId) =>
      _repository.getMessages(chatId);
}
