import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/pages/screens/search.dart';
import 'package:get/get.dart';
import 'package:mymoda/themes/theme.dart';

class AppBarSearch extends StatelessWidget {
  const AppBarSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        centerTitle: true,
        collapsedHeight: 65.0,
        expandedHeight: 80.0,
        toolbarHeight: 65.0,
        pinned: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w400),
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: MsColors.primary,
          child: GestureDetector(
            onTap: () {
              Get.to(SearchPage());
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 49, 158, 246),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                      width: 40.0,
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        width: 16.0,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      )),
                  Expanded(child: Text('Məhsul, brend və ya kateqoriya axtarın...', style: TextStyle(fontSize: 15.0, color: Colors.white))),
                ],
              ),
            ),
          ),
        ));
  }
}
