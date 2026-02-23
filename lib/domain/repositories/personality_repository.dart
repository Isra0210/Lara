import 'package:lara/domain/entities/chat_entity.dart';

abstract class PersonalityRepository {
  Future<Personality> getPersonality();
  Future<void> savePersonality(Personality personality);
}
