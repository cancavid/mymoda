import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController {
  RxBool notification = true.obs;
  final box = GetStorage();
  void get() {
    box.writeIfNull('notification', true);
    notification.value = box.read('notification');
  }

  void update(data) {
    notification.value = data;
    box.write('notification', data);
  }
}
