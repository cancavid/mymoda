import 'package:flutter/material.dart';
import 'package:mymoda/themes/theme.dart';

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final Function() onDecrease;
  final Function() onIncrease;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrease,
          child: Container(
            padding: const EdgeInsets.all(7.0),
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.lightColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Icon(
              Icons.remove,
              size: 15.0,
            ),
          ),
        ),
        SizedBox(
          width: 30.0,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: onIncrease,
          child: Container(
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.lightColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Icon(
              Icons.add,
              size: 15.0,
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
      ],
    );
  }
}
