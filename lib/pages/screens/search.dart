import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymoda/components/content/load_products.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/options.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final box = GetStorage();
  List data = [];
  List history = [];
  dynamic results;
  var searchType = TextEditingController();

  @override
  void initState() {
    super.initState();

    update();
    result();
  }

  update({String keyword = '', String action = ''}) {
    setState(() {
      if (action == 'add') {
        data.add(keyword);
      } else if (action == 'remove' && data.contains(keyword)) {
        data.remove(keyword);
      } else {
        box.writeIfNull('history', []);
        data = box.read('history');
      }
      history = data.reversed.toList();
    });
    box.write('history', data);
  }

  result() {
    if (searchType.text == '') {
      setState(() {
        results = ListView.builder(
            itemCount: history.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    searchType.text = history[index];
                  });
                  result();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history, color: MsColors.medium),
                              SizedBox(width: 10.0),
                              Text(
                                history[index],
                                style: TextStyle(fontSize: 15.0),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              update(keyword: history[index], action: 'remove');
                            },
                            child: Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(.2)),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16.0,
                                )),
                          )
                        ],
                      )),
                ),
              );
            }));
      });
    } else {
      results = LoadProducts(search: searchType.text);
    }
  }

  @override
  void dispose() {
    searchType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchType,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              fillColor: MsColors.primary,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              ),
              hintText: 'Axtarış sözünüzü yazın...',
            ),
            onSubmitted: (value) {
              setState(() {
                result();
                update(keyword: value, action: 'add');
              });
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  searchType.clear();
                  result();
                },
                icon: Icon(Icons.close))
          ],
        ),
        body: RoundedBody(
          child: Column(
            children: [
              Expanded(child: results),
            ],
          ),
        ));
  }
}
