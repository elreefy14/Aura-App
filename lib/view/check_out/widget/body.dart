import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/check_out/widget/coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/view/check_out/widget/course_Info.dart';
import 'package:ready_lms/view/check_out/widget/order_summary_card.dart';
import 'package:ready_lms/view/check_out/widget/payment_scection.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          12.ph,
          const CourseInfo(),
          8.ph,
          const OrderSummaryCard(),
          8.ph,
          const CouponCard(),
          8.ph,
          const PaymentSection(),
          8.ph,
        ],
      ),
    );
  }
}
