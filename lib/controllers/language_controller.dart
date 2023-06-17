import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController {
  RxString langText = 'Azərbaycanca'.obs;
  RxString lang = 'az'.obs;
  final box = GetStorage();
  void get() {
    box.writeIfNull('langText', 'Azərbaycanca');
    box.writeIfNull('lang', 'az');
    langText.value = box.read('langText');
    lang.value = box.read('lang');
  }

  void update(data) {
    if (data == 'Azərbaycanca') {
      lang.value = 'az';
    } else if (data == 'Türkçe') {
      lang.value = 'tr';
    } else if (data == 'English') {
      lang.value = 'en';
    }
    box.write('langText', data);
    box.write('lang', lang.value);
    langText.value = data;
    Get.updateLocale(Locale(lang.value, lang.value.toUpperCase()));
  }
}
