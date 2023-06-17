import 'package:flutter/material.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/theme.dart';

class ProductPrice extends StatefulWidget {
  const ProductPrice({super.key, required this.data});

  final Map data;

  @override
  State<ProductPrice> createState() => _ProductPriceState();
}

class _ProductPriceState extends State<ProductPrice> {
  dynamic price;

  @override
  void initState() {
    super.initState();
    price = displayPrice(widget.data['price'], widget.data['sale_price'],
        widget.data['final_price']);
  }

  @override
  Widget build(BuildContext context) {
    if (price != null && price[0] != '') {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(price[0],
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700)),
        if (price[1] != '') ...[
          SizedBox(width: 10.0),
          Text(price[1],
              style: TextStyle(
                  color: Theme.of(context).colorScheme.greyColor,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14.0))
        ]
      ]);
    }
    return SizedBox();
  }
}
