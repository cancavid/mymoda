import 'package:flutter/material.dart';
import 'package:mymoda/components/home/logo.dart';
import 'package:mymoda/components/home/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
                  return [AppBarLogo(), AppBarSearch()];
                },
                body: Container())));
  }
}
