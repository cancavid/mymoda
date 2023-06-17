import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/components/content/single_product.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/headings.dart';

class RelatedProducts extends StatefulWidget {
  const RelatedProducts({super.key});

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  bool loading = true;
  List relatedProducts = [];

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/posts.php?action=get&post_type=mehsul&limit=8');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            relatedProducts = result['result'];
          }
        });
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
    return (loading)
        ? MsIndicator()
        : (relatedProducts.isNotEmpty)
            ? Container(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MsMediumHeading(title: 'Oxşar məhsullar'),
                    MsSpace(),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300.0,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              itemBuilder: (content, index) {
                                return Container(padding: const EdgeInsets.only(right: 15.0), width: MediaQuery.of(context).size.width / 2, child: SinglePostItem(data: relatedProducts[index]));
                              }),
                        ))
                  ],
                ),
              )
            : SizedBox();
  }
}
