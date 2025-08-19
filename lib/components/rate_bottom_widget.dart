import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/components/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateBottomWidget extends StatefulWidget {
  const RateBottomWidget({
    super.key,
    required this.id,
    required this.onReviewed,
  });
  final int id;
  final ValueChanged<SubmittedReview> onReviewed;
  @override
  State<RateBottomWidget> createState() => _RateBottomWidgetState();
}

class _RateBottomWidgetState extends State<RateBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  bool showPass = false;
  final ratting = StateProvider<int>((ref) {
    return 5;
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () => context.nav.pop(),
                                  child: Container(
                                    width: 20.h,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colors(context)
                                            .hintTextColor!
                                            .withOpacity(.7)),
                                    child: Center(
                                        child: Icon(
                                      Icons.close_rounded,
                                      color: context.color.surface,
                                      size: 16.h,
                                    )),
                                  ),
                                )),
                            Center(
                              child: Image.asset(
                                'assets/images/im_rate.png',
                                height: 144.h,
                                width: 144.h,
                              ),
                            )
                          ],
                        ),
                        24.ph,
                        Text(
                          S.of(context).rateQus,
                          style: AppTextStyle(context)
                              .title
                              .copyWith(fontSize: 22.sp),
                        ),
                        12.ph,
                        Consumer(builder: (context, ref, _) {
                          return StarRating(
                            rating: ref.watch(ratting),
                            color: AppStaticColor.orangeColor,
                            iconSize: 28,
                            onRatingChanged: (rating) {
                              ref.read(ratting.notifier).state = rating;
                            },
                          );
                        }),
                        24.ph,
                        Text(
                          S.of(context).rateDec,
                          style: AppTextStyle(context).bodyTextSmall,
                        ),
                        24.ph,
                        CustomFormWidget(
                          // hint: 'Email or Phone',
                          label: S.of(context).comments,
                          controller: commentController,
                          maxLines: 4,
                          validator: (val) => validatorWithMessage(
                              message:
                                  '${S.of(context).comments} ${S.of(context).isRequired}',
                              value: val),
                        ),
                        24.ph,
                        Consumer(builder: (context, ref, _) {
                          return AppButton(
                            title: S.of(context).submit,
                            textPaddingVertical: 16.h,
                            titleColor: context.color.surface,
                            showLoading: ref.watch(othersController),
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                var res = await ref
                                    .read(othersController.notifier)
                                    .makeReview(id: widget.id, data: {
                                  'rating': ref.read(ratting),
                                  'comment': commentController.text
                                });
                                if (res.isSuccess) {
                                  context.nav.pop();
                                  widget.onReviewed(res.response);
                                }
                                EasyLoading.showInfo(res.message);
                              }
                            },
                          );
                        })
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
