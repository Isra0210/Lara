import 'package:get/route_manager.dart';
import 'package:lara/presentation/bindings/chat_binding.dart';
import 'package:lara/presentation/presentation.dart';

class AppRouter {
  static final routes = [
    GetPage(name: SplashPage.route, page: () => const SplashPage()),
    GetPage(name: AuthPage.route, page: () => const AuthPage()),
    GetPage(
      name: HomePage.route,
      page: () => const HomePage(),
      binding: HomeBinding(),
      bindings: [ChatBinding()],
    ),
    GetPage(name: SettingsPage.route, page: () => const SettingsPage()),
    GetPage(name: ChatPage.route, page: () => const ChatPage()),
  ];
}
