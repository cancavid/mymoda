import 'package:flutter/material.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/headings.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [MsMediumHeading(title: 'Məhsul haqqında'), MsSpace(), MsHtml(data: data['post_content'])],
      ),
    ));
  }
}
