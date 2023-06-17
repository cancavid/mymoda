import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/notify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Map data = {};
  bool loading = true;
  Map location = {};
  bool connection = true;
  late StreamSubscription<ConnectivityResult> subscription;

  get() async {
    if (connection) {
      var url = Uri.parse('https://fashion.betasayt.com/api/page.php?id=3');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              data = result['result'];
              location = data['location'];
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
    return Scaffold(
        appBar: AppBar(title: Text('Bizimlə əlaqə')),
        body: RoundedBody(
          child: RefreshIndicator(
            onRefresh: () {
              return get();
            },
            child: (!connection & loading == true)
                ? const MsNotify(icon: Icons.signal_wifi_statusbar_connected_no_internet_4, heading: 'İnternetə qoşulu deyilsiniz.')
                : (loading)
                    ? const MsIndicator()
                    : (data.isEmpty)
                        ? const MsNotify(icon: Icons.close, heading: 'Heç bir məlumat tapılmadı.')
                        : ListView(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 45.0),
                            children: [
                              ContactElement(heading: 'Əlaqə telefonu', value: data['phone'], icon: Icons.phone, url: 'tel:${data["phone"]}'),
                              ContactElement(heading: 'Elektron poçt', value: data['email'], icon: Icons.email, url: 'mailto:${data["email"]}'),
                              ContactElement(heading: 'Ünvan', value: data['address_az'], icon: Icons.directions, url: location['url']),
                              ContactElement(
                                heading: 'İş günləri və saatları',
                                value: '${data['work_days_az']}: ${data['work_clock']}',
                                icon: Icons.access_time_filled,
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    Text('Sosial şəbəkələr', style: TextStyle(fontSize: 17.0)),
                                    const SizedBox(height: 15.0),
                                    Row(
                                      children: [
                                        SocialNetwork(image: 'assets/social/facebook.svg', url: data['facebook'], color: Color(0xFF1877f2)),
                                        SocialNetwork(image: 'assets/social/instagram.svg', url: data['instagram'], color: Color(0xFFc32aa3)),
                                        SocialNetwork(image: 'assets/social/youtube.svg', url: data['youtube'], color: Color(0xFFff0000)),
                                        SocialNetwork(image: 'assets/social/whatsapp.svg', url: data['whatsapp'], color: Color(0xFF25d366)),
                                      ],
                                    )
                                  ]),
                                ],
                              )
                            ],
                          ),
          ),
        ));
  }
}

class SocialNetwork extends StatelessWidget {
  final String image;
  final String url;
  final Color color;

  const SocialNetwork({Key? key, required this.image, required this.url, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Theme.of(context).colorScheme.backgroundColor),
      child: InkWell(
        onTap: () => {launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)},
        child: SvgPicture.asset(
          image,
          width: 50.0,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class ContactElement extends StatelessWidget {
  final String heading;
  final String value;
  final IconData icon;
  final String url;

  const ContactElement({super.key, required this.heading, required this.value, required this.icon, this.url = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: () => {
          if (url != '') ...[launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)]
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: MsIconText(text: 'Məlumat panoya kopyalandı.'),
            duration: const Duration(seconds: 1),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    heading,
                    style: TextStyle(color: Theme.of(context).colorScheme.appBarColor),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 20.0),
                  )
                ]),
              ),
              SizedBox(
                width: 50.0,
              ),
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
