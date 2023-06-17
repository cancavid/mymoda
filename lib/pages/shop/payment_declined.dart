import 'package:flutter/material.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class PaymentDeclinedPage extends StatelessWidget {
  const PaymentDeclinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RoundedBody(child: MsNotify(heading: 'Ödəniş baş tutmadı')),
    );
  }
}
