import 'package:flutter/material.dart';
import 'package:mymoda/themes/widgets/rating.dart';

class SingleProductRating extends StatelessWidget {
  const SingleProductRating(
      {super.key, required this.total, required this.count, required this.sum});

  final double total;
  final int count;
  final int sum;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(total.toString(), style: TextStyle(fontSize: 12.0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: MsRating(value: total),
        ),
        Text('($count səs)', style: TextStyle(fontSize: 12.0))
      ],
    );
  }
}
