import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import '../../generated/l10n.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key, required this.title, required this.body});
  final String title, body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title == 'Terms Conditions'
              ? S.of(context).termsConditions
              : S.of(context).privacyPolicy,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.h,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Html(data: body),
        ),
      ),
    );
  }
}
