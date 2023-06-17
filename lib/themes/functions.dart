import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymoda/controllers/cart_controller.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/controllers/wishlist_controller.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;

check(data) {
  if (data != null && data != '' && data != 0) {
    return true;
  } else {
    return false;
  }
}

String humanDate(value) {
  var now = DateTime.now();
  var formatter = DateFormat('dd.MM.yyyy');
  String today = formatter.format(now);
  String yesterday = formatter.format(DateTime.now().subtract(const Duration(days: 1)));
  String date = DateFormat("dd.MM.yyyy").format(DateTime.parse(value));

  if (date == today) {
    String dateMinutes = DateFormat("HH:mm").format(DateTime.parse(value));
    date = 'Bugün $dateMinutes';
  } else if (date == yesterday) {
    String dateMinutes = DateFormat("HH:mm").format(DateTime.parse(value));
    date = 'Dünən $dateMinutes';
  } else {
    date = DateFormat("dd.MM.yyyy HH:mm").format(DateTime.parse(value));
  }

  return date;
}

getOrderStatus(status) {
  String data = 'Gözləyir';
  if (status == 'pending') {
    data = 'Gözləyir';
  } else if (status == 'confirmed') {
    data = 'Təsdiqləndi';
  } else if (status == 'completed') {
    data = 'Tamamlandı';
  } else if (status == 'canceled') {
    data = 'İmtina edildi';
  } else if (status == 'whatsapp') {
    data = 'Whatsapp sifarişi';
  }
  return data;
}

getPaymentMethod(method) {
  String method = 'Qapıda ödəniş';
  if (method == 'online') {
    method = 'Onlayn ödəniş';
  } else if (method == 'offline') {
    method = 'Qapıda ödəniş';
  }
  return method;
}

displayPrice(regularPrice, salePrice, finalPrice) {
  List price = ['', ''];
  if (check(finalPrice)) {
    price[0] = '$finalPrice ${Shop.currency}';
    if (check(salePrice)) {
      price[1] = regularPrice;
    }
  }
  return price;
}

fullPrice(price) {
  return '$price ${Shop.currency}';
}

widgetPrice(regularPrice, salePrice, finalPrice) {
  List price = displayPrice(regularPrice, salePrice, finalPrice);
  return Row(
    children: [Text(price[0], style: TextStyle(fontSize: 30.0)), SizedBox(width: 10.0), Text(price[1], style: TextStyle(decoration: TextDecoration.lineThrough))],
  );
}

wishlistUpdate(id, product) async {
  var url = Uri.parse('https://fashion.betasayt.com/api/wishlist.php?action=update&session=$id&product_id=$product');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'success') {
      return 'success';
    } else {
      return 'error';
    }
  }
}

addToCart(productId, variationId, quantity) async {
  final loginController = Get.put(LoginController());
  final cartController = Get.put(CartController());
  var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=update&product_id=$productId&variation_id=$variationId&quantity=$quantity&token=${loginController.token.value}');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'success') {
      cartController.update(result['result']['cart']);
    }
    return result;
  }
}

addWishlist(productId) async {
  final loginController = Get.put(LoginController());
  final wishlistController = Get.put(WishlistController());
  var url = Uri.parse('https://fashion.betasayt.com/api/wishlist.php?action=update&product_id=$productId&token=${loginController.token.value}');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'success') {
      wishlistController.update(result['result']['list']);
    }
    return result;
  }
}

getTerm(term) async {
  var url = Uri.parse('https://fashion.betasayt.com/api/terms.php?taxonomy=$term');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'success') {
      return result['terms'];
    }
  }
}

hexToColor(String colorCode) {
  String colorString = colorCode.replaceAll('#', '0xFF');
  return Color(int.parse(colorString));
}

errorNetwork() {
  Get.rawSnackbar(
      padding: const EdgeInsets.all(10.0),
      backgroundColor: Color.fromARGB(255, 231, 17, 2),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_outlined, color: Colors.white, size: 16.0), SizedBox(width: 10.0), Text('İnternətə qoşulu deyilsiniz.', style: TextStyle(color: Colors.white))],
      ),
      duration: Duration(seconds: 3));
}
