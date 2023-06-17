import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/components/welcome/final_button.dart';
import 'package:mymoda/components/welcome/next_button.dart';
import 'package:mymoda/themes/options.dart';

import '../components/welcome/welcome_list.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> indicator() => List<Widget>.generate(
      items.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 7.0,
            width: 7.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Colors.white
                    : Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageViewController,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30.0),
                  height: MediaQuery.of(context).size.height - 130.0,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SvgPicture.asset(
                          items[index]['image'],
                          width: 150.0,
                          height: 150.0,
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          items[index]['header'],
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 15.0,
              left: 30.0,
              child: Container(
                height: 130.0,
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator(),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    (currentPage.round() == items.length - 1)
                        ? const FinalButton()
                        : NextButton(
                            pageViewController: _pageViewController,
                            currentPage: currentPage),
                    const SizedBox(
                      height: 30.0,
                    )
                  ],
                ),
              ),
            ),
            // )
          ],
        ),
      ),
    );
  }
}
