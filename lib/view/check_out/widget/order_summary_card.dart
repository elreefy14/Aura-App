import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/checkout.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class OrderSummaryCard extends ConsumerWidget {
  const OrderSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    print("total price");
    print("total price ${ref.watch(checkoutController).totalPrice})");
    return Container(
      padding: EdgeInsets.all(20.h),
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderSummary,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w600),
          ),
          12.ph,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
            decoration: BoxDecoration(
                color: colors(context).scaffoldBackgroundColor,
                borderRadius: AppComponents.defaultBorderRadiusSmall),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).coursePrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppConstants.currencySymbol}${ref.watch(checkoutController).courseDetails?.course.regularPrice}',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                  ],
                ),
                if (ref.watch(checkoutController).discountAmount != 0) 24.ph,
                if (ref.watch(checkoutController).discountAmount != 0)
                  Row(
                    children: [
                      Text(
                        '${S.of(context).discount} (${ref.watch(checkoutController).discountPresent.toStringAsFixed(2)}%)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: AppStaticColor.redColor,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '-${AppConstants.currencySymbol}${ref.watch(checkoutController).discountAmount.toStringAsFixed(2)}',
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: AppStaticColor.redColor,
                            ),
                      ),
                    ],
                  ),
                if (ref.watch(checkoutController).couponAmount != 0) 24.ph,
                if (ref.watch(checkoutController).couponAmount != 0)
                  Row(
                    children: [
                      Text(
                        '${S.of(context).coupon} ${S.of(context).discount} ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: AppStaticColor.redColor,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '-${AppConstants.currencySymbol}${ref.watch(checkoutController).couponAmount}',
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: AppStaticColor.redColor,
                            ),
                      ),
                    ],
                  ),
                12.ph,
                Divider(
                  color: colors(context).hintTextColor!.withOpacity(.3),
                ),
                12.ph,
                Row(
                  children: [
                    Text(
                      S.of(context).subTotal,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppConstants.currencySymbol}${ref.watch(checkoutController).totalPrice - ref.watch(checkoutController).couponAmount}',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
