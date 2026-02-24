import 'package:get/get.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/usecases/create_chat_usecase.dart';
import 'package:lara/domain/usecases/delete_chat_usecase.dart';
import 'package:lara/domain/usecases/get_chats_usecase.dart';
import 'package:lara/presentation/presentation.dart';

class HomeController extends GetxController {
  HomeController(this._getChats, this._createChat, this._deleteChat);

  final GetChatsUsecase _getChats;
  final CreateChatUsecase _createChat;
  final DeleteChatUsecase _deleteChat;

  final chats = <ChatEntity>[].obs;
  final isLoading = false.obs;

  bool isScrolled = false;
  void setIsScrolled(bool value) {
    isScrolled = value;
    update();
  }

  Future<void> loadChats() async {
    isLoading.value = true;
    try {
      final result = await _getChats();
      chats.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewChat() async {
    final title = 'Conversa com a Lara ${chats.length + 1}';
    final chat = await _createChat(title);
    chats.insert(0, chat);
    await Get.toNamed(
      ChatPage.route,
      arguments: {'chatId': chat.id, 'title': chat.title},
    );
  }

  Future<void> openChat(ChatEntity chat) async {
    await Get.toNamed(
      '/chat',
      arguments: {'chatId': chat.id, 'title': chat.title},
    );
    await loadChats();
  }

  Future<void> deleteChat(String chatId) async {
    await _deleteChat(chatId);
    chats.removeWhere((c) => c.id == chatId);
  }

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }
}
