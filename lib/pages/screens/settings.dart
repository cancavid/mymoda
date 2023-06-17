import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mymoda/controllers/darkmode_controller.dart';
import 'package:mymoda/controllers/notification_controller.dart';
import 'package:mymoda/themes/options.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkmode = false;
  bool notification = true;
  List languages = ['Azərbaycanca', 'Rusca', 'English'];
  String selectedLanguage = 'Azərbaycanca';

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var darkmodeController = Get.put(DarkModeController());
  var notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();

    darkmode = darkmodeController.darkmode.value;
    notification = notificationController.notification.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parametrlər')),
      body: RoundedBody(
          child: ListView(
        padding: const EdgeInsets.all(20.0),
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0.0,
            title: Text('Qaranlıq rejim'),
            leading: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: SvgPicture.asset('assets/icons/eclipse-alt.svg', width: 20.0),
            ),
            trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    darkmode = !darkmode;
                    (darkmode == false) ? Get.changeThemeMode(ThemeMode.light) : Get.changeThemeMode(ThemeMode.dark);
                    darkmodeController.update(darkmode);
                  });
                },
                child: AnimatedSwitch(data: darkmode)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0.0,
            title: Text('Bildirişlər'),
            leading: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: SvgPicture.asset('assets/icons/bell.svg', width: 20.0),
            ),
            trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    notification = !notification;
                    notificationController.update(notification);
                    if (notification) {
                      firebaseMessaging.subscribeToTopic('all');
                    } else {
                      firebaseMessaging.unsubscribeFromTopic('all');
                    }
                  });
                },
                child: AnimatedSwitch(data: notification)),
          ),
          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0.0,
            title: Text('Tətbiqetmə dili'),
            leading: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: SvgPicture.asset('assets/icons/globe.svg', width: 20.0),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.0,
            ),
          )
        ],
      )),
    );
  }
}
