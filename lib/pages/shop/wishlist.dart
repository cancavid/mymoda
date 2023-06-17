import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/content/load_products.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/controllers/wishlist_controller.dart';
import 'package:mymoda/themes/options.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool loading = true;
  List products = [];
  String error = '';
  String id = '';
  final wishlistController = Get.put(WishlistController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    id = loginController.token.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, index) {
        return [SliverAppBar(title: Text('İstək listi'), toolbarHeight: 60.0)];
      },
      body: RoundedBody(child: Obx(() => LoadProducts(multiple: wishlistController.wishlist.toList(), wishlist: true, filterBar: false, goToFilterPage: () {}))),
    ));
  }
}
