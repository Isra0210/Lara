import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/personality_repository.dart';

class GetPersonalityUsecase {
  GetPersonalityUsecase(this.repository);
  final PersonalityRepository repository;

  Future<Personality> call() {
    return repository.getPersonality();
  }
}
