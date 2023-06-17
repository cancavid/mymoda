import 'package:flutter/material.dart';

class MsMediumHeading extends StatelessWidget {
  const MsMediumHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600));
  }
}

class MsLargeHeading extends StatelessWidget {
  const MsLargeHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600));
  }
}
