import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/themes/theme.dart';

class MsBottomNavItem extends StatelessWidget {
  const MsBottomNavItem({super.key, required this.icon, required this.label, required this.index, required this.selected, this.badge = 0});

  final String icon;
  final String label;
  final int index;
  final int selected;
  final int badge;

  @override
  Widget build(BuildContext context) {
    String finalIcon = icon;
    Color color = MsColors.medium;

    if (index == selected) {
      finalIcon = 'bold-$icon';
      color = MsColors.secondary;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              'assets/navigations/$finalIcon',
              width: 22.0,
              height: 22.0,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            if (badge != 0) ...[
              Positioned(
                  top: -3.0,
                  right: -7.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(color: MsColors.primary, borderRadius: BorderRadius.circular(15.0)),
                    child: Text(badge.toString(), style: TextStyle(color: Colors.white, fontSize: 9.0)),
                  ))
            ]
          ],
        ),
        SizedBox(height: 7.0),
        Text(label, style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400))
      ],
    );
  }
}
