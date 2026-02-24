import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class GetChatsUsecase {
  GetChatsUsecase(this._repository);
  final ChatRepository _repository;

  Future<List<ChatEntity>> call() => _repository.getChats();
}
