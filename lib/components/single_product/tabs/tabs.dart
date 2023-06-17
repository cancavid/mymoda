import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mymoda/components/single_product/comments/add_comment.dart';
import 'package:mymoda/components/single_product/comments/preview_comments.dart';
import 'package:mymoda/components/single_product/tabs/product_info.dart';

class SingleProductTabs extends StatelessWidget {
  const SingleProductTabs({super.key, required this.data, required this.comments, required this.commentsCount, required this.commentsLoading});

  final Map data;
  final List comments;
  final int commentsCount;
  final bool commentsLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return ProductInfo(data: data);
                });
          },
          leading: SvgPicture.asset('assets/icons/box-open-full.svg', colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
          title: Text('Məhsul haqqında'),
          horizontalTitleGap: 0.0,
        ),
        Divider(color: Color(0xFFEEEEEE), height: 1.0, thickness: 1.0),
        ListTile(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return PreviewComments(comments: comments, count: commentsCount, postId: data['post_id'], loading: commentsLoading);
                });
          },
          leading: SvgPicture.asset('assets/icons/comment.svg', colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
          title: Text('Rəylər'),
          horizontalTitleGap: 0.0,
        ),
        Divider(color: Color(0xFFEEEEEE), height: 1.0, thickness: 1.0),
        ListTile(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return AddCommentPage(postId: data['post_id']);
                });
          },
          leading: SvgPicture.asset('assets/icons/add.svg', colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
          title: Text('Rəy bildir'),
          horizontalTitleGap: 0.0,
        ),
      ],
    );
  }
}
