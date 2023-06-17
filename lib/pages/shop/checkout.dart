import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/pages/shop/payment.dart';
import 'package:mymoda/pages/shop/success.dart';
import 'package:mymoda/themes/forms.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/buttons.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool loading = true;
  bool userLoading = true;
  bool buttonLoading = false;
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';
  String address = '';
  String note = '';
  String error = '';
  String totalPrice = '';
  String displaySale = '';
  String finalPrice = '';
  String id = '';
  String method = 'offline';
  Map data = {};

  var loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  cart() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/cart.php?action=get&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            totalPrice = result['result']['total_price'].toString();
            displaySale = result['result']['display_sale'];
            finalPrice = result['result']['final_price'].toString();
          } else {
            error = result['error'];
          }
        });
      }
    }
  }

  user() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/users.php?action=get&token=${loginController.token.value}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        userLoading = false;
        if (result['status'] == 'success') {
          data = result['result'];
          if (data['session_login'] == '1') {
            firstName = data['first_name'];
            lastName = data['last_name'];
            email = data['user_email'];
            phone = data['phone'] ?? '';
            address = data['address'] ?? '';
          }
        }
      });
    }
  }

  order() async {
    var request = http.MultipartRequest("POST", Uri.parse("https://fashion.betasayt.com/api/checkout.php?token=${loginController.token.value}'"));

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['address'] = address;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['note'] = note;
    request.fields['method'] = method;
    request.fields['appmode'] = '1';

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = json.decode(utf8.decode(responseData));

    if (result['status'] == 'success') {
      if (method == 'offline') {
        Get.close(1);
        Get.to(() => SuccessPage(), transition: Transition.fade);
      } else {
        Get.to(() => PaymentPage(url: result['result']));
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: MsIconText(text: result['error'], type: 'error'),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      buttonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    id = loginController.token.value;
    cart();
    user();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sifariş tamamlanması')),
      body: RoundedBody(
        child: (loading || userLoading)
            ? MsIndicator()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(25.0),
                  children: [
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
                          firstName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Telefon'),
                    TextFormField(
                      initialValue: phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefon qeyd etməmisiniz.';
                        }
                        setState(() {
                          firstName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Çatdırılma ünvanı'),
                    TextFormField(
                      initialValue: address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Çatdırılma ünvanı qeyd etməmisiniz.';
                        }
                        setState(() {
                          firstName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Email'),
                    TextFormField(
                      initialValue: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email qeyd etməmisiniz.';
                        }
                        setState(() {
                          firstName = value;
                        });
                        return null;
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Əlavə qeydiniz'),
                    TextFormField(
                      maxLines: 3,
                      initialValue: note,
                    ),
                    SizedBox(height: 15.0),
                    TextFieldLabel(label: 'Ödəniş üsulu'),
                    RadioListTile(
                        contentPadding: const EdgeInsets.all(0.0),
                        title: const Text('Qapıda ödəmə'),
                        value: 'offline',
                        groupValue: method,
                        onChanged: (value) {
                          setState(() {
                            method = value!;
                          });
                        }),
                    RadioListTile(
                        contentPadding: const EdgeInsets.all(0.0),
                        title: const Text('Onlayn ödəniş'),
                        value: 'online',
                        groupValue: method,
                        onChanged: (value) {
                          setState(() {
                            method = value!;
                          });
                        }),
                    SizedBox(height: 15.0),
                    Container(
                      color: Theme.of(context).colorScheme.greyColor,
                      height: 1.0,
                    ),
                    SizedBox(height: 15.0),
                    Column(
                      children: [
                        (displaySale.isNotEmpty)
                            ? Column(
                                children: [
                                  priceTable('Ümumi məbləğ:', fullPrice(totalPrice)),
                                  SizedBox(height: 15.0),
                                  priceTable('Endirim:', displaySale),
                                  SizedBox(height: 15.0),
                                ],
                              )
                            : Text(''),
                        priceTable('Yekun məbləğ:', fullPrice(finalPrice)),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    MsButton(
                      onTap: () {
                        if (_formKey.currentState!.validate() && buttonLoading == false) {
                          setState(() {
                            buttonLoading = true;
                          });
                          order();
                        }
                      },
                      loading: buttonLoading,
                      title: 'Sifarişi tamamla',
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Row priceTable(first, second) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(first), Text(second)],
    );
  }
}
