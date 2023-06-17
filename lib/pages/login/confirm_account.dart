import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmAccountPage extends StatefulWidget {
  const ConfirmAccountPage({super.key});

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  dynamic arg = Get.arguments;
  bool buttonLoading = false;
  String code = '';
  String token = '';

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  bool timeFinish = false;
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    if (arg != null) {
      token = arg[0]['token'];
      if (arg.length == 2 && arg[1] == 'resend') {
        resend();
      }
    }
  }

  void onEnd() {
    if (mounted) {
      setState(() {
        timeFinish = true;
      });
    }
  }

  confirm() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/auth.php?action=confirm"));

    request.fields['code'] = code;
    request.fields['token'] = token;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (mounted) {
      if (result['status'] == 'success') {
        loginController.update(true, result['result']);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: MsIconText(text: 'Hesabınız təsdiq edilmişdir.', type: 'success'),
          backgroundColor: Colors.green,
        ));
        Get.back();
      } else {
        setState(() {
          buttonLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: MsIconText(text: result['error'], type: 'error'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  resend() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/auth.php?action=resend"));

    request.fields['token'] = token;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (mounted) {
      if (result['status'] == 'success') {
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
      appBar: AppBar(title: Text('Hesab təsdiqlənməsi')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 45.0),
          children: [
            Text(
              'Emailinizə gələn kodu daxil edin.',
              style: TextStyle(fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.0),
            Text(
              'Heç bir email almamısınızsa, "SPAM" qovluğuna nəzər yetirin',
              style: TextStyle(color: Theme.of(context).colorScheme.greyColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.none,
              dialogConfig: DialogConfig(
                dialogTitle: 'Buraya əlavə et',
                dialogContent: 'Kopyalanmış kodu əlavə etmək istəyirsiniz',
                affirmativeText: 'Daxil et',
                negativeText: 'İmtina',
              ),
              pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderRadius: BorderRadius.circular(5), borderWidth: 1.0, fieldHeight: 50, fieldWidth: 40, selectedFillColor: Colors.white, selectedColor: Colors.black, activeFillColor: Theme.of(context).colorScheme.lightColor, activeColor: Theme.of(context).colorScheme.lightColor, inactiveFillColor: Colors.white, inactiveColor: Color(0xFFDDDDDD)),
              animationDuration: Duration(milliseconds: 100),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onCompleted: (value) {
                setState(() {
                  code = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  code = value;
                });
              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
            SizedBox(height: 30.0),
            MsButton(
                onTap: () {
                  if (code.length == 6) {
                    setState(() {
                      buttonLoading = true;
                    });
                    confirm();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: MsIconText(text: 'Təsdiq kodunu tam qeyd etməmisiniz.', type: 'error'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                loading: buttonLoading,
                title: 'Təsdiqlə'),
            SizedBox(height: 30.0),
            Text(
              'Hələ də email ala bilməmisinizsə, vaxt bitdikdən sonra təkrar istək göndərin.',
              style: TextStyle(color: Theme.of(context).colorScheme.greyColor),
              textAlign: TextAlign.center,
            ),
            (timeFinish)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                        timeFinish = false;
                      });
                      resend();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Təkrar göndər', textAlign: TextAlign.center),
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        CountdownTimer(
                          endTime: endTime,
                          onEnd: onEnd,
                          widgetBuilder: (_, time) {
                            return Text('${time!.min ?? '00'} : ${time.sec.toString().padLeft(2, '0')}');
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
