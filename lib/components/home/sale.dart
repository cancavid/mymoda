import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/components/content/single_product.dart';
import 'package:mymoda/themes/options.dart';

class HomeSaleProducts extends StatefulWidget {
  const HomeSaleProducts({super.key});

  @override
  State<HomeSaleProducts> createState() => _HomeSaleProductsState();
}

class _HomeSaleProductsState extends State<HomeSaleProducts> {
  List products = [];

  get() async {
    String urlText;

    urlText =
        'https://fashion.betasayt.com/api/posts.php?action=get&post_type=mehsul&limit=12';
    var url = Uri.parse(urlText);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        if (result['result'] != null) {
          setState(() {
            products = result['result'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MsHeading(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 1.2,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                  padding: const EdgeInsets.only(right: 15.0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: ((context, index) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width / 2.25,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: SinglePostItem(data: products[index]),
                        ));
                  })),
            ),
          )
        ],
      ),
    );
  }
}
