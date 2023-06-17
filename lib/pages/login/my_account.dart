import 'package:flutter/material.dart';
import 'package:mymoda/pages/login/login.dart';
import 'package:mymoda/pages/login/registration.dart';
import 'package:mymoda/themes/options.dart';

class LogRegPage extends StatefulWidget {
  const LogRegPage({super.key});

  @override
  State<LogRegPage> createState() => _LogRegPageState();
}

class _LogRegPageState extends State<LogRegPage> with TickerProviderStateMixin {
  late TabController _tabController;

  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Mənim hesabım'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Daxil ol',
                  ),
                  Tab(
                    text: 'Qeydiyyat',
                  )
                ],
              ),
            )),
        body: RoundedBody(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Login()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Saytda hesabınız yoxdur?'),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tabController.index = 1;
                            });
                          },
                          child: Text('Qeydiyyatdan keçin',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Registration()
            ],
          ),
        ));
  }
}
