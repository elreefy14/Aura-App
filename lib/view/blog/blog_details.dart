import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_color.dart';
import '../../controllers/blog/blog_controller.dart';

class BlogDetailsScreen extends ConsumerWidget {
  final int blogId;
  const BlogDetailsScreen({super.key, required this.blogId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final blogDetailsState = ref.watch(blogDetailsControllerProvider(blogId));
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).blogDetails),
      ),
      body: blogDetailsState.when(
        data: (blogDetails) => Container(
          margin: EdgeInsets.only(top: 8.h),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          width: double.infinity,
          color: context.color.surface,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 174.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholderFit: BoxFit.contain,
                      placeholder: 'assets/images/spinner.gif',
                      image: blogDetails.data.blog.thumbnail,
                      width: MediaQuery.of(context).size.width,
                      height: 174.h,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: context.color.primary);
                      },
                    ),
                  ),
                ),
                16.ph,
                Text(
                  blogDetails.data.blog.title,
                  style: AppTextStyle(context).subTitle,
                ),
                4.ph,
                Text(
                  blogDetails.data.blog.updatedAt,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppStaticColor.grayColor,
                        fontSize: 10.sp,
                      ),
                ),
                8.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14.r,
                          backgroundImage: NetworkImage(
                              blogDetails.data.blog.user.profilePicture),
                        ),
                        5.pw,
                        SizedBox(
                          width: 130.w,
                          child: Text(
                            blogDetails.data.blog.user.name,
                            style: AppTextStyle(context).bodyTextSmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Share.share(
                        blogDetails.data.shareableUrl,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECF2FF),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).share,
                              style:
                                  AppTextStyle(context).bodyTextSmall.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                            ),
                            5.pw,
                            Image.asset(
                              'assets/images/share.png',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                12.ph,
                Divider(
                  height: 0.h,
                  thickness: 2,
                  color: isDark
                      ? const Color(0xFF1C1C1E)
                      : const Color(0xFFF3F4F6),
                ),
                16.ph,
                HtmlWidget(
                  blogDetails.data.blog.description,
                )
              ],
            ),
          ),
        ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
