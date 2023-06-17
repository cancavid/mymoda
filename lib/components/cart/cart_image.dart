import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/pages/shop/single_product.dart';
import 'package:mymoda/themes/options.dart';

class CartImage extends StatefulWidget {
  const CartImage({super.key, required this.cartItemData});

  final Map cartItemData;

  @override
  State<CartImage> createState() => _CartImageState();
}

class _CartImageState extends State<CartImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SingleProductPage(data: widget.cartItemData['data']));
      },
      child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: MsImage(url: widget.cartItemData['data']['media_url'], width: 80.0, height: 100.0)),
    );
  }
}
