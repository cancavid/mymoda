import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/themes/theme.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key, this.title = '', required this.widget});

  final dynamic widget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != '') ...[Text(title, style: TextStyle(fontSize: 15.0, color: MsColors.text)), SizedBox(height: 10.0)],
              widget
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class AccountListTile extends StatelessWidget {
  const AccountListTile({super.key, required this.heading, required this.icon, required this.action});

  final String heading;
  final String icon;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      contentPadding: const EdgeInsets.all(0),
      horizontalTitleGap: 0.0,
      title: Text(heading),
      leading: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Opacity(opacity: .5, child: SvgPicture.asset('assets/icons/$icon', width: 20.0, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.oppositeColor, BlendMode.srcIn))),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13.0,
        color: Theme.of(context).colorScheme.greyColor,
      ),
    );
  }
}
