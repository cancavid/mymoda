import 'package:flutter/material.dart';
import 'package:mymoda/components/cart/cart_details.dart';
import 'package:mymoda/themes/theme.dart';

import 'cart_image.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemData, required this.onTapRemove, required this.onTapUpdate});

  final Map cartItemData;
  final Function(String, String) onTapRemove;
  final Function(String, String, int, String, String) onTapUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.lightColor))),
      child: Stack(
        children: [
          Row(
            children: [CartImage(cartItemData: cartItemData), SizedBox(width: 15.0), CartItemDetails(cartItemData: cartItemData, onTap: onTapUpdate)],
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                onTapRemove(cartItemData['cart_product_id'], cartItemData['cart_variation_id']);
              },
              child: Transform.translate(
                offset: Offset(20.0, -20.0),
                child: Container(padding: const EdgeInsets.all(20.0), child: Icon(Icons.close, size: 18.0, color: Theme.of(context).colorScheme.greyColor)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
