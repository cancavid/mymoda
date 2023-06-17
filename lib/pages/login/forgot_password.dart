import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/theme.dart';

import '../../themes/widgets/buttons.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool buttonLoading = false;
  String username = '';
  final _formKey = GlobalKey<FormState>();

  reset() async {
    var request = http.MultipartRequest("POST",
        Uri.parse("https://fashion.betasayt.com/api/auth.php?action=reset"));

    request.fields['username'] = username;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (mounted) {
      setState(() {
        buttonLoading = false;
      });
      if (result['status'] == 'success') {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: MsIconText(text: result['result'], type: 'success'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: MsIconText(text: result['error'], type: 'error'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Şifrə sıfırlanması')),
        body: RoundedBody(
          child: Form(
              key: _formKey,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                  children: [
                    Text(
                        'Aşağıda qeydiyyatdan keçdiyiniz istifadəçi adınızı və ya emailinizi qeyd edin. Sizin email ünvanınıza şifrə sıfırlanması ilə bağlı link göndəriləcəkdir.',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.greyColor,
                            height: 1.3,
                            fontSize: 17.0)),
                    SizedBox(height: 30.0),
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
                    SizedBox(height: 20.0),
                    MsButton(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              buttonLoading == false) {
                            setState(() {
                              buttonLoading = true;
                            });
                            reset();
                          }
                        },
                        loading: buttonLoading,
                        title: 'Sıfırla')
                  ])),
        ));
  }
}
