import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/personality_repository.dart';

class SavePersonalityUsecase {
  SavePersonalityUsecase(this.repository);
  final PersonalityRepository repository;

  Future<void> call(Personality personality) {
    return repository.savePersonality(personality);
  }
}
