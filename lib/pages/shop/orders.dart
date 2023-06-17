import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymoda/pages/shop/order_details.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool loading = true;
  int limit = 10;
  int offset = 0;
  List orders = [];
  bool noOrders = false;

  final _controller = ScrollController(initialScrollOffset: 1);

  get(scroll) async {
    var url = Uri.parse(
        'https://fashion.betasayt.com/api/orders.php?limit=$limit&offset=$offset&session_key=1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            if (scroll) {
              orders = orders + result['result'];
            } else {
              orders = result['result'];
            }
          } else {
            noOrders = true;
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    get(false);

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          if (mounted) {
            setState(() {
              offset = offset + 10;
              get(true);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sifarişləriniz')),
      body: RoundedBody(
        backgroundColor: Color(0xFFEEEEEE),
        child: (loading)
            ? MsIndicator()
            : (orders.isEmpty)
                ? MsNotify(
                    icon: Icons.shopping_cart,
                    heading: 'Heç bir sifariş tapılmadı.')
                : RefreshIndicator(
                    onRefresh: () {
                      setState(() {
                        offset = 0;
                      });
                      return get(false);
                    },
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(15.0),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15.0);
                        },
                        itemCount: orders.length + 1,
                        itemBuilder: (content, index) {
                          return (index == orders.length)
                              ? (noOrders)
                                  ? Center(
                                      child: Text(
                                          'Göstəriləcək başqa sifariş yoxdur.'))
                                  : (orders.length >= limit)
                                      ? MsIndicator()
                                      : SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        OrderDetailsPage(data: orders[index]));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 15.0, 15.0, 0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Column(
                                      children: [
                                        OrderItem(
                                          heading: 'Sifariş №',
                                          data: orders[index]['order_number'],
                                        ),
                                        Divider(height: 20.0),
                                        OrderItem(
                                          heading: 'Tarix',
                                          data: DateFormat("dd.MM.yyyy HH:mm")
                                              .format(DateTime.parse(
                                                  orders[index]['order_date'])),
                                        ),
                                        Divider(height: 20.0),
                                        OrderItem(
                                          heading: 'Status',
                                          data: getOrderStatus(
                                              orders[index]['order_status']),
                                        ),
                                        Divider(height: 20.0),
                                        OrderItem(
                                          heading: 'Toplam məbləğ',
                                          data:
                                              '${orders[index]['order_total_price']} ${orders[index]['order_currency']}',
                                        ),
                                        Divider(height: 20.0),
                                        OrderItemBottom()
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  ),
      ),
    );
  }
}

class OrderItemBottom extends StatelessWidget {
  const OrderItemBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        alignment: Alignment.center,
        height: 35.0,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        child: Text(
          'Ətraflı',
          style: TextStyle(color: Colors.white),
        ),
      )
    ]);
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key, required this.heading, required this.data})
      : super(key: key);

  final String heading;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(child: Text('$heading:')),
      Expanded(
        child: Text(data, textAlign: TextAlign.right),
      )
    ]);
  }
}
