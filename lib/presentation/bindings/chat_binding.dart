import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lara/data/datasources/local/chat_local_datasource.dart';
import 'package:lara/data/datasources/local/db/db_helper.dart';
import 'package:lara/data/datasources/remote/chat_sync_remote_datasource.dart';
import 'package:lara/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:lara/data/repositories/chat_repository_impl.dart';
import 'package:lara/domain/repositories/chat_repository.dart';
import 'package:lara/domain/usecases/get_messages_usecase.dart';
import 'package:lara/domain/usecases/get_recent_chats_usecase.dart';
import 'package:lara/domain/usecases/retry_pending_sync_usecase.dart';
import 'package:lara/domain/usecases/send_message_usecase.dart';
import 'package:lara/presentation/controller/chat_controller.dart';
import 'package:lara/presentation/controller/settings_controller.dart';
import 'package:uuid/uuid.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DbHelper.instance, fenix: true);
    Get.lazyPut(() => ChatLocalDatasource(Get.find()), fenix: true);

    Get.lazyPut(
      () => GeminiRemoteDatasource(
        apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
        model: 'gemini-1.5-flash',
      ),
      fenix: true,
    );

    Get.lazyPut(() => FirebaseFirestore.instance, fenix: true);
    Get.lazyPut(
      () => ChatSyncRemoteDatasource(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(
        local: Get.find<ChatLocalDatasource>(),
        lara: Get.find<GeminiRemoteDatasource>(),
        sync: Get.find<ChatSyncRemoteDatasource>(),
        uuid: const Uuid(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => GetMessagesUseCase(Get.find<ChatRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SendMessageStreamUsecase(Get.find<ChatRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetRecentChatsUseCase(Get.find<ChatRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => RetryPendingSyncUseCase(Get.find<ChatRepository>()),
      fenix: true,
    );

    //TODO insert get recents chats
    Get.put(
      ChatController(
        getMessages: Get.find<GetMessagesUseCase>(),
        sendMessageStream: Get.find<SendMessageStreamUsecase>(),
        retryPendingSync: Get.find<RetryPendingSyncUseCase>(),
        settings: Get.find<SettingsController>(),
      ),
    );
  }
}
