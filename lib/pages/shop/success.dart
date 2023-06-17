import 'package:flutter/material.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MsNotify(
          icon: Icons.check,
          heading: 'Sifarişiniz uğurla qeydə alındı.',
          color: Colors.green),
    );
  }
}
