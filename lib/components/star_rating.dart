import 'package:ready_lms/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef RatingChangeCallback = void Function(int rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final double? iconSize;

  // ignore: use_key_in_widget_constructors
  const StarRating(
      {this.starCount = 5,
      this.rating = 0,
      this.onRatingChanged,
      this.color,
      this.iconSize = 16});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_rounded,
        // ignore: deprecated_member_use
        color: colors(context).hintTextColor!.withOpacity(.3),
        size: iconSize!.h,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half_rounded,
        color: color ?? Theme.of(context).primaryColor,
        size: iconSize!.h,
      );
    } else {
      icon = Icon(
        Icons.star_rounded,
        color: color ?? Theme.of(context).primaryColor,
        size: iconSize!.h,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
