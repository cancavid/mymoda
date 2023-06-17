import 'package:flutter/material.dart';
import 'package:mymoda/themes/functions.dart';
import 'package:mymoda/themes/widgets/rating.dart';

class SingleComment extends StatelessWidget {
  const SingleComment({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data['comment_author'],
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
                  ),
                  SizedBox(height: 5.0),
                  MsRating(value: double.parse(data['comment_rating']))
                ]),
            Text(humanDate(data['comment_date']),
                style: TextStyle(color: Colors.grey, fontSize: 13.0))
          ],
        ),
        SizedBox(height: 10.0),
        Text(data['comment_content'])
      ],
    );
  }
}
