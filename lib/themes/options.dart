import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/theme.dart';

class Shop {
  static String currency = '₼';
  static double maxPrice = 300.0;
}

class MsIndicator extends StatelessWidget {
  const MsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: CircularProgressIndicator(
        semanticsLabel: 'Loading...',
      ),
    ));
  }
}

class MsHtml extends StatelessWidget {
  final double size;
  final double lineHeight;
  final FontWeight fontWeight;
  final Color color;

  const MsHtml({Key? key, required this.data, this.size = 18.0, this.lineHeight = 1.5, this.fontWeight = FontWeight.normal, this.color = Colors.black}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Html(data: data, style: {
      '*': Style(fontSize: FontSize(size), fontWeight: fontWeight, lineHeight: LineHeight(lineHeight)),
      'body': Style(margin: Margins.all(0), color: color),
      'h1, h2, h3, h4, h5, h6': Style(fontWeight: FontWeight.w600),
      'strong': Style(fontWeight: FontWeight.w600),
    });
  }
}

// ignore: must_be_immutable
class MsImage extends StatelessWidget {
  dynamic url;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;

  MsImage({super.key, required this.url, this.width = double.infinity, required this.height, this.color = Colors.black, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    String extension = '';
    if (check(url) && url is String) {
      extension = url.substring(url.length - 3);
    } else {
      url = '';
    }
    return (url != '')
        ? (extension == 'svg')
            ? SvgPicture.network(url, width: width, height: height, colorFilter: ColorFilter.mode(color, BlendMode.srcIn), fit: BoxFit.contain)
            : CachedNetworkImage(
                fadeInDuration: Duration(seconds: 0),
                fadeOutDuration: Duration(seconds: 0),
                imageUrl: url,
                placeholder: (context, url) => Image.asset(
                  'assets/images/image_placeholder.jpg',
                  width: width,
                  height: height,
                  fit: fit,
                ),
                errorWidget: (context, url, error) => Image.asset('assets/images/image_placeholder.jpg', width: width, height: height, fit: fit),
                width: width,
                height: height,
                fit: fit,
              )
        : Image.asset(
            'assets/images/image_placeholder.jpg',
            width: width,
            height: height,
            fit: fit,
          );
  }
}

class MsCustomScrollView extends StatefulWidget {
  const MsCustomScrollView({super.key, required this.child});

  final dynamic child;

  @override
  State<MsCustomScrollView> createState() => _MsCustomScrollViewState();
}

class _MsCustomScrollViewState extends State<MsCustomScrollView> {
  int limit = 10;
  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (!isTop) {
              setState(() {
                offset = offset + limit;
              });
            }
          }
          return true;
        },
        child: CustomScrollView(
          slivers: widget.child,
        ));
  }
}

class MsSpace extends StatelessWidget {
  const MsSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 15.0);
  }
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  dynamic oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MsTitle extends StatelessWidget {
  const MsTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
      ),
    );
  }
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class MsHeading extends StatelessWidget {
  const MsHeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Kateqoriyaları kəşf et', style: TextStyle(color: Color(0xFF252525), fontSize: 18.0, fontWeight: FontWeight.w900)),
        GestureDetector(
          onTap: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [Text('Hamısına bax', style: TextStyle(color: Color(0xFFb1b4bb))), Icon(Icons.chevron_right, size: 17.0, color: Color(0xFFb1b4bb))],
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class MsIconText extends StatelessWidget {
  IconData icon;
  final String text;
  final String type;

  MsIconText({super.key, required this.text, this.icon = Icons.error, this.type = ''});

  @override
  Widget build(BuildContext context) {
    if (type == 'error') {
      icon = Icons.error;
    } else if (type == 'success') {
      icon = Icons.check_circle;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Icon(icon, color: Colors.white, size: 26.0), SizedBox(width: 15.0), Expanded(child: Text(text))],
    );
  }
}

class PageLoader extends StatelessWidget {
  const PageLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Container(color: Colors.white.withOpacity(.5), child: MsIndicator()));
  }
}

class RoundedBody extends StatelessWidget {
  final Widget child;
  final dynamic backgroundColor;
  const RoundedBody({super.key, required this.child, this.backgroundColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Ink(
            decoration: BoxDecoration(
              color: (backgroundColor == false) ? Theme.of(context).colorScheme.backgroundColor : backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: child,
            )));
  }
}

class AlphabetPP extends StatelessWidget {
  final Map data;
  final double size;
  final double fontSize;

  const AlphabetPP({super.key, required this.data, this.size = 56.0, this.fontSize = 18.0});

  @override
  Widget build(BuildContext context) {
    if (check(data)) {
      String first = data['first_name'].substring(0, 1);
      String last = data['last_name'].substring(0, 1);
      return Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: BoxDecoration(color: MsColors.primary, borderRadius: BorderRadius.circular(50.0)),
        child: Text('$first$last'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w600)),
      );
    } else {
      return Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary, size: size);
    }
  }
}

// ignore: must_be_immutable
class AnimatedSwitch extends StatelessWidget {
  final bool data;
  Duration animationDuration = Duration(milliseconds: 150);

  AnimatedSwitch({super.key, this.data = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 26,
        width: 44,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: data ? Theme.of(context).colorScheme.primary : Color(0xff777777),
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: data ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
