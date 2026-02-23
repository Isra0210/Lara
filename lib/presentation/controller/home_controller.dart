import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isScrolled = false;
  void setIsScrolled(bool value) {
    isScrolled = value;
    update();
  }
}
