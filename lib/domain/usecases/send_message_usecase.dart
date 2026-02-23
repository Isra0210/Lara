import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';

class SendMessageStreamUsecase {
  SendMessageStreamUsecase(this._repo);
  final ChatRepository _repo;

  Stream<String> call({
    required String content,
    String? chatLocalId,
    required Personality personality,
  }) {
    return _repo.sendMessageStream(
      content: content,
      chatLocalId: chatLocalId,
      personality: personality,
    );
  }
}
