import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/pages/screens/children_categories.dart';
import 'package:mymoda/pages/screens/taxonomy.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List terms = [];
  bool loading = true;
  final loginController = Get.put(LoginController());

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/terms.php?action=get&taxonomy=mehsul-kateqoriyasi&token=${loginController.token.value}');
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
    return Scaffold(
      appBar: AppBar(title: Text('Kateqoriyalar')),
      body: RoundedBody(
        child: (loading)
            ? const MsIndicator()
            : (terms.isEmpty)
                ? const MsNotify(icon: Icons.close, heading: 'Heç bir kateqoriya tapılmadı')
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    itemCount: terms.length,
                    separatorBuilder: (content, index) {
                      return Container(
                        height: 1.0,
                        color: Theme.of(context).colorScheme.lightColor,
                      );
                    },
                    itemBuilder: (content, index) {
                      return GestureDetector(
                        onTap: () {
                          (terms[index]['children'] != null) ? Navigator.push(context, SlideLeftRoute(page: ChildrenCategories(name: terms[index]['term_name'], terms: terms[index]['children']))) : Navigator.push(context, SlideLeftRoute(page: TaxonomyPage(category: terms[index]['term_id'], name: terms[index]['term_name'])));
                        },
                        child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                            leading: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 221, 239, 253), borderRadius: BorderRadius.circular(50.0)),
                              child: MsImage(
                                url: terms[index]['term_thumbnail'],
                                width: 20.0,
                                height: 20.0,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(terms[index]['term_name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14.0,
                            )),
                      );
                    },
                  ),
      ),
    );
  }
}
