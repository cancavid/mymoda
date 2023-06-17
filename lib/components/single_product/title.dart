import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data['post_title'],
      style: TextStyle(fontSize: 16.0),
    );
  }
}