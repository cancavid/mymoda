import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/single_product/bottom/add_to_cart.dart';
import 'package:mymoda/components/single_product/bottom/quantity.dart';
import 'package:mymoda/controllers/cart_controller.dart';
import 'package:mymoda/pages/shop/cart.dart';
import 'package:mymoda/pages/shop/single_product.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';

class SingleProductBottom extends StatefulWidget {
  const SingleProductBottom({super.key, required this.data, this.quantity = 1, this.variationId = '0'});

  final int quantity;
  final String variationId;
  final Map data;

  @override
  State<SingleProductBottom> createState() => _SingleProductBottomState();
}

class _SingleProductBottomState extends State<SingleProductBottom> {
  int quantity = 1;
  MsProductType type = MsProductType.simple;
  bool loading = false;

  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();

    quantity = widget.quantity;
    (widget.data['product_type'] == 'simple') ? type = MsProductType.simple : type = MsProductType.variable;
  }

  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity -= 1;
      }
    });
  }

  void increaseQuantity() {
    setState(() {
      quantity += 1;
    });
  }

  void singleAddToCart() {
    if (loading == false) {
      setState(() {
        loading = true;
      });
      addToCart(widget.data['post_id'], widget.variationId, quantity).then((value) {
        setState(() {
          loading = false;
        });
        if (value['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'Səbətə bax',
                  onPressed: () {
                    Navigator.push(context, SlideLeftRoute(page: CartPage()));
                  }),
              content: MsIconText(text: 'Məhsul səbətə əlavə edildi.'),
              backgroundColor: Colors.green));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 70.0), content: MsIconText(text: value['error']), backgroundColor: Colors.red));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuantityWidget(
            quantity: quantity,
            onDecrease: decreaseQuantity,
            onIncrease: increaseQuantity,
          ),
          AddToCartWidget(onTap: singleAddToCart, loading: loading),
        ],
      ),
    );
  }
}
