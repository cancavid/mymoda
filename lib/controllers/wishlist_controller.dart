import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/login_controller.dart';

class WishlistController {
  RxList wishlist = [].obs;
  RxInt quantity = 0.obs;
  final loginController = Get.put(LoginController());

  Future<void> get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/wishlist.php?action=list&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        update(result['wishlist']);
      }
    }
  }

  void update(data) {
    if (data != null) {
      wishlist.value = data;
      count();
    }
  }

  void count() {
    quantity.value = wishlist.length;
  }
}
