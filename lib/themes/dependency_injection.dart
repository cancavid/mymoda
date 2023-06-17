import 'package:get/get.dart';
import 'package:mymoda/controllers/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
