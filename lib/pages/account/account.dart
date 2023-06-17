import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/account/account_widgets.dart';
import 'package:mymoda/components/account/account_header.dart';
import 'package:mymoda/pages/account/about.dart';
import 'package:mymoda/pages/account/appinfo.dart';
import 'package:mymoda/pages/account/campaigns.dart';
import 'package:mymoda/pages/account/contact.dart';
import 'package:mymoda/pages/account/faq.dart';
import 'package:mymoda/pages/account/message.dart';
import 'package:mymoda/pages/screens/settings.dart';
import 'package:mymoda/themes/options.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mənim hesabım')),
        body: RoundedBody(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              AccountHeader(),
              MsSpace(),
              AccountSection(
                  title: 'Sizə faydalı',
                  widget: Column(children: [
                    AccountListTile(heading: 'Kampaniyalar', icon: 'campaign.svg', action: () => Get.to(() => CampaignsPage())),
                    AccountListTile(heading: 'Ən çox soruşulan suallar', icon: 'faq.svg', action: () => Get.to(() => FaqPage())),
                  ])),
              MsSpace(),
              AccountSection(
                  title: 'Haqqımızda',
                  widget: Column(children: [
                    AccountListTile(heading: 'Haqqımızda', icon: 'about.svg', action: () => Get.to(() => AboutPage())),
                    // AccountListTile(heading: 'Haqqımızda', icon: 'about.svg', action: () => Get.to(() => StoreMapPage())),
                    AccountListTile(heading: 'Bizimlə əlaqə', icon: 'phone.svg', action: () => Get.to(() => ContactPage())),
                    AccountListTile(heading: 'Bizə mesaj göndərin', icon: 'message.svg', action: () => Get.to(() => MessagePage())),
                  ])),
              MsSpace(),
              AccountSection(title: 'Tətbiq haqqında', widget: Column(children: [AccountListTile(heading: 'Tətbiq parametrləri', icon: 'settings.svg', action: () => Get.to(() => SettingsPage())), AccountListTile(heading: 'Tətbiq haqqında', icon: 'info.svg', action: () => Get.to(() => AppInfoPage()))])),
              SizedBox(height: 15.0)
            ],
          ),
        ));
  }
}
