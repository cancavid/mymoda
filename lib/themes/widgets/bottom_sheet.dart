import 'package:flutter/material.dart';

class MsBottomSheet extends StatelessWidget {
  const MsBottomSheet({super.key, required this.child, this.height = 0.0, this.static = false});

  final Widget child;
  final double height;
  final bool static;

  @override
  Widget build(BuildContext context) {
    if (static) {
      if (height == 0.0) {
        return bottomSheetContent(context);
      } else {
        return SizedBox(
          height: height,
          child: bottomSheetContent(context),
        );
      }
    } else {
      return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 0.4,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(controller: scrollController, child: bottomSheetContent(context));
          });
    }
  }

  Widget bottomSheetContent(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          top: 7.5,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 7.5,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
