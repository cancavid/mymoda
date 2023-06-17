import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/widgets/buttons.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool buttonLoading = false;
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  var loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  update() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/users.php?action=password&token=${loginController.token.value}"));

    request.fields['current'] = currentPassword;
    request.fields['new'] = newPassword;
    request.fields['confirm'] = confirmPassword;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (mounted) {
      setState(() {
        buttonLoading = false;
        if (result['status'] == 'success') {
          currentPassword = '';
          newPassword = '';
          confirmPassword = '';
          _formKey.currentState!.reset();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: MsIconText(text: result['result'], type: 'success'), backgroundColor: Colors.green));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: MsIconText(text: result['error'], type: 'error'), backgroundColor: Colors.red[700]));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şifrə dəyişdirmək')),
      body: RoundedBody(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              TextFieldLabel(label: 'Hazırkı şifrəniz'),
              TextFormField(
                initialValue: currentPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hazırkı şifrənizi qeyd etməmisiniz.';
                  }
                  setState(() {
                    currentPassword = value;
                  });
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFieldLabel(label: 'Yeni şifrə'),
              TextFormField(
                initialValue: newPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni şifrə qeyd etməmisiniz.';
                  }
                  setState(() {
                    newPassword = value;
                  });
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFieldLabel(label: 'Hazırkı şifrəniz'),
              TextFormField(
                initialValue: confirmPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni şifrənizin təkrarını qeyd etməmisiniz.';
                  }
                  setState(() {
                    confirmPassword = value;
                  });
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              MsButton(
                  onTap: () {
                    if (_formKey.currentState!.validate() && buttonLoading == false) {
                      setState(() {
                        buttonLoading = true;
                      });
                      update();
                    }
                  },
                  loading: buttonLoading,
                  icon: true,
                  title: 'Yadda saxla')
            ],
          ),
        ),
      ),
    );
  }
}
