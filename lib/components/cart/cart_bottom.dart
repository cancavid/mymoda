import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/pages/shop/checkout.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/methods.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/buttons.dart';

class CartBottom extends StatefulWidget {
  final String error;
  final Map result;

  const CartBottom({super.key, required this.error, required this.result});

  @override
  State<CartBottom> createState() => _CartBottomState();
}

class _CartBottomState extends State<CartBottom> {
  @override
  Widget build(BuildContext context) {
    if (widget.result['status'] == 'success') {
      String totalPrice = widget.result['result']['total_price'].toString();
      String displaySale = widget.result['result']['display_sale'];
      String finalPrice = widget.result['result']['final_price'].toString();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.error != '') ...[
            Container(
                height: 100.0,
                color: Colors.red,
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      padding: const EdgeInsets.all(15.0),
                      children: [
                        Text('XƏTA:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.yellow)),
                        MsHtml(
                          data: widget.error,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ],
                    )))
          ],
          Ink(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.lightBlue.withOpacity(0.1),
                spreadRadius: 20,
                blurRadius: 50,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((displaySale.isNotEmpty) ? 'Toplam: ${fullPrice(totalPrice)}, $displaySale' : 'Toplam',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.greyColor,
                          )),
                      SizedBox(height: 3.0),
                      Text(fullPrice(finalPrice), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0))
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                MsButton(
                  width: 150.0,
                  onTap: () {
                    if (widget.error != '') {
                      customAlert(context, Icons.shopping_cart, 'Səbətinizdə düzəldilməsi gərəkli problemlər var', 'Səbətə qayıt', () {
                        Get.back();
                      });
                    } else {
                      Get.to(() => CheckoutPage());
                    }
                  },
                  title: 'Sifarişi tamamla',
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
