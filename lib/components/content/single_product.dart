import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/controllers/wishlist_controller.dart';
import 'package:mymoda/pages/shop/single_product.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';

class SinglePostItem extends StatefulWidget {
  final Map data;

  const SinglePostItem({super.key, required this.data});

  @override
  State<SinglePostItem> createState() => _SinglePostItemState();
}

class _SinglePostItemState extends State<SinglePostItem> {
  bool loading = false;
  final loginController = Get.put(LoginController());
  final wishlistController = Get.put(WishlistController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List price = [];

    if (widget.data['product_type'] == 'simple') {
      price = displayPrice(widget.data['price'], widget.data['sale_price'], widget.data['final_price']);
    } else {
      price = ['${widget.data['price_range']} ${Shop.currency}', ''];
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, SlideLeftRoute(page: SingleProductPage(data: widget.data)));
      },
      child: Container(
        color: Theme.of(context).colorScheme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(5.0), child: MsImage(url: widget.data['thumbnail_url'], height: 220.0)),
                Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        addWishlist(widget.data['post_id']).then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.backgroundColor, borderRadius: BorderRadius.circular(50.0)),
                            child: Obx(() => (loading)
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Theme.of(context).colorScheme.secondColor,
                                    ),
                                  )
                                : (wishlistController.wishlist.contains(int.parse(widget.data['post_id'])))
                                    ? Icon(
                                        Icons.favorite,
                                        color: Theme.of(context).colorScheme.secondColor,
                                        size: 20.0,
                                      )
                                    : Icon(
                                        Icons.favorite_outline,
                                        size: 20.0,
                                      ))),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data['post_title'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5.0),
                  if (price[0] != '') ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(price[0], style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.w600)),
                        if (price[1] != '') ...[SizedBox(width: 5.0), Text(price[1], style: TextStyle(color: Theme.of(context).colorScheme.secondColor, decoration: TextDecoration.lineThrough, fontSize: 15.0))]
                      ],
                    )
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SinglePostFormat extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  const SinglePostFormat({super.key, required this.icon, this.size = 23.0, this.iconSize = 13.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 2.0),
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(50.0)),
        child: Icon(
          icon,
          color: Colors.black,
          size: iconSize,
        ));
  }
}

class SingleWishlistPostItem extends StatefulWidget {
  final Map data;
  const SingleWishlistPostItem({super.key, required this.data});

  @override
  State<SingleWishlistPostItem> createState() => _SingleWishlistPostItemState();
}

class _SingleWishlistPostItemState extends State<SingleWishlistPostItem> {
  var wishlistController = Get.put(WishlistController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(widget.data['post_id']),
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.only(right: 15.0),
          color: Colors.red,
          child: const Align(alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
        ),
        onDismissed: (DismissDirection direction) {
          wishlistController.wishlist.remove(widget.data['post_id']);
          box.write('wishlist', wishlistController.wishlist);
        },
        child: SinglePostItem(data: widget.data));
  }
}
