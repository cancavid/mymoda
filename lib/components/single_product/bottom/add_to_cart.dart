import 'package:flutter/material.dart';
import 'package:mymoda/themes/widgets/buttons.dart';

class AddToCartWidget extends StatefulWidget {
  final Function() onTap;
  final bool loading;

  const AddToCartWidget({super.key, required this.onTap, required this.loading});

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  @override
  Widget build(BuildContext context) {
    return MsButton(width: 150.0, onTap: widget.onTap, title: 'Səbətə at', loading: widget.loading);
  }
}
