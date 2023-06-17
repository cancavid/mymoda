import 'package:flutter/material.dart';
import 'package:mymoda/components/account/account_widgets.dart';
import 'package:mymoda/themes/options.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tətbiq haqqında')),
      body: RoundedBody(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30.0),
          children: [
            SizedBox(height: 60.0),
            FlutterLogo(
              size: 66.0,
            ),
            SizedBox(height: 30.0),
            Text(
              'Versiya: 1.0.0',
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.0),
            AccountSection(
              widget: Column(
                children: [
                  AccountListTile(
                      heading: 'Bizi qiymətləndirin',
                      icon: 'star.svg',
                      action: () => launchUrl(
                          Uri.parse('https://masterstudio.az'),
                          mode: LaunchMode.externalApplication)),
                  AccountListTile(
                      heading: 'Tətbiqi paylaş',
                      icon: 'share.svg',
                      action: () => Share.share('Cavid'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
