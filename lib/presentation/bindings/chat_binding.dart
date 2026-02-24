import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lara/core/network/connectivity_service.dart';
import 'package:lara/data/datasources/local/chat_local_datasource.dart';
import 'package:lara/data/datasources/local/database/sqflite_helper.dart';
import 'package:lara/data/datasources/local/message_local_datasource.dart';
import 'package:lara/data/datasources/remote/firebase_sync_datasource.dart';
import 'package:lara/data/datasources/remote/gemini_datasource.dart';
import 'package:lara/data/repositories/chat_repository_impl.dart';
import 'package:lara/domain/repositories/chat_repository.dart';
import 'package:lara/domain/usecases/get_messages_usecase.dart';
import 'package:lara/domain/usecases/send_message_usecase.dart';
import 'package:lara/presentation/controller/chat_controller.dart';
import 'package:lara/presentation/controller/settings_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SQFliteHelper>(() => SQFliteHelper.instance, fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);

    Get.lazyPut<ChatLocalDatasource>(
      () => ChatLocalDatasource(Get.find<SQFliteHelper>()),
      fenix: true,
    );
    Get.lazyPut<MessageLocalDatasource>(
      () => MessageLocalDatasourceImpl(Get.find<SQFliteHelper>()),
      fenix: true,
    );
    Get.lazyPut<GeminiDatasource>(() => GeminiDatasource(), fenix: true);
    Get.lazyPut<FirebaseSyncDatasource>(
      () => FirebaseSyncDatasource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
      fenix: true,
    );

    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(
        chatLocal: Get.find<ChatLocalDatasource>(),
        messageLocal: Get.find<MessageLocalDatasource>(),
        gemini: Get.find<GeminiDatasource>(),
        firebaseSync: Get.find<FirebaseSyncDatasource>(),
        connectivity: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => GetMessagesUsecase(Get.find<ChatRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SendMessageUsecase(Get.find<ChatRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => ChatController(
        Get.find<SendMessageUsecase>(),
        Get.find<GetMessagesUsecase>(),
        Get.find<SettingsController>(),
      ),
      fenix: true,
    );
  }
}
