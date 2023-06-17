import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel({
    Key? key, required this.label
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0, color: Colors.grey)));
  }
}