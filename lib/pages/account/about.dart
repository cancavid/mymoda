import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/notify.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String data = '';
  bool loading = true;

  get() async {
    var url = Uri.parse(
        'https://fashion.betasayt.com/api/page.php?id=2&key=page_content_az');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            data = result['result'];
          }
        });
      }
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
      appBar: AppBar(title: Text('Haqqımızda')),
      body: RoundedBody(
        child: (loading)
            ? const MsIndicator()
            : (data.isEmpty)
                ? MsNotify(heading: 'Heç bir məlumat tapılmadı.')
                : ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [MsHtml(data: data)]),
      ),
    );
  }
}
