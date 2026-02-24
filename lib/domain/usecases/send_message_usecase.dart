import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class SendMessageUsecase {
  SendMessageUsecase(this._repository);
  final ChatRepository _repository;

  Future<MessageEntity> call({
    required MessageEntity userMessage,
    required List<MessageEntity> history,
    required String personality,
  }) =>
      _repository.sendMessage(
        userMessage: userMessage,
        history: history,
        personality: personality,
      );
}
