import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/notify.dart';
import 'package:share_plus/share_plus.dart';

class SingleCampaignPage extends StatefulWidget {
  final Map data;
  final String id;

  const SingleCampaignPage({super.key, this.data = const {}, this.id = ''});

  @override
  State<SingleCampaignPage> createState() => _SingleCampaignPageState();
}

class _SingleCampaignPageState extends State<SingleCampaignPage> {
  Map data = {};
  String id = '';
  bool loading = false;
  String postUrl = '';

  get() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/posts.php?action=get&id=$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          loading = false;
          if (result['status'] == 'success') {
            data = result['result'];
            postUrl = data['url'];
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.data.isEmpty) {
      setState(() {
        loading = true;
      });
      id = widget.id;
      get();
    } else {
      setState(() {
        data = widget.data;
        postUrl = data['url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MsColors.primary,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Share.share(postUrl);
          },
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          child: const Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            title: Text('Kampaniyalar'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: RoundedBody(
              child: (loading)
                  ? const MsIndicator()
                  : RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          loading = true;
                          id = data['post_id'];
                          data = {};
                        });
                        return get();
                      },
                      child: (data.isEmpty)
                          ? MsNotify(icon: Icons.close, heading: 'Heç bir məlumat tapılmadı')
                          : ListView(
                              shrinkWrap: true,
                              physics: PageScrollPhysics(),
                              padding: EdgeInsets.all(0.0),
                              children: [
                                MsImage(url: data['media_url'], width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width * 2 / 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15.0),
                                      Text(
                                        data['post_date'],
                                        style: TextStyle(color: MsColors.text),
                                      ),
                                      const SizedBox(height: 15.0),
                                      MsHtml(
                                        data: data['post_title'],
                                        size: 22.0,
                                        lineHeight: 1.2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 15.0),
                                      MsHtml(data: data['post_content'], size: 18.0),
                                      const SizedBox(height: 30.0)
                                    ],
                                  ),
                                )
                              ],
                            ),
                    ),
            ),
          )
        ]));
  }
}
