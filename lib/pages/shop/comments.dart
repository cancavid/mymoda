import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mymoda/components/single_product/comments/single_comment.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/widgets/notify.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.postId});

  final String postId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool connection = true;
  bool loading = true;
  List comments = [];
  late StreamSubscription<ConnectivityResult> subscription;

  get() async {
    var url = Uri.parse(
        'https://fashion.betasayt.com/api/comments.php?action=get&post_id=${widget.postId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        loading = false;
        if (result['status'] == 'success') {
          comments = result['result']['comments'];
        }
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bütün rəylər')),
      body: RoundedBody(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              loading = true;
            });
            return checkConnectivity();
          },
          child: (!connection & loading == true)
              ? const MsNotify(
                  icon: Icons.signal_wifi_statusbar_connected_no_internet_4,
                  heading: 'İnternetə qoşulu deyilsiniz.')
              : (loading)
                  ? MsIndicator()
                  : ListView.separated(
                      padding: const EdgeInsets.all(30.0),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return SingleComment(data: comments[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(height: 40.0);
                      }),
        ),
      ),
    );
  }
}
