import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/components/single_product/comments/single_comment.dart';
import 'package:mymoda/pages/shop/comments.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:mymoda/themes/widgets/headings.dart';

class PreviewComments extends StatelessWidget {
  const PreviewComments({super.key, required this.comments, required this.count, required this.postId, required this.loading});

  final List comments;
  final int count;
  final String postId;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            MsMediumHeading(title: 'Rəylər'),
            SizedBox(height: 30.0),
            if (loading == true) ...[
              MsIndicator()
            ] else if (count == 0) ...[
              Text('Bu məhsul üzrə heç kim rəy bildirməyib.')
            ] else ...[
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 30.0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (BuildContext contexts, int index) {
                  return SingleComment(data: comments[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 30.0);
                },
              ),
            ],
            if (count > 3) ...[
              MsButton(
                  onTap: () {
                    Get.to(() => CommentsPage(postId: postId));
                  },
                  title: 'Bütün rəylərə bax ($count)',
                  icon: true)
            ]
          ],
        ),
      ),
    );
  }
}
