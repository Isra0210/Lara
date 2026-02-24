import 'package:get/get.dart';
import 'package:lara/domain/usecases/create_chat_usecase.dart';
import 'package:lara/domain/usecases/delete_chat_usecase.dart';
import 'package:lara/domain/usecases/get_chats_usecase.dart';
import 'package:lara/presentation/controller/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetChatsUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateChatUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteChatUsecase(Get.find()), fenix: true);

    Get.put<HomeController>(
      HomeController(
        Get.find<GetChatsUsecase>(),
        Get.find<CreateChatUsecase>(),
        Get.find<DeleteChatUsecase>(),
      ),
      permanent: true,
    );
  }
}
