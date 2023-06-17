import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/theme.dart';

class SocialLogin {
  Future socialLogin(socialId, socialPlatform, info) async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/auth.php?action=social"));

    request.fields['social_id'] = socialId;
    request.fields['social_platform'] = socialPlatform;
    request.fields['info'] = json.encode(info);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (result['status'] == 'success') {
      if (result['result']['user_status'] == '1') {
        final loginController = Get.put(LoginController());
        loginController.update(true, result['result'], socialPlatform);
        Get.back();
      } else {
        Get.snackbar('Xəta', 'Sizin hesabınız aktiv deyil.');
      }
    }
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final data = await GoogleSignIn().signIn();
              Map info = {'name': data!.displayName, 'email': data.email, 'id': data.id, 'photo': data.photoUrl};
              await SocialLogin().socialLogin(data.id, 'Google', info);
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(border: Border.all(color: MsColors.light), borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/google.svg', width: 24.0, colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Google', style: TextStyle(color: Colors.black, fontSize: 15.0))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              /*
              FacebookAuth.instance.login(
                permissions: ['public_profile', 'email']).then((value) {
                  FacebookAuth.instance.getUserData().then((data) async {
                    await SocialLogin().socialLogin(data['id'], 'Facebook', data);
                  });
                });
              */
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(border: Border.all(color: MsColors.light), borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.facebook_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10.0),
                  Text('Facebook', style: TextStyle(color: Colors.black, fontSize: 15.0))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
