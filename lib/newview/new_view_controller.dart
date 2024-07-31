// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs; // 'obs' makes the variable reactive

  void increment() {
    count++;
  }
}
