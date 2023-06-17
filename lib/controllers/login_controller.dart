import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/cart_controller.dart';
import 'package:mymoda/controllers/wishlist_controller.dart';

class LoginController {
  RxBool login = false.obs;
  RxString token = ''.obs;
  RxMap userdata = {}.obs;
  final box = GetStorage();

  void get() {
    box.writeIfNull('login', false);
    box.writeIfNull('platform', '');
    if (box.read('token') == null) {
      create();
    } else {
      token.value = box.read('token');
    }
    login.value = box.read('login');
    if (login.value) {
      getuserdata();
    } else {
      getguestdata();
    }
  }

  void update(ulogin, udata, [platform = '']) {
    box.write('login', ulogin);
    box.write('token', udata['token']);
    box.write('platform', platform);
    login.value = ulogin;
    token.value = udata['token'];
    userdata.value = udata;
    var wishlistController = Get.put(WishlistController());
    var cartController = Get.put(CartController());
    wishlistController.update(userdata['session_wishlist']);
    cartController.update(userdata['session_cart']);
  }

  Future<void> create() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/auth.php?action=create');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        token.value = result['result'];
        box.write('token', token.value);
        box.write('guest', token.value);
      }
    }
  }

  Future<void> getuserdata() async {
    var wishlistController = Get.put(WishlistController());
    var cartController = Get.put(CartController());

    var url = Uri.parse('https://fashion.betasayt.com/api/users.php?action=get&token=${token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success' && result['result']['user_status'] == '1') {
        userdata.value = result['result'];
        wishlistController.update(userdata['session_wishlist']);
        cartController.update(userdata['session_cart']);
      } else {
        login.value = false;
        var guest = box.read('guest');
        if (guest != null) {
          token.value = guest;
        }
      }
    }
  }

  Future<void> getguestdata() async {
    var wishlistController = Get.put(WishlistController());
    var cartController = Get.put(CartController());

    var url = Uri.parse('https://fashion.betasayt.com/api/users.php?action=session&token=${token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        wishlistController.update(result['result']['session_wishlist']);
        cartController.update(result['result']['session_cart']);
      } else {
        wishlistController.update([]);
        cartController.update([]);
      }
    }
  }

  void logout() async {
    token.value = box.read('guest');
    login.value = false;
    box.write('login', false);
    box.write('token', token.value);
    String platform = box.read('platform');
    if (platform == 'Google') {
      await GoogleSignIn().disconnect();
    } else if (platform == 'Facebook') {
      // await FacebookAuth.instance.logOut();
    }
    getguestdata();
  }
}
