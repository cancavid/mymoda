import 'package:flutter/material.dart';
import 'package:mymoda/themes/options.dart';

class MsNotify extends StatelessWidget {
  final IconData icon;
  final String heading;
  final Color color;

  const MsNotify(
      {super.key,
      this.icon = Icons.close,
      required this.heading,
      this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 75.0),
        children: [
          UnconstrainedBox(
              child: Container(
                  width: 150.0,
                  height: 150.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(150.0),
                      border:
                          Border.all(color: Color(0xFFF9F9F9), width: 15.0)),
                  child: Icon(icon, color: Colors.white, size: 60.0))),
          const SizedBox(height: 25.0),
          Text(heading,
              style: const TextStyle(fontSize: 22.0),
              textAlign: TextAlign.center)
        ],
      ),
    ));
  }
}
