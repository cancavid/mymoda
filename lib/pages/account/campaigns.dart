import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/pages/account/single_campaigns.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  bool loading = true;
  List<dynamic> posts = [];
  bool noPosts = false;
  int limit = 5;
  int offset = 0;
  bool connection = true;
  late StreamSubscription<ConnectivityResult> subscription;

  Future<void> get(bool scroll) async {
    if (connection) {
      var url = Uri.parse('https://fashion.betasayt.com/api/posts.php?action=get&limit=$limit&offset=$offset');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              if (scroll) {
                posts = posts + result['result'];
              } else {
                posts = result['result'];
              }
            } else {
              noPosts = true;
            }
          });
        }
      }
    } else {
      setState(() {
        connection = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connect) {
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
        get(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kampaniyalar')),
      body: RoundedBody(
        child: (!connection & loading == true)
            ? const MsNotify(icon: Icons.signal_wifi_statusbar_connected_no_internet_4, heading: 'İnternetə qoşulu deyilsiniz.')
            : (loading)
                ? MsIndicator()
                : NotificationListener<ScrollEndNotification>(
                    onNotification: (scrollEnd) {
                      final metrics = scrollEnd.metrics;
                      if (metrics.atEdge) {
                        bool isTop = metrics.pixels == 0;
                        if (!isTop) {
                          setState(() {
                            offset = offset + limit;
                            get(true);
                          });
                        }
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          loading = true;
                          offset = 0;
                          noPosts = false;
                        });
                        return get(false);
                      },
                      strokeWidth: 2.6,
                      backgroundColor: Colors.white,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(15.0),
                        itemCount: posts.length + 1,
                        itemBuilder: (content, index) {
                          return (index == posts.length)
                              ? (noPosts)
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: Text(
                                        'Göstəriləcək başqa kampaniya yoxdur.',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : (posts.length >= limit)
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: 20.0),
                                          child: MsIndicator(),
                                        )
                                      : SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Get.to(() => SingleCampaignPage(data: posts[index]));
                                  },
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(20.0), child: MsImage(url: posts[index]['thumbnail_url'], width: MediaQuery.of(context).size.width, height: 200.0)),
                                    MsSpace(),
                                    Text(
                                      posts[index]['post_date'],
                                      style: TextStyle(fontSize: 13.0, color: MsColors.text),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      posts[index]['post_title'],
                                      style: TextStyle(fontSize: 18.0, height: 1.3),
                                    ),
                                  ]),
                                );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Column(
                            children: const [
                              SizedBox(height: 15.0),
                              Divider(color: Color(0xFFDDDDDD)),
                              SizedBox(height: 20.0),
                            ],
                          );
                        },
                      ),
                    )),
      ),
    );
  }
}
