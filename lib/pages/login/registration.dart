import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/account/log_reg_seperator.dart';
import 'package:mymoda/components/account/registration_widgets.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/pages/login/confirm_account.dart';
import 'package:mymoda/pages/login/social_login.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;

import '../../themes/widgets/buttons.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool buttonLoading = false;
  String firstName = 'Cavid';
  String lastName = 'Muradov';
  String username = 'cancavid';
  String email = 'cavimur@gmail.com';
  String password = '228432ac';
  String confirmPassword = '228432ac';
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  registration() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/auth.php?action=registration"));

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['user_login'] = username;
    request.fields['user_email'] = email;
    request.fields['user_password'] = password;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (mounted) {
      setState(() {
        buttonLoading = false;
        if (result['status'] == 'success') {
          Get.off(() => ConfirmAccountPage(), arguments: [result['result']]);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: MsIconText(icon: Icons.error, text: result['error'].replaceAll('<br>', '\n')),
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
          padding: const EdgeInsets.all(20.0),
          children: [
            RegAdvantages(),
            MsSpace(),
            SocialButtons(),
            LogRegSeparator(),
            TextFieldLabel(label: 'Adınız'),
            TextFormField(
              initialValue: firstName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Adınızı qeyd etməlisiniz.';
                }
                setState(() {
                  firstName = value;
                });
                return null;
              },
            ),
            MsSpace(),
            TextFieldLabel(label: 'Soyadınız'),
            TextFormField(
              initialValue: lastName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Soyadınızı qeyd etməlisiniz.';
                }
                setState(() {
                  lastName = value;
                });
                return null;
              },
            ),
            MsSpace(),
            TextFieldLabel(label: 'İstifadəçi adı'),
            TextFormField(
              initialValue: username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'İstifadəçi adı qeyd etməlisiniz.';
                }
                setState(() {
                  username = value;
                });
                return null;
              },
            ),
            MsSpace(),
            TextFieldLabel(label: 'Email'),
            TextFormField(
              initialValue: email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email qeyd etməlisiniz.';
                } else if (!GetUtils.isEmail(value.trim())) {
                  return 'Email düzgün deyil.';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
            ),
            MsSpace(),
            TextFieldLabel(label: 'Şifrə'),
            TextFormField(
              initialValue: password,
              obscureText: true,
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
            MsSpace(),
            TextFieldLabel(label: 'Şifrənizin təkrarı'),
            TextFormField(
              initialValue: confirmPassword,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifrənizin təkrarını qeyd etməmisiniz.';
                } else if (value != password) {
                  return 'Şifrəniz təkrarı ilə eyni deyil.';
                }
                setState(() {
                  confirmPassword = value;
                });
                return null;
              },
            ),
            SizedBox(height: 20.0),
            MsButton(
                onTap: () {
                  if (_formKey.currentState!.validate() && buttonLoading == false) {
                    setState(() {
                      buttonLoading = true;
                    });
                    registration();
                  }
                },
                loading: buttonLoading,
                icon: true,
                title: 'Qeydiyyatdan keç'),
            SizedBox(height: 15.0),
          ],
        ));
  }
}
