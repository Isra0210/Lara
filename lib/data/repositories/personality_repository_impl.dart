import 'package:lara/data/datasources/local/personality_local_datasource.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/repositories/personality_repository.dart';

class PersonalityRepositoryImpl implements PersonalityRepository {
  PersonalityRepositoryImpl({required this.localDataSource});

  final PersonalityLocalDatasource localDataSource;

  @override
  Future<Personality> getPersonality() async {
    final personalityString = await localDataSource.getCachedPersonality();

    return Personality.values.firstWhere(
      (e) => e.name == personalityString,
      orElse: () => Personality.goodHumored,
    );
  }

  @override
  Future<void> savePersonality(Personality personality) async {
    await localDataSource.cachePersonality(personality.name);
  }
}
