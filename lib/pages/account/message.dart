import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String name = '';
  String email = '';
  String message = '';

  bool success = false;
  bool buttonLoading = false;
  Map data = {};

  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  send() async {
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://fashion.betasayt.com/api/form.php?form_type=contact"));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['message'] = message;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));
    if (mounted) {
      if (result['status'] == 'success') {
        setState(() {
          success = true;
          data = result;
        });
      } else if (result['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: MsIconText(text: data['errors'], type: 'error'),
          backgroundColor: Colors.red[700],
        ));
      }
      setState(() {
        buttonLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mesaj göndərin')),
        body: RoundedBody(
          child: Form(
              key: _formKey,
              child: (success)
                  ? MsNotify(
                      icon: Icons.check,
                      heading: data['result'],
                      color: Colors.green)
                  : ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 55.0, horizontal: 25.0),
                        children: [
                          Text(
                            'Əlavə sual və təkliflərinizlə bağlı aşağıdakı formdan bizə yaza bilərsiniz. Ən qısa zamanda əməkdaşlarımız sizə geri dönüş edəcəklər.',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).colorScheme.greyColor,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50.0),
                          TextFieldLabel(label: 'Ad və soyadınız'),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ad və soyadınızı qeyd etməmisiniz.';
                              }
                              setState(() {
                                name = value;
                              });
                              return null;
                            },
                          ),
                          MsSpace(),
                          TextFieldLabel(label: 'Email'),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email qeyd etməmisiniz.';
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
                          TextFieldLabel(label: 'Mesajınız'),
                          TextFormField(
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Heç bir mesaj qeyd etməmisiniz.';
                              }
                              setState(() {
                                message = value;
                              });
                              return null;
                            },
                          ),
                          MsSpace(),
                          MsButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate() &&
                                    buttonLoading == false) {
                                  var connect = await (Connectivity()
                                      .checkConnectivity());
                                  if (connect == ConnectivityResult.none) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: MsIconText(
                                          text: 'İnternet bağlantısı yoxdur.',
                                          type: 'error'),
                                      backgroundColor: Colors.red[700],
                                    ));
                                  } else {
                                    setState(() {
                                      buttonLoading = true;
                                    });
                                    send();
                                  }
                                  connectivitySubscription.cancel();
                                }
                              },
                              loading: buttonLoading,
                              icon: true,
                              title: 'Göndər'),
                        ],
                      ),
                    )),
        ));
  }
}
