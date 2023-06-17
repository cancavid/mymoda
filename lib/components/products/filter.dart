import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key, required this.data}) : super(key: key);

  final List data;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool loading = true;
  Map data = {};
  Map variables = {};
  Map selecteds = {};
  Map selectedsNames = {};
  List localSelects = [];
  List price = [0, Shop.maxPrice];
  SfRangeValues priceRange = SfRangeValues(0.0, Shop.maxPrice);

  Future<void> get() async {
    final url = Uri.parse('https://fashion.betasayt.com/api/filter.php?action=get&disable=mehsul-kateqoriyasi');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          data = result['result'];
          for (var item in data.keys) {
            selecteds[item] = widget.data[0][item] ?? [];
            selectedsNames[item] = widget.data[1][item] ?? [];
            variables[item] = data[item]['terms'];
          }
          price = widget.data[2];
          priceRange = SfRangeValues(price[0], price[1]);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selecteds.forEach((key, value) {
                    selecteds[key] = [];
                  });
                  selectedsNames.forEach((key, value) {
                    selectedsNames[key] = [];
                  });
                  localSelects = [];
                });
              },
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Təmizlə',
                        style: TextStyle(color: Colors.white),
                      ))),
            )
          ],
        ),
        body: RoundedBody(
          child: (loading)
              ? MsIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: [
                          ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.keys.length,
                                itemBuilder: (context, index) {
                                  final attr = variables.keys.elementAt(index);
                                  return Container(
                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: MsColors.light))),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          localSelects = localSelects + selecteds[attr];
                                          localSelects = localSelects.toSet().toList();
                                        });
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(builder: (BuildContext context, StateSetter stateSetter) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: variables[attr].length,
                                                      itemBuilder: (c, i) {
                                                        final item = variables[attr].keys.elementAt(i);

                                                        return CheckboxListTile(
                                                          value: localSelects.contains(item),
                                                          onChanged: (value) {
                                                            stateSetter(() {
                                                              if (value == false) {
                                                                localSelects.remove(item);
                                                              } else {
                                                                if (!localSelects.contains(item)) {
                                                                  localSelects.add(item);
                                                                }
                                                              }
                                                            });
                                                          },
                                                          title: (data[attr]['type'] == 'color')
                                                              ? Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      width: 20.0,
                                                                      height: 20.0,
                                                                      decoration: BoxDecoration(color: hexToColor(variables[attr][item]['color']), borderRadius: BorderRadius.circular(20.0)),
                                                                    ),
                                                                    SizedBox(width: 15.0),
                                                                    Text(variables[attr][item]['term_name'])
                                                                  ],
                                                                )
                                                              : Text(variables[attr][item]['term_name']),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(15.0),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              localSelects = [];
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          child: Material(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text('İmtina et', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 16.0)),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.0),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedsNames[attr] = [];
                                                              selecteds[attr] = localSelects;
                                                              for (var item in selecteds[attr]) {
                                                                selectedsNames[attr].add(data[attr]['terms'][item]['term_name']);
                                                              }
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          child: Material(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text('Təsdiqlə', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 16.0)),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                          },
                                        ).whenComplete(() {
                                          setState(() {
                                            localSelects = [];
                                          });
                                        });
                                      },
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                                      title: Text(
                                        data[data.keys.elementAt(index)]['name'].toString(),
                                        style: const TextStyle(fontSize: 17.0),
                                      ),
                                      subtitle: (selectedsNames[attr].length != 0)
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 7.0),
                                                Text(selectedsNames[attr].join(', '), style: TextStyle(color: Colors.grey)),
                                              ],
                                            )
                                          : null,
                                      trailing: Icon(Icons.keyboard_arrow_down),
                                    ),
                                  );
                                }),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
                                child: Text('Qiymət aralığı', style: TextStyle(fontSize: 17.0)),
                              ),
                              SfRangeSlider(
                                min: 0.0,
                                max: Shop.maxPrice,
                                values: priceRange,
                                interval: 100,
                                showTicks: false,
                                showLabels: true,
                                enableTooltip: true,
                                minorTicksPerInterval: 1,
                                onChanged: (SfRangeValues values) {
                                  setState(() {
                                    priceRange = values;
                                    price = [priceRange.start, priceRange.end];
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Ink(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      color: Theme.of(context).colorScheme.lightColor,
                      child: MsButton(
                        onTap: () {
                          Navigator.pop(context, [selecteds, selectedsNames, price]);
                        },
                        title: 'Filterlə',
                        icon: true,
                        style: MsButtonStyle.secondary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
