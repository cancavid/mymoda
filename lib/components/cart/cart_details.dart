import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/pages/shop/single_product.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/theme.dart';

// ignore: must_be_immutable
class CartItemDetails extends StatelessWidget {
  CartItemDetails({super.key, required this.cartItemData, required this.onTap});

  final Map cartItemData;
  final Function(String, String, int, String, String) onTap;

  List attr = [];
  String price = '';

  @override
  Widget build(BuildContext context) {
    if (cartItemData['data']['size_name'] != null) {
      attr.add(cartItemData['data']['size_name']);
    }
    if (cartItemData['data']['color_name'] != null) {
      attr.add(cartItemData['data']['color_name']);
    }

    if (cartItemData['cart_variation_id'] == 0) {
      price = cartItemData['data']['final_price'];
    } else {
      price = cartItemData['data']['variation_final_price'];
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.to(() => SingleProductPage(data: cartItemData['data']));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 45.0),
                    child: Text(cartItemData['data']['post_title'], style: TextStyle(height: 1.4)),
                  )),
              SizedBox(height: 3.0),
              Text(attr.join(', '), style: TextStyle(color: Theme.of(context).colorScheme.greyColor))
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fullPrice(price), style: TextStyle(fontSize: 16.0)),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        onTap(cartItemData['cart_product_id'], cartItemData['cart_variation_id'].toString(), 1, 'decrease', cartItemData['cart_date']);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.lightColor, borderRadius: BorderRadius.circular(4.0)),
                          child: Icon(
                            Icons.remove,
                            size: 15.0,
                          ))),
                  SizedBox(
                      width: 40.0,
                      child: Text(
                        cartItemData['cart_quantity'].toString(),
                        textAlign: TextAlign.center,
                      )),
                  GestureDetector(
                      onTap: () {
                        onTap(cartItemData['cart_product_id'], cartItemData['cart_variation_id'].toString(), 1, 'increase', cartItemData['cart_date']);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.lightColor, borderRadius: BorderRadius.circular(4.0)),
                          child: Icon(
                            Icons.add,
                            size: 15.0,
                          ))),
                  SizedBox(width: 5.0)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
