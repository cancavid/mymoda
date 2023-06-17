import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/single_product/bottom.dart';
import 'package:mymoda/components/single_product/price.dart';
import 'package:mymoda/components/single_product/rating.dart';
import 'package:mymoda/components/single_product/related.dart';
import 'package:mymoda/components/single_product/slider.dart';
import 'package:mymoda/components/single_product/tabs/tabs.dart';
import 'package:mymoda/components/single_product/title.dart';
import 'package:mymoda/components/single_product/variation.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/wishlist_controller.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:share_plus/share_plus.dart';

enum MsProductType { simple, variable }

class SingleProductPage extends StatefulWidget {
  const SingleProductPage({super.key, required this.data});

  final Map data;
  @override
  State<SingleProductPage> createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  List comments = [];
  int commentsCount = 0;
  int commentsSum = 0;
  double commentsTotal = 0;
  int quantity = 1;
  bool commentsLoading = true;
  final wishlistController = Get.put(WishlistController());
  String variationId = '0';

  getComments() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/comments.php?action=preview&post_id=${widget.data['post_id']}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        commentsLoading = false;
        if (result['status'] == 'success') {
          comments = result['result']['comments'];
          commentsCount = int.parse(result['result']['calc']['count']);
          commentsSum = int.parse(result['result']['calc']['sum']);
          commentsTotal = double.parse(result['result']['calc']['total']);
        }
      });
    }
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  void setVariation(String id) {
    setState(() {
      variationId = id;
    });
  }

  BoxDecoration getDecoration() {
    return BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.15));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.backgroundColor,
      bottomNavigationBar: SingleProductBottom(data: widget.data, variationId: variationId),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              flexibleSpace: FlexibleSpaceBar(
                background: ProductGallerySlider(data: widget.data),
                collapseMode: CollapseMode.none,
              ),
              expandedHeight: 500.0,
              collapsedHeight: 66.0,
              toolbarHeight: 66.0,
              leading: Container(
                margin: const EdgeInsets.only(left: 10.0),
                decoration: getDecoration(),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
              ),
              actions: [
                Container(
                  decoration: getDecoration(),
                  child: IconButton(
                      onPressed: () {
                        Share.share(widget.data['post_id']);
                      },
                      icon: Icon(Icons.share)),
                ),
                SizedBox(width: 10.0),
                Obx(() => Container(
                      decoration: getDecoration(),
                      child: IconButton(
                          onPressed: () {
                            addWishlist(widget.data['post_id']);
                          },
                          icon: Icon((wishlistController.wishlist.contains(int.parse(widget.data['post_id']))) ? Icons.favorite : Icons.favorite_border)),
                    )),
                SizedBox(width: 10.0),
              ],
            )
          ];
        },
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SingleProductRating(total: commentsTotal, sum: commentsSum, count: commentsCount),
                  SizedBox(height: 10.0),
                  ProductTitle(data: widget.data),
                  SizedBox(height: 15.0),
                  ProductPrice(data: widget.data),
                  VariationProduct(id: widget.data['post_id'], action: setVariation),
                  SizedBox(height: 15.0),
                ])),
            Divider(color: Color(0xFFEEEEEE), height: 5.0, thickness: 5.0),
            SingleProductTabs(data: widget.data, comments: comments, commentsCount: commentsCount, commentsLoading: commentsLoading),
            Divider(color: Color(0xFFEEEEEE), height: 5.0, thickness: 5.0),
            RelatedProducts()
          ],
        ),
      ),
    ));
  }
}
