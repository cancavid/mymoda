import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required PageController pageViewController,
    required this.currentPage,
  })  : _pageViewController = pageViewController,
        super(key: key);

  final PageController _pageViewController;
  final double currentPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pageViewController.animateToPage(currentPage.round() + 1,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
        child: const Center(
          child: Text(
            'Növbəti',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}