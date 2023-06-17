import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkModeController {
  RxBool darkmode = false.obs;
  final box = GetStorage();
  void get() {
    box.writeIfNull('darkmode', false);
    darkmode.value = box.read('darkmode');
  }

  void update(data) {
    darkmode.value = data;
    box.write('darkmode', data);
  }
}
