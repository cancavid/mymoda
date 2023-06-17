import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 70.0,
      floating: false,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: SvgPicture.asset('assets/images/logo-mymoda.svg', width: 120.0, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        );
      }),
    );
  }
}
