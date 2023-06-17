import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:mymoda/themes/widgets/headings.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key, required this.postId});

  final String postId;

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  String name = '';
  String email = '';
  int rating = 0;
  String comment = '';
  String ratingError = '';
  bool buttonLoading = false;

  final loginController = Get.put(LoginController());

  send() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/comments.php?action=add"));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['rating'] = rating.toString();
    request.fields['comment'] = comment;
    request.fields['post_id'] = widget.postId;
    request.fields['token'] = loginController.token.value;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));
    if (mounted) {
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result['result']),
          backgroundColor: Colors.green,
        ));
        Get.back();
      } else if (result['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result['error']),
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
  void initState() {
    super.initState();
    if (loginController.login.value) {
      setState(() {
        name = loginController.userdata['display_name'];
        email = loginController.userdata['user_email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
        height: MediaQuery.of(context).size.height * 0.75,
        static: true,
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(padding: const EdgeInsets.all(30.0), shrinkWrap: true, children: [
              MsMediumHeading(title: 'Rəy bildirin'),
              MsSpace(),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rəyiniz administratorun təsdiqindən sonra görünəcəkdir.', style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.greyColor, height: 1.3)),
                      const SizedBox(height: 25.0),
                      if (loginController.login.value) ...[
                        Text('${loginController.userdata['display_name']} olaraq şərh bildirsiniz.'),
                      ] else ...[
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email qeyd etməmisiniz.';
                            } else if (!GetUtils.isEmail(value.trim())) {
                              return 'Email düzgün deyil';
                            }
                            setState(() {
                              email = value;
                            });
                            return null;
                          },
                        ),
                      ],
                      MsSpace(),
                      TextFieldLabel(label: 'Qiymətləndirmə'),
                      Row(
                        children: [
                          for (var i = 1; i <= 5; i++) ...[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    rating = i;
                                  });
                                },
                                child: Icon((i <= rating) ? Icons.star : Icons.star_border, color: Colors.orange))
                          ]
                        ],
                      ),
                      if (ratingError.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text('Qiymətləndirmə qeyd etməmisiniz.', style: TextStyle(color: Colors.red, fontSize: 12.0)),
                        )
                      ],
                      MsSpace(),
                      TextFieldLabel(label: 'Mesajınız'),
                      TextFormField(
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Heç bir şərh qeyd etməmisiniz.';
                          }
                          setState(() {
                            comment = value;
                          });
                          return null;
                        },
                      ),
                      MsSpace(),
                      MsButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() && buttonLoading == false) {
                              setState(() {
                                buttonLoading = true;
                              });
                              send();
                            } else if (rating == 0) {
                              setState(() {
                                ratingError = 'Qiymətləndirmə qeyd etməmisiniz.';
                              });
                            }
                          },
                          loading: buttonLoading,
                          title: 'Göndər'),
                    ],
                  ))
            ])));
  }
}
