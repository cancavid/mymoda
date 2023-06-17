import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/theme.dart';

import '../../themes/widgets/buttons.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  double imageSize = 150.0;
  bool loading = true;
  bool buttonLoading = false;
  Map data = {};
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  List types = [
    {'name': 'gallery', 'label': 'Qalereyadan yüklə', 'icon': '0xebb0'},
    {'name': 'camera', 'label': 'Kamera ilə çək', 'icon': '0xe130'},
    {'name': 'delete', 'label': 'Profil şəklini sil', 'icon': '0xe1b9'}
  ];
  File? _image;
  bool deleteImage = false;

  var loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(mask: '(###) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/users.php?action=get&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        loading = false;
        if (result['status'] == 'success') {
          data = result['result'];
          firstName = data['first_name'];
          lastName = data['last_name'];
          email = data['user_email'];
          phone = data['phone'] ?? '';
          address = data['address'] ?? '';
        }
      });
    }
  }

  List<Widget> typeSelector() => List<Widget>.generate(
      types.length,
      (index) => Container(
            padding: const EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width / 3,
            child: GestureDetector(
              onTap: () {
                if (types[index]['name'] == 'delete') {
                  setState(() {
                    _image = null;
                    data['profile_image'] = null;
                    deleteImage = true;
                  });
                } else if (types[index]['name'] == 'gallery') {
                  setState(() {
                    deleteImage = false;
                  });
                  getImage(ImageSource.gallery);
                } else if (types[index]['name'] == 'camera') {
                  setState(() {
                    deleteImage = false;
                  });
                  getImage(ImageSource.camera);
                }
                Get.back();
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Theme.of(context).colorScheme.lightColor),
                    child: Icon(
                      IconData(int.parse(types[index]['icon']), fontFamily: 'MaterialIcons'),
                      size: 36.0,
                      color: Theme.of(context).colorScheme.greyColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    types[index]['label'],
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ));

  Future getImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  update() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/users.php?action=update&token=${loginController.token.value}"));

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['user_email'] = email;
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['delete_image'] = deleteImage.toString();

    if (_image != null && deleteImage == false) {
      request.files.add(http.MultipartFile.fromBytes('profile_image', File(_image!.path).readAsBytesSync(), filename: _image!.path));
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));
    if (mounted) {
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: MsIconText(text: result['result']['message'], type: 'error'), backgroundColor: Colors.green));
        loginController.get();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: MsIconText(text: result['error'], type: 'error'), backgroundColor: Colors.red));
      }
      setState(() {
        buttonLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şəxsi məlumatlarınız')),
      body: RoundedBody(
        child: (loading)
            ? MsIndicator()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(imageSize),
                                child: (_image != null)
                                    ? Image.file(
                                        _image!,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      )
                                    : (data['profile_image'] != null)
                                        ? MsImage(
                                            url: data['profile_image'],
                                            width: imageSize,
                                            height: imageSize,
                                          )
                                        : AlphabetPP(data: data, size: imageSize, fontSize: 44.0)),
                            Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondColor, borderRadius: BorderRadius.circular(50.0)),
                                  child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: 150.0,
                                                child: Row(
                                                  children: typeSelector(),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      )),
                                )),
                          ],
                        )),
                    TextFieldLabel(label: 'Adınız'),
                    TextFormField(
                      initialValue: firstName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adınızı qeyd etməmisiniz.';
                        }
                        setState(() {
                          firstName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Soyadınız'),
                    TextFormField(
                      initialValue: lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Soyadınızı qeyd etməmisiniz.';
                        }
                        setState(() {
                          lastName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Email'),
                    TextFormField(
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email qeyd etməmisiniz.';
                        } else if (!GetUtils.isEmail(value)) {
                          return 'Email düzgün deyil.';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Telefon'),
                    TextFormField(
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.phone,
                      initialValue: phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefon qeyd etməmisiniz.';
                        }
                        setState(() {
                          phone = value;
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Çatdırılma ünvanı'),
                    TextFormField(
                      maxLines: 3,
                      initialValue: address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ünvan qeyd etməmisiniz.';
                        }
                        setState(() {
                          address = value;
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
                            update();
                          }
                        },
                        loading: buttonLoading,
                        title: 'Yadda saxla'),
                  ],
                ),
              ),
      ),
    );
  }
}
