import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymoda/themes/options.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List slide = [];
  int activeDot = 0;

  sitedata() async {
    var url = Uri.parse('https://fashion.betasayt.com/api/site.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      if (mounted) {
        setState(() {
          slide = result['slide'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sitedata();
  }

  List<Widget> indicator() => List<Widget>.generate(
      slide.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 7.0,
            width: 7.0,
            decoration: BoxDecoration(color: activeDot == index ? Colors.white : Colors.white.withOpacity(.2), borderRadius: BorderRadius.circular(10.0)),
          ));

  @override
  Widget build(BuildContext context) {
    return (slide.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: slide.length,
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      initialPage: 0,
                      onPageChanged: ((index, reason) {
                        setState(() {
                          activeDot = index;
                        });
                      })),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: MsImage(url: slide[itemIndex]['s_image']['media_url'], height: 220.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: indicator())
              ],
            ),
          )
        : SizedBox();
  }
}
