import 'package:flutter/material.dart';

class MsRating extends StatelessWidget {
  const MsRating(
      {super.key, required this.value, this.total = 5, this.size = 16.0});

  final double value;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < total; i++)
          Icon(
            i < value.floor()
                ? Icons.star
                : i == value.floor() && value - value.floor() >= 0
                    ? Icons.star_half
                    : Icons.star_border,
            color: Colors.amber,
            size: size,
          ),
      ],
    );
  }
}
