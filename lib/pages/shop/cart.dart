import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/cart/cart_bottom.dart';
import 'package:mymoda/components/cart/cart_item.dart';
import 'package:mymoda/controllers/cart_controller.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/widgets/notify.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool loading = true;
  bool updateLoading = false;
  String id = '';
  Map result = {};
  List cart = [];
  String error = '';
  String totalPrice = '';
  String displaySale = '';
  String finalPrice = '';
  int cartLength = 0;
  var loginController = Get.put(LoginController());
  var cartController = Get.put(CartController());

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=get&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            cart = result['result']['cart'];
            totalPrice = result['result']['total_price'].toString();
            displaySale = result['result']['display_sale'];
            finalPrice = result['result']['final_price'].toString();
            error = result['result']['error'];
            cartController.update(cart);
            cartLength = cart.length;
          } else {
            error = result['error'];
          }
        });
      }
    }
  }

  update(product, variation, quantity, process, date) async {
    setState(() {
      updateLoading = true;
    });
    var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=update&product_id=$product&variation_id=$variation&quantity=$quantity&process=$process&date=$date&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          updateLoading = false;
          result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            cart = result['result']['cart'];
            totalPrice = result['result']['total_price'].toString();
            displaySale = result['result']['display_sale'];
            finalPrice = result['result']['final_price'].toString();
            error = result['result']['error'];
            cartController.update(cart);
          } else {
            error = result['error'];
          }
        });
      }
    }
  }

  remove(product, variation) async {
    setState(() {
      updateLoading = true;
    });
    var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=remove&product_id=$product&variation_id=$variation&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          updateLoading = false;
          result = json.decode(utf8.decode(response.bodyBytes));
          if (result['status'] == 'success') {
            cart = result['result']['cart'];
            totalPrice = result['result']['total_price'].toString();
            displaySale = result['result']['display_sale'];
            finalPrice = result['result']['final_price'].toString();
            error = result['result']['error'];
            cartController.update(cart);
          } else {
            error = result['error'];
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    id = loginController.token.value;
    get();
  }

  @override
  Widget build(BuildContext context) {
    ever(cartController.quantity, (_) {
      if (cartController.quantity.value != cartLength) {
        get();
      }
    });

    return Scaffold(
        appBar: AppBar(title: Text('Səbət')),
        body: RoundedBody(
            child: (loading)
                ? MsIndicator()
                : RefreshIndicator(
                    onRefresh: () {
                      return get();
                    },
                    child: (cart.isEmpty)
                        ? ListView(
                            children: const [
                              MsNotify(icon: Icons.shopping_cart_rounded, heading: 'Sizin səbətiniz hal-hazırda boşdur.'),
                            ],
                          )
                        : Stack(
                            children: [
                              ListView.builder(
                                itemCount: cart.length,
                                itemBuilder: (context, index) {
                                  return CartItem(cartItemData: cart[index], onTapRemove: remove, onTapUpdate: update);
                                },
                              ),
                              if (updateLoading) ...[PageLoader()]
                            ],
                          ),
                  )),
        bottomNavigationBar: (cart.isNotEmpty) ? CartBottom(error: error, result: result) : null);
  }
}
