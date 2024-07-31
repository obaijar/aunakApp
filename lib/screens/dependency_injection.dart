// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

import 'controller/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
