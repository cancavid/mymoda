import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/pages/screens/taxonomy.dart';
import 'package:mymoda/themes/theme.dart';

class ChildrenCategories extends StatefulWidget {
  const ChildrenCategories(
      {super.key, required this.name, required this.terms});

  final String name;
  final List terms;

  @override
  State<ChildrenCategories> createState() => _ChildrenCategoriesState();
}

class _ChildrenCategoriesState extends State<ChildrenCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(widget.name)),
          SliverToBoxAdapter(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.terms.length,
              separatorBuilder: (content, index) {
                return Container(
                  height: 1.0,
                  color: Theme.of(context).colorScheme.lightColor,
                );
              },
              itemBuilder: (content, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => TaxonomyPage(
                        category: widget.terms[index]['term_id'],
                        name: widget.terms[index]['term_name']));
                  },
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(widget.terms[index]['term_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14.0,
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
