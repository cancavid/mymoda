import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/content/load_products.dart';
import 'package:mymoda/components/products/filter.dart';
import 'package:mymoda/themes/options.dart';

class TaxonomyPage extends StatefulWidget {
  final String category;

  final String name;
  const TaxonomyPage({super.key, this.category = '', required this.name});

  @override
  State<TaxonomyPage> createState() => _TaxonomyPageState();
}

class _TaxonomyPageState extends State<TaxonomyPage> {
  Map filter = {};
  Map filterNames = {};
  List price = [0, Shop.maxPrice];

  @override
  void initState() {
    filter = {
      'mehsul-kateqoriyasi': {(widget.category)}
    };
    super.initState();
  }

  void goToTaxonomyPage(BuildContext context) async {
    final result = await Get.to(() => FilterPage(data: [filter, filterNames, price]));

    // Handle the returned parameter here
    if (result != null) {
      setState(() {
        filter = result[0];
        filterNames = result[1];
        price = result[2];
      });
    }
  }

  double height = 66.0;
  String scroll = 'up';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [SliverAppBar(title: Text(widget.name))];
          },
          body: RoundedBody(
            child: LoadProducts(filter: filter, goToFilterPage: () => goToTaxonomyPage(context)),
          )),
    ));
  }
}
