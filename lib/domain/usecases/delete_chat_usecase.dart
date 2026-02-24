import 'package:lara/domain/repositories/chat_repository.dart';

class DeleteChatUsecase {
  DeleteChatUsecase(this._repository);
  final ChatRepository _repository;

  Future<void> call(String chatId) => _repository.deleteChat(chatId);
}
