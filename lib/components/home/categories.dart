import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/pages/screens/taxonomy.dart';
import 'package:mymoda/themes/options.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({super.key});

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  List terms = [];
  bool loading = true;

  get() async {
    var url = Uri.parse(
        'https://fashion.betasayt.com/api/terms.php?action=get&taxonomy=mehsul-kateqoriyasi&limit=9');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            terms = result['result'];
          } else {
            terms = [];
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState;
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          MsHeading(),
          MsSpace(),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0),
              itemCount: terms.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page:
                                TaxonomyPage(name: terms[index]['term_name'])));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: Color(0xFFEEEEEE)),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xFFf2f3f7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MsImage(
                            url: terms[index]['term_thumbnail'], height: 40.0),
                        SizedBox(height: 10.0),
                        Text(terms[index]['term_name'],
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.0),
                            textAlign: TextAlign.center,
                            maxLines: 2)
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
