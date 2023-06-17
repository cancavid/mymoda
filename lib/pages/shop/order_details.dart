import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymoda/pages/shop/orders.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.data});

  final Map data;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool loading = true;
  List order = [];
  String id = '';

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/orders.php?id=$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        loading = false;
        if (result['status'] == 'success') {
          order = result['result'];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    id = widget.data['order_id'];
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.lightColor,
        appBar: AppBar(title: Text('Sifariş detalları')),
        body: (loading)
            ? MsIndicator()
            : (order.isEmpty)
                ? MsNotify(
                    icon: Icons.shopping_cart,
                    heading: 'Heç bir sifariş tapılmadı.')
                : ListView(
                    padding: const EdgeInsets.all(15.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 30.0),
                        child: Text(
                          'Sifariş: ${widget.data['order_number']}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20.0),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                              top: 6.5,
                              left: 0.0,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 7.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFDDDDDD),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.5,
                                    left: 0.0,
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                              2,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              OrderDetailStep(
                                heading: 'Gözləyir',
                                align: CrossAxisAlignment.start,
                              ),
                              OrderDetailStep(
                                heading: 'Təsdiqləndi',
                                align: CrossAxisAlignment.center,
                              ),
                              OrderDetailStep(
                                heading: 'Tamamlandı',
                                align: CrossAxisAlignment.end,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            OrderItem(
                              heading: 'Tarix',
                              data: DateFormat("dd.MM.yyyy HH:mm").format(
                                  DateTime.parse(widget.data['order_date'])),
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Status',
                              data: getOrderStatus(widget.data['order_status']),
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Toplam məbləğ',
                              data:
                                  '${widget.data['order_total_price']} ${widget.data['order_currency']}',
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Ad və soyadınız',
                              data:
                                  '${widget.data['order_first_name']} ${widget.data['order_last_name']}',
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Telefon',
                              data: widget.data['order_phone'],
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Email',
                              data: widget.data['order_email'],
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Çatdırılma',
                              data: widget.data['order_address'],
                            ),
                            Divider(height: 20.0),
                            OrderItem(
                              heading: 'Ödəniş üsulu',
                              data:
                                  getPaymentMethod(widget.data['order_method']),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
  }
}

class OrderDetailStep extends StatelessWidget {
  const OrderDetailStep({Key? key, required this.heading, required this.align})
      : super(key: key);

  final String heading;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Stack(
          children: [
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            Positioned(
                top: 5.0,
                left: 5.0,
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                )),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(heading)
      ],
    );
  }
}
