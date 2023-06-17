import 'package:flutter/material.dart';
import 'package:mymoda/pages/account/contact.dart';
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:mymoda/themes/widgets/modal.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheck {
  static Future<void> checkVersion(BuildContext context) async {
    String currentVersion = '';
    String latestVersion = '1.0.0';

    await _getAppVersion().then((version) {
      currentVersion = version;
    });

    if (currentVersion != latestVersion) {
      // ignore: use_build_context_synchronously
      _showUpdateBottomSheet(context);
    }
  }

  static Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static void _showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(children: [
          MsBottomSheet(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: MsModal(
                title: 'Tətbiqin yeni versiyası hazırdır',
                description: 'Çıxan yeniliklər aşağıda göstərilmişdir.',
                buttons: [
                  [
                    'İmtina et',
                    MsButtonStyle.secondary,
                    () {
                      Navigator.pop(context);
                    }
                  ],
                  [
                    'Yenilə',
                    MsButtonStyle.primary,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactPage()));
                    }
                  ],
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }
}
