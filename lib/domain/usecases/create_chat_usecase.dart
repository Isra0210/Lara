import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class CreateChatUsecase {
  CreateChatUsecase(this._repository);
  final ChatRepository _repository;

  Future<ChatEntity> call(String title) => _repository.createChat(title);
}
