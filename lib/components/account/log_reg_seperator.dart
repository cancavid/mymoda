import 'package:flutter/material.dart';
import 'package:mymoda/themes/options.dart';

class LogRegSeparator extends StatelessWidget {
  const LogRegSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MsSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1.0,
                color: Color(0xFFEEEEEE),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('və ya', style: TextStyle(color: Color(0xFF999999))),
            ),
            Expanded(
              child: Container(
                height: 1.0,
                color: Color(0xFFEEEEEE),
              ),
            )
          ],
        ),
        MsSpace()
      ],
    );
  }
}