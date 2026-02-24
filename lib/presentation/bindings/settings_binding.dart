import 'package:get/get.dart';
import 'package:lara/data/datasources/local/personality_local_datasource.dart';
import 'package:lara/data/datasources/local/theme_local_datasource.dart';
import 'package:lara/data/repositories/personality_repository_impl.dart';
import 'package:lara/data/repositories/theme_repository_impl.dart';
import 'package:lara/domain/repositories/personality_repository.dart';
import 'package:lara/domain/repositories/theme_repository.dart';
import 'package:lara/domain/usecases/get_personality_usecase.dart';
import 'package:lara/domain/usecases/get_theme_usecase.dart';
import 'package:lara/domain/usecases/save_personality_usecase.dart';
import 'package:lara/domain/usecases/save_theme_usecase.dart';
import 'package:lara/presentation/controller/settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ThemeLocalDatasource>(ThemeLocalDatasource());
    Get.put<ThemeRepository>(
      ThemeRepositoryImpl(localDataSource: Get.find<ThemeLocalDatasource>()),
    );
    Get.put<PersonalityLocalDatasource>(PersonalityLocalDatasource());
    Get.put<PersonalityRepository>(
      PersonalityRepositoryImpl(
        localDataSource: Get.find<PersonalityLocalDatasource>(),
      ),
    );

    Get.put(GetThemeUsecase(Get.find<ThemeRepository>()));
    Get.put(SaveThemeUsecase(Get.find<ThemeRepository>()));
    Get.put(GetPersonalityUsecase(Get.find<PersonalityRepository>()));
    Get.put(SavePersonalityUsecase(Get.find<PersonalityRepository>()));

    Get.put(
      SettingsController(
        getThemeUsecase: Get.find<GetThemeUsecase>(),
        saveThemeUsecase: Get.find<SaveThemeUsecase>(),
        getPersonalityUsecase: Get.find<GetPersonalityUsecase>(),
        savePersonalityUsecase: Get.find<SavePersonalityUsecase>(),
      ),
      permanent: true,
    );
  }
}
