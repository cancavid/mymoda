import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool loading = true;
  List faq = [];
  int activeFaq = -1;
  int activeFaqItem = -1;
  bool connection = true;
  late StreamSubscription<ConnectivityResult> subscription;

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/page.php?id=4');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            faq = result['result']['faq_az'];
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connect) {
      getData(connect, false);
    });
  }

  Future<void> checkConnectivity() async {
    var connect = await (Connectivity().checkConnectivity());
    getData(connect, true);
  }

  getData(connect, check) {
    setState(() {
      if (connect == ConnectivityResult.none) {
        connection = false;
        if (check == false) {
          errorNetwork();
        }
      } else {
        connection = true;
        get();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Ən çox soruşulan suallar')),
      body: RoundedBody(
        child: (loading)
            ? MsIndicator()
            : (faq.isEmpty)
                ? Text('')
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: faq.length,
                    itemBuilder: (content, index) {
                      return Column(
                        children: [
                          ListView(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 0.0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Text(faq[index]['f_main_heading_az'],
                                  style: TextStyle(color: Colors.grey)),
                              MsSpace(),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: faq[index]['f_questions_az'].length,
                                itemBuilder: (c, i) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (activeFaq == index &&
                                                activeFaqItem == i) {
                                              activeFaq = -1;
                                              activeFaqItem = -1;
                                            } else {
                                              activeFaq = index;
                                              activeFaqItem = i;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      faq[index][
                                                              'f_questions_az'][
                                                          i]['f_question_az'],
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          color: (activeFaq ==
                                                                      index &&
                                                                  activeFaqItem ==
                                                                      i)
                                                              ? Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                              : Colors.black))),
                                              SizedBox(width: 15.0),
                                              AnimatedRotation(
                                                  turns: (activeFaq == index &&
                                                          activeFaqItem == i)
                                                      ? 0.5
                                                      : 0.0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: Icon(Icons
                                                      .keyboard_arrow_down))
                                            ],
                                          ),
                                        ),
                                      ),
                                      AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        alignment: Alignment.topCenter,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Visibility(
                                            visible: (activeFaq == index &&
                                                    activeFaqItem == i)
                                                ? true
                                                : false,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Text(
                                                faq[index]['f_questions_az'][i]
                                                    ['f_answer_az'],
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    color: Color(0xFFf2f3f7),
                                    thickness: 1.0,
                                    height: 1.0,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Color(0xFFf2f3f7),
                        thickness: 10.0,
                        height: 10.0,
                      );
                    },
                  ),
      ),
    ));
  }
}
