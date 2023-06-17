import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/account/account_widgets.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/pages/account/password.dart';
import 'package:mymoda/pages/login/my_account.dart';
import 'package:mymoda/pages/login/userinfo.dart';
import 'package:mymoda/pages/shop/orders.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';

class AccountHeader extends StatefulWidget {
  const AccountHeader({super.key});

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  var loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (loginController.login.value)
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => LogRegPage());
                          },
                          child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                              leading: (loginController.userdata['profile_image'] == null || loginController.userdata['profile_image'] == '')
                                  ? AlphabetPP(data: loginController.userdata)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: MsImage(url: loginController.userdata['profile_image'], width: 56.0, height: 56.0),
                                    ),
                              title: Text((loginController.userdata['display_name'] != null) ? loginController.userdata['display_name'] : 'Yüklənir...', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text((loginController.userdata['user_email'] != null) ? loginController.userdata['user_email'] : 'Yüklənir...', style: TextStyle(fontSize: 13.0, color: Theme.of(context).colorScheme.oppositeColor.withOpacity(.5))),
                              ),
                              horizontalTitleGap: 10.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return MsAlert(loginController: loginController);
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                          decoration: BoxDecoration(border: Border(left: BorderSide(color: Color(0xFFDDDDDD), width: 1.0))),
                          child: Column(
                            children: const [Icon(Icons.logout), SizedBox(height: 3.0), Text('Çıxış', style: TextStyle(color: Color(0xFF888888), fontSize: 12.0))],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(height: 5.0, width: double.infinity, color: Color(0xFFf2f3f7)),
                MsSpace(),
                AccountSection(
                  title: 'Mağaza',
                  widget: Column(
                    children: [
                      AccountListTile(heading: 'Sifarişləriniz', icon: 'orders.svg', action: () => Get.to(() => OrdersPage())),
                      AccountListTile(heading: 'Məlumatlarınız və çatdırılma ünvanı', icon: 'user.svg', action: () => Get.to(() => UserInfoPage())),
                      AccountListTile(heading: 'Şifrə dəyişdirmək', icon: 'key.svg', action: () => Get.to(() => ChangePasswordPage())),
                    ],
                  ),
                ),
              ],
            )
          : AccountSection(
              widget: GestureDetector(
              onTap: () {
                Get.to(() => LogRegPage());
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                leading: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary, size: 56.0),
                title: Text('Daxil ol', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text('Şəxsi kabinetə keçid et'),
                ),
                horizontalTitleGap: 10.0,
                trailing: Icon(Icons.chevron_right),
              ),
            )),
    );
  }
}

class MsAlert extends StatelessWidget {
  const MsAlert({
    Key? key,
    required this.loginController,
  }) : super(key: key);

  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 40.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Çıxış etmək istədiyinizdən əminsinizmi?',
              style: TextStyle(fontSize: 20.0, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Color(0xFFEDEDED), borderRadius: BorderRadius.circular(8.0)),
                    child: Text('İmtina et', style: TextStyle(fontSize: 17.0)),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    loginController.logout();
                  },
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(8.0)),
                    child: Text('Çıxış et', style: TextStyle(color: Colors.white, fontSize: 17.0)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
