import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/account/log_reg_seperator.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/pages/login/confirm_account.dart';
import 'package:mymoda/pages/login/forgot_password.dart';
import 'package:mymoda/pages/login/social_login.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/methods.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';

import '../../themes/widgets/buttons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool buttonLoading = false;
  String username = 'masterman';
  String password = '228432ac';
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  login() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/auth.php?action=login"));

    request.fields['username'] = username;
    request.fields['password'] = password;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));
    if (mounted) {
      setState(() {
        buttonLoading = false;
        if (result['status'] == 'success') {
          if (result['result']['user_status'] == '1') {
            loginController.update(true, result['result']);
            Get.back();
          } else {
            customAlert(context, Icons.account_box, 'Sizin hesabınız hazırda aktiv deyil', 'Aktiv et', () {
              Get.to(() => ConfirmAccountPage(), arguments: [result['result']['token'], 'resend']);
            }, 'İmtina', () => Get.back());
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: MsIconText(text: result['error'], type: 'error'),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 15.0),
          children: [
            TextFieldLabel(label: 'İstifadəçi adı və ya email'),
            TextFormField(
              initialValue: username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'İstifadəçi adı və ya email qeyd etməlisiniz.';
                }
                setState(() {
                  username = value;
                });
                return null;
              },
            ),
            MsSpace(),
            TextFieldLabel(label: 'Şifrə'),
            Stack(
              children: [
                TextFormField(
                  initialValue: password,
                  obscureText: !showPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifrə qeyd etməmisiniz.';
                    }
                    setState(() {
                      password = value;
                    });
                    return null;
                  },
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: SvgPicture.asset(
                          (showPassword) ? 'assets/icons/eye-crossed.svg' : 'assets/icons/eye.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.greyColor, BlendMode.srcIn),
                        ))),
              ],
            ),
            MsSpace(),
            Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => ForgotPasswordPage());
                    },
                    child: Text(
                      'Şifrənizi unutmusunuz?',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ))),
            MsSpace(),
            MsButton(
                onTap: () {
                  if (_formKey.currentState!.validate() && buttonLoading == false) {
                    setState(() {
                      buttonLoading = true;
                    });
                    login();
                  }
                },
                loading: buttonLoading,
                icon: true,
                title: 'Daxil ol'),
            LogRegSeparator(),
            SocialButtons(),
          ],
        ));
  }
}
