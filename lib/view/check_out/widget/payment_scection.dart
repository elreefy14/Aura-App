import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/checkout.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class PaymentSection extends ConsumerWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: EdgeInsets.all(20.h),
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).paymentMethodDec,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w600),
          ),
          12.ph,
          ...List.generate(
              ref
                  .read(othersController.notifier)
                  .masterModel!
                  .paymentMethods
                  .length,
              (index) => GestureDetector(
                    onTap: () {
                      ref.read(checkoutController.notifier).setPaymentMethod(ref
                          .read(othersController.notifier)
                          .masterModel!
                          .paymentMethods[index]
                          .gateway);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.h, bottom: 8.h),
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ref
                                          .read(othersController.notifier)
                                          .masterModel!
                                          .paymentMethods[index]
                                          .gateway ==
                                      ref
                                          .watch(checkoutController)
                                          .paymentMethod
                                  ? colors(context).primaryColor!
                                  : colors(context).borderColor!),
                          borderRadius: AppComponents.defaultBorderRadiusMini,
                          color: context.color.surface),
                      child: Row(
                        children: [
                          10.pw,
                          Radio<String>(
                            value: ref
                                .read(othersController.notifier)
                                .masterModel!
                                .paymentMethods[index]
                                .gateway,
                            groupValue:
                                ref.watch(checkoutController).paymentMethod,
                            onChanged: (v) {
                              ref
                                  .read(checkoutController.notifier)
                                  .setPaymentMethod(ref
                                      .read(othersController.notifier)
                                      .masterModel!
                                      .paymentMethods[index]
                                      .gateway);
                            },
                            fillColor:
                                WidgetStateProperty.resolveWith((states) {
                              // active
                              if (states.contains(WidgetState.selected)) {
                                return context.color.primary;
                              }
                              // inactive
                              return colors(context).hintTextColor!.withOpacity(
                                  AppConstants.hintColorBorderOpacity);
                            }),
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          10.pw,
                          Text(
                              ref
                                  .read(othersController.notifier)
                                  .masterModel!
                                  .paymentMethods[index]
                                  .gateway,
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          ref
                                  .read(othersController.notifier)
                                  .masterModel!
                                  .paymentMethods[index]
                                  .logo
                                  .contains('.svg')
                              ? ClipRRect(
                                  borderRadius:
                                      AppComponents.defaultBorderRadiusMini,
                                  child: SvgPicture.network(
                                    ref
                                        .read(othersController.notifier)
                                        .masterModel!
                                        .paymentMethods[index]
                                        .logo,
                                    placeholderBuilder: (BuildContext context) {
                                      return Image.asset(
                                        'assets/images/spinner.gif',
                                        fit: BoxFit.contain,
                                      );
                                    },
                                    width: 60.h,
                                    height: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      AppComponents.defaultBorderRadiusMini,
                                  child: FadeInImage.assetNetwork(
                                    placeholderFit: BoxFit.contain,
                                    placeholder: 'assets/images/spinner.gif',
                                    image: ref
                                        .read(othersController.notifier)
                                        .masterModel!
                                        .paymentMethods[index]
                                        .logo,
                                    width: 60.h,
                                    height: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          10.pw
                        ],
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
