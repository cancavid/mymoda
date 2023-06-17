import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/components/products/filter_button.dart';
import 'package:mymoda/components/products/sort_filter.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/notify.dart';

import 'single_product.dart';

void defaultGoToFilterPage() {
  // Default implementation for goToFilterPage
}

class LoadProducts extends StatefulWidget {
  final String search;
  final List multiple;
  final bool wishlist;
  final bool filterBar;
  final Map filter;
  final List price;
  final VoidCallback goToFilterPage;

  const LoadProducts({super.key, this.search = 'DisableSearch', this.multiple = const [], this.wishlist = false, this.price = const [], this.filterBar = true, this.filter = const {}, this.goToFilterPage = defaultGoToFilterPage});

  @override
  State<LoadProducts> createState() => _LoadProductsState();
}

class _LoadProductsState extends State<LoadProducts> {
  List products = [];
  int limit = 10;
  int offset = 0;
  bool loading = true;
  bool noProducts = false;
  bool refresh = false;
  List orderby = ['post_date', 'price', 'price'];
  List order = ['desc', 'desc', 'asc'];
  int selectedSort = 0;

  get() async {
    String urlText;

    urlText = 'https://fashion.betasayt.com/api/posts.php?action=get&post_type=mehsul&image_size=product&limit=$limit&offset=$offset&orderby=${orderby[selectedSort]}&order=${order[selectedSort]}';
    if (widget.search != 'DisableSearch') {
      urlText = '$urlText&search=${widget.search}';
    }
    if (widget.multiple.isNotEmpty) {
      String multipleIds = widget.multiple.join(',');
      urlText = '$urlText&multiple=$multipleIds';
    } else if (widget.multiple.isEmpty && widget.wishlist) {
      urlText = '$urlText&multiple=0';
    }
    if (widget.filter.isNotEmpty) {
      widget.filter.forEach((key, value) {
        String values = value.join(',');
        urlText = '$urlText&$key=$values';
      });
    }
    if (widget.price.isNotEmpty) {
      urlText = '$urlText&min=${widget.price[0]}&max=${widget.price[1]}';
    }
    var url = Uri.parse(urlText);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        if (result['result'] != null) {
          setState(() {
            loading = false;
            List newProducts = result['result'];
            if (refresh) {
              products = newProducts;
            } else {
              products = products + newProducts;
            }
            noProducts = false;
            refresh = false;
          });
        } else {
          setState(() {
            loading = false;
            noProducts = true;
            refresh = false;
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
  void didUpdateWidget(LoadProducts oldWidget) {
    setState(() {
      products = [];
      loading = true;
      offset = 0;
    });
    get();
    super.didUpdateWidget(oldWidget);
  }

  sort(int index) {
    setState(() {
      selectedSort = index;
      products = [];
      loading = true;
      offset = 0;
    });
    get();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return (loading && !refresh)
        ? const MsIndicator()
        : NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge) {
                bool isTop = metrics.pixels == 0;
                if (!isTop) {
                  setState(() {
                    offset = offset + limit;
                    get();
                  });
                }
              }
              return true;
            },
            child: RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    offset = 0;
                    refresh = true;
                  });
                  return get();
                },
                strokeWidth: 2.6,
                backgroundColor: Colors.white,
                child: (products.isEmpty)
                    ? MsNotify(heading: 'İstək listiniz boşdur')
                    : Column(
                        children: [
                          if (widget.filterBar) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [SortFilter(onChanged: sort, selected: selectedSort), FilterButton(onTap: widget.goToFilterPage)],
                            )
                          ],
                          Expanded(
                            child: ListView(
                              children: [
                                GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(15.0),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 3 / 5.4, crossAxisSpacing: 15, mainAxisSpacing: 15),
                                    itemCount: products.length,
                                    itemBuilder: (context, i) {
                                      return (i == products.length)
                                          ? (noProducts)
                                              ? Padding(
                                                  padding: const EdgeInsets.all(30.0),
                                                  child: Text(
                                                    'Göstəriləcək başqa məhsul yoxdur.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : (products.length >= 10)
                                                  ? const Center(
                                                      child: SizedBox(
                                                        height: 120.0,
                                                        child: MsIndicator(),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                          : SinglePostItem(data: products[i]);
                                    }),
                                if (!noProducts && products.length > limit - 1) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30.0),
                                    child: MsIndicator(),
                                  )
                                ]
                              ],
                            ),
                          ),
                        ],
                      )),
          );
  }
}
