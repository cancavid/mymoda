import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/options.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductGallerySlider extends StatefulWidget {
  const ProductGallerySlider({super.key, required this.data});

  final Map data;

  @override
  State<ProductGallerySlider> createState() => _ProductGallerySliderState();
}

class _ProductGallerySliderState extends State<ProductGallerySlider> {
  List slide = [];
  final List<String> _imageUrls = [];
  int activeDot = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    if (check(widget.data['gallery'])) {
      slide = widget.data['gallery'];
      count = slide.length;
      for (var i = 0; i < count; i++) {
        _imageUrls.add(slide[i]['media_url']);
      }
    }
  }

  List<Widget> indicator() => List<Widget>.generate(
      count,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 7.0,
            width: 7.0,
            decoration: BoxDecoration(color: activeDot == index ? Colors.white : Colors.white.withOpacity(.2), borderRadius: BorderRadius.circular(10.0)),
          ));

  @override
  Widget build(BuildContext context) {
    return (count > 1)
        ? Stack(
            children: [
              CarouselSlider.builder(
                itemCount: slide.length,
                options: CarouselOptions(
                    height: 500.0,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    initialPage: 0,
                    onPageChanged: ((index, reason) {
                      setState(() {
                        activeDot = index;
                      });
                    })),
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                  onTap: () {
                    Get.to(
                      transition: Transition.fade,
                      () => LightboxScreen(
                        imageUrls: _imageUrls,
                        initialIndex: itemIndex,
                      ),
                    );
                  },
                  child: MsImage(url: slide[itemIndex]['media_url'], height: 400.0),
                ),
              ),
              Positioned(bottom: 15, left: MediaQuery.of(context).size.width / 2 - (count * 7.5), child: Row(children: indicator()))
            ],
          )
        : MsImage(url: widget.data['media_url'], height: 400.0);
  }
}

class LightboxScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const LightboxScreen({super.key, required this.imageUrls, required this.initialIndex});

  @override
  State<LightboxScreen> createState() => _LightboxScreenState();
}

class _LightboxScreenState extends State<LightboxScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              loadingBuilder: (context, event) {
                return MsIndicator();
              },
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              itemCount: widget.imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              pageController: PageController(initialPage: _currentIndex),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Color.fromARGB(255, 204, 0, 0).withOpacity(0.5),
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currentIndex + 1}/${widget.imageUrls.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 32.0,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
