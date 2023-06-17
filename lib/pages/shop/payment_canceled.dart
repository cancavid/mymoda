import 'package:flutter/material.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class PaymentCanceledPage extends StatelessWidget {
  const PaymentCanceledPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RoundedBody(child: MsNotify(heading: 'Ödənişdən imtina edildi')),
    );
  }
}
