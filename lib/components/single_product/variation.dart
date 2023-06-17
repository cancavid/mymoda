import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/options.dart';

class VariationProduct extends StatefulWidget {
  const VariationProduct({super.key, required this.id, required this.action});

  final String id;
  final Function(String) action;

  @override
  State<VariationProduct> createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> with TickerProviderStateMixin {
  Map data = {};
  Map attributes = {};
  Map attrDetails = {};
  List variations = [];
  Map selecteds = {};
  String price = '';
  String salePrice = '';
  String finalPrice = '';
  String stock = '';
  Map stockControl = {};
  String variation = '';

  get() async {
    var urlText = 'https://fashion.betasayt.com/api/variations.php?action=get&id=${widget.id}';
    var url = Uri.parse(urlText);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        if (result['status'] == 'success') {
          data = result;
          attributes = data['attr'];
          attrDetails = data['attr_details'];
          variations = data['result'];
          attrDetails.forEach((key, value) {
            selecteds[key] = '';
            stockControl[key] = [];
          });
          // If attribute is single, detect automatically out of stock attributes
          if (attributes.length == 1) {
            stockControl[attributes[0]] = [];
            for (var i = 0; i < variations.length; i++) {
              if (variations[i]['variation_stock'] == '0') {
                var singleAttr = attributes.keys.elementAt(0);
                stockControl[singleAttr].add(variations[i]['variation_$singleAttr']);
              }
            }
          }
          attributes.forEach((key, value) {
            if (attributes[key].length == 1) {
              selecteds[key] = value.keys.elementAt(0);
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MsSpace(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(attributes.entries.map((entry) {
          var attr = entry.key;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${attrDetails[attr]['name']}:'),
              SizedBox(height: 10.0),
              SizedBox(
                height: 50.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.from(attributes[attr].entries.map((subEntry) {
                    return GestureDetector(
                        onTap: () {
                          if (!stockControl[attr].contains(subEntry.key)) {
                            setState(() {
                              selecteds[attr] = subEntry.key;
                              for (var i in variations) {
                                var x = 0;
                                selecteds.forEach((key, value) {
                                  if (i['variation_$key'] == selecteds[key]) {
                                    x++;
                                  }
                                });
                                if (x == selecteds.length) {
                                  price = i['variation_price'];
                                  salePrice = i['variation_sale_price'];
                                  finalPrice = i['variation_final_price'];
                                  stock = i['variation_stock'] ?? '';
                                  widget.action(i['variation_id']);
                                  break;
                                }
                              }
                              for (var a in selecteds.keys) {
                                if (a != attr) {
                                  stockControl[a] = [];
                                  for (var i in variations) {
                                    if (i['variation_$attr'] == subEntry.key && i['variation_stock'] == '0') {
                                      stockControl[a].add(i['variation_$a']);
                                    }
                                  }
                                }
                              }
                            });
                          }
                        },
                        child: Material(
                            color: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: (attrDetails[attr]['type'] == 'color')
                                  ? Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(border: Border.all(color: (selecteds[attr].contains(subEntry.key)) ? Colors.black : Colors.grey.shade300), borderRadius: BorderRadius.circular(50.0)),
                                          child: Tooltip(
                                            message: subEntry.value['name'],
                                            child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              decoration: BoxDecoration(color: hexToColor(subEntry.value['color']), borderRadius: BorderRadius.circular(50.0)),
                                            ),
                                          ),
                                        ),
                                        if (stockControl[attr].contains(subEntry.key)) ...[
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: CrossPainter(),
                                            ),
                                          ),
                                        ]
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              constraints: BoxConstraints(
                                                minWidth: 42.0,
                                              ),
                                              height: 42.0,
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0), border: Border.all(color: (selecteds[attr].contains(subEntry.key)) ? Colors.black : Colors.grey.shade300)),
                                              child: Text(subEntry.value['name'].toString()),
                                            ),
                                          ],
                                        ),
                                        if (stockControl[attr].contains(subEntry.key)) ...[
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: CrossPainter(),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                            )));
                  })),
                ),
              ),
            ],
          );
        })),
      ),
      if (price.isNotEmpty) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widgetPrice(price, salePrice, finalPrice),
            if (stock != '' && stock != '0') ...[Text('$stock ədəd qalıb.')] else if (stock == '0') ...[Text('Məhsul bitib')]
          ],
        )
      ]
    ]);
  }
}

class CrossPainter extends CustomPainter {
  CrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
