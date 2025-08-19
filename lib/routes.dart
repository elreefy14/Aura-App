import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/auth/auth_home_screen.dart';
import 'package:ready_lms/view/blog/blog_details.dart';
import 'package:ready_lms/view/blog/blogs_screen.dart';
import 'package:ready_lms/view/category/all_category_screen.dart';
import 'package:ready_lms/view/category/search_category_screen.dart';
import 'package:ready_lms/view/certificate/certificate_screen.dart';
import 'package:ready_lms/view/check_out/checkout_screen.dart';
import 'package:ready_lms/view/courses/all_courses/all_course_screen.dart';
import 'package:ready_lms/view/courses/my_course_details/my_course_details.dart';
import 'package:ready_lms/view/courses/new_course/course_new_screen.dart';
import 'package:ready_lms/view/courses/search/search_course_screen.dart';
import 'package:ready_lms/view/dashboard.dart';
import 'package:ready_lms/view/exam/exam_screen.dart';
import 'package:ready_lms/view/notification/notification_screen.dart';
import 'package:ready_lms/view/other/other_secreen.dart';
import 'package:ready_lms/view/other/support_secreen.dart';
import 'package:ready_lms/view/pdf/pdf_screen.dart';
import 'package:ready_lms/view/profile/profile_screen.dart';
import 'package:ready_lms/view/quiz/quiz_screen.dart';
import 'package:ready_lms/view/result_screen/result_screen.dart';
import 'package:ready_lms/view/splash_screen.dart';

class Routes {
  /*We are mapping all th eroutes here
  so that we can call any named route
  without making typing mistake
  */
  Routes._();
  //core
  static const splash = '/';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const signUp = '/signUp';
  static const passwordRecover = '/passwordRecover';
  static const verifyOTPScreen = '/verifyOTPScreen';
  static const changePasswordScreen = '/changePasswordScreen';
  static const dashboard = '/dashboard';
  static const courseNew = '/courseNew';
  static const myCourseDetails = '/myCourseDetails';
  static const authHomeScreen = '/authHomeScreen';
  static const checkOutScreen = '/checkOutScreen';
  static const profileScreen = '/profileScreen';
  static const allCourseScreen = '/allCourseScreen';
  static const allCategoryScreen = '/allCategoryScreen';
  static const courseSearchScreen = '/courseSearchScreen';
  static const categorySearchScreen = '/categorySearchScreen';
  static const otherScreen = '/otherScreen';
  static const pdfScreen = '/PDFScreen';
  static const supportScreen = '/supportScreen';
  static const certificateScreen = '/certificateScreen';
  static const examScreen = '/examScreen';
  static const quizScreen = '/quizScreen';
  static const resultScreen = '/resultScreen';
  static const notificationScreen = '/notificationScreen';
  static const blogsScreen = '/blogsScreen';
  static const blogDetailsScreen = '/blogDetailsScreen';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashScreen();
      break;
    case Routes.authHomeScreen:
      child = const AuthHomeScreen();
      break;
    case Routes.dashboard:
      child = const DashboardScreen(); //change to DashboardScreen
      break;
    case Routes.courseNew:
      var data = settings.arguments as Map<String, dynamic>;
      child = CourseNewScreen(
        courseId: data['courseId'],
        isShowBottomNavigationBar: data['show'] ?? true,
      );
      break;
    case Routes.myCourseDetails:
      int courseID = settings.arguments as int;
      child = MyCourseDetails(
        courseId: courseID,
      );
      break;
    case Routes.checkOutScreen:
      int courseID = settings.arguments as int;
      child = CheckOutScreen(
        courseId: courseID,
      );
      break;
    case Routes.profileScreen:
      child = const ProfileScreen();
      break;
    case Routes.allCourseScreen:
      var data = settings.arguments as Map<String, dynamic>?;

      child = AllCourseScreen(
        categoryModel: data?['model'],
        showMostPopular: data?['popular'] ?? false,
      );
      break;
    case Routes.allCategoryScreen:
      child = const AllCategoryScreen();
      break;
    case Routes.courseSearchScreen:
      child = const CourseSearchScreen();
      break;
    case Routes.pdfScreen:
      var data = settings.arguments as Map<String, dynamic>;
      child = PDFScreen(
        id: data['id'],
        title: data['title'],
      );
      break;
    case Routes.categorySearchScreen:
      child = const CategorySearchScreen();
      break;
    case Routes.examScreen:
      child = ExamScreen(exam: settings.arguments as Exam);
      break;
    case Routes.quizScreen:
      child = QuizScreen(
        quiz: settings.arguments as Quiz,
      );
      break;
    case Routes.resultScreen:
      final argumants = settings.arguments as Map<String, dynamic>;

      child = ResultScreen(
        isQuiz: argumants['isQuize'],
        quiz: argumants['quiz'],
        quizQuestionDetailsModel: argumants['quizDetails'],
        examResultModel: argumants['examResult'],
      );
      break;
    case Routes.supportScreen:
      child = const SupportScreen();
      break;
    case Routes.certificateScreen:
      child = const CertificateScreen();
      break;
    case Routes.otherScreen:
      Map<String, String> data = settings.arguments as Map<String, String>;
      child = OtherScreen(title: data['title']!, body: data['body']!);
      break;
    case Routes.notificationScreen:
      child = const NotificationScreen();
      break;
    case Routes.blogsScreen:
      child = BlogsScreen();
      break;
    case Routes.blogDetailsScreen:
      final int blogId = settings.arguments as int;
      child = BlogDetailsScreen(
        blogId: blogId,
      );
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint('Route: ${settings.name}');

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: 0.miliSec,
    reverseDuration: 0.miliSec,
  );
}
