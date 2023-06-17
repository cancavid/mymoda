import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/login_controller.dart';

class CartController {
  RxList cart = [].obs;
  RxInt quantity = 0.obs;
  final loginController = Get.put(LoginController());

  Future<void> get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=get&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        cart.value = result['result']['cart'];
        count();
      }
    }
  }

  void update(data) {
    cart.value = data;
    count();
  }

  void count() {
    int count = 0;
    for (int i = 0; i < cart.length; i++) {
      count = count + int.parse(cart[i]['cart_quantity'].toString());
    }
    quantity.value = count;
  }
}
