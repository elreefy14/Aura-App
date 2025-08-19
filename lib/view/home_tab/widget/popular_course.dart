import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:flutter/material.dart';

class PopularCourses extends StatelessWidget {
  const PopularCourses({
    super.key,
    required this.courseList,
  });
  final List<CourseListModel> courseList;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          16.pw,
          ...List.generate(
            courseList.length,
            (index) => CourseCard(
              model: courseList[index],
              marginRight: 15,
              maxLineOfTitle: 1,
              onTap: () {
                if (courseList[index].isEnrolled) {
                  context.nav.pushNamed(Routes.myCourseDetails,
                      arguments: courseList[index].id);
                } else {
                  context.nav.pushNamed(Routes.courseNew,
                      arguments: {'courseId': courseList[index].id});
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
