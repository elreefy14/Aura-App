import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/checkout.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/login_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponCard extends ConsumerStatefulWidget {
  const CouponCard({
    super.key,
  });

  @override
  ConsumerState<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends ConsumerState<CouponCard> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController couponController = TextEditingController();
  final _codeIsNull = StateProvider<bool>((ref) {
    return true;
  });

  @override
  void dispose() {
    couponController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool codeIsNull = ref.watch(_codeIsNull);
    return Container(
      padding: EdgeInsets.all(20.h),
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).couponDec,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w600),
          ),
          12.ph,
          Row(
            children: [
              Flexible(
                child: CustomFormWidget(
                  hint: S.of(context).couponFilHint,
                  controller: couponController,
                  focusNode: _focusNode,
                  readOnly: ref.watch(checkoutController).couponValidStatus,
                  prefix: ref.read(checkoutController).couponValidStatus
                      ? Padding(
                          padding: EdgeInsets.all(13.h),
                          child: Container(
                            width: 20.h,
                            height: 20.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppStaticColor.greenColor),
                            child: Center(
                              child: Icon(
                                Icons.done_rounded,
                                color: context.color.surface,
                                size: 16.h,
                              ),
                            ),
                          ),
                        )
                      : null,
                  onChanged: (value) {
                    if (value == '') {
                      makeCouponNull(true);
                    } else {
                      if (codeIsNull) {
                        makeCouponNull(false);
                      }
                    }
                  },
                ),
              ),
              12.pw,
              ref.read(checkoutController).couponValidStatus
                  ? AppButton(
                      title: S.of(context).remove,
                      titleColor: AppStaticColor.redColor.withOpacity(.3),
                      buttonColor: AppStaticColor.redColor.withOpacity(.1),
                      textPaddingVertical: 14.h,
                      onTap: () {
                        ref.read(checkoutController.notifier).removeCoupon();
                        couponController.text = '';
                        makeCouponNull(true);
                      },
                    )
                  : AppButton(
                      title: S.of(context).apply,
                      titleColor: context.color.surface,
                      textPaddingVertical: 14.h,
                      showLoading:
                          ref.watch(checkoutController).applyCouponLoading,
                      onTap: codeIsNull
                          ? null
                          : () {
                              if (ref.read(hiveStorageProvider).isGuest()) {
                                EasyLoading.showInfo(S.of(context).plzLoginDec);
                                ApGlobalFunctions.showBottomSheet(
                                    context: context,
                                    widget: const LoginBottomWidget());
                                return;
                              }
                              ref
                                  .read(checkoutController.notifier)
                                  .couponValidate(code: couponController.text)
                                  .then((value) {
                                if (!value.isSuccess) {
                                  couponController.text = '';
                                  makeCouponNull(true);
                                } else {
                                  _focusNode.unfocus();
                                  couponController.text =
                                      '${couponController.text} ${S.of(context).applied}';
                                }
                              });
                            },
                    )
            ],
          ),
        ],
      ),
    );
  }

  makeCouponNull(bool flag) {
    ref.read(_codeIsNull.notifier).state = flag;
  }
}
