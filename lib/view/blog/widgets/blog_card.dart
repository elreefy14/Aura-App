import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../config/app_color.dart';
import '../../../config/app_text_style.dart';
import '../../../model/blog/blog_model.dart';

class BlogCardWidget extends StatelessWidget {
  final Blogs blog;
  const BlogCardWidget({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.nav.pushNamed(Routes.blogDetailsScreen, arguments: blog.id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 12.h),
        padding: EdgeInsets.all(8.r),
        height: 266.h,
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: _BlogImageWidget(
                imageUrl: blog.thumbnail,
              ),
            ),
            12.ph,
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: _BlogTextWidget(blog),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogImageWidget extends StatelessWidget {
  final String imageUrl;

  const _BlogImageWidget({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(12.r),
      ),
      child: FadeInImage.assetNetwork(
        placeholderFit: BoxFit.contain,
        placeholder: 'assets/images/spinner.gif',
        image: imageUrl,
        width: MediaQuery.of(context).size.width,
        height: 174.h,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error, color: context.color.primary);
        },
      ),
    );
  }
}

class _BlogTextWidget extends StatelessWidget {
  final Blogs blog;
  const _BlogTextWidget(this.blog);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            blog.title,
            style: AppTextStyle(context).bodyText.copyWith(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          4.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundImage: NetworkImage(blog.user.profilePicture),
                  ),
                  5.pw,
                  SizedBox(
                    width: 130.w,
                    child: Text(
                      blog.user.name,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppStaticColor.grayColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Text(
                  blog.updatedAt,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppStaticColor.grayColor,
                      ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
