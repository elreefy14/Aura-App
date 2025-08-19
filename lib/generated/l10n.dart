// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in`
  String get login {
    return Intl.message(
      'Log in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone`
  String get emailOrPhone {
    return Intl.message(
      'Email or Phone',
      name: 'emailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Your Password`
  String get yourPassword {
    return Intl.message(
      'Your Password',
      name: 'yourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgetPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `field cannot be empty`
  String get validationMessage {
    return Intl.message(
      'field cannot be empty',
      name: 'validationMessage',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enroll Now`
  String get enrolNow {
    return Intl.message(
      'Enroll Now',
      name: 'enrolNow',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message(
      'Hi',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Proceed Next`
  String get proceedNext {
    return Intl.message(
      'Proceed Next',
      name: 'proceedNext',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get cContinue {
    return Intl.message(
      'Continue',
      name: 'cContinue',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Skills Anytime, Anywhere with`
  String get authHomeDes {
    return Intl.message(
      'Unlock Skills Anytime, Anywhere with',
      name: 'authHomeDes',
      desc: '',
      args: [],
    );
  }

  /// `Get Started As Guest`
  String get getStarted {
    return Intl.message(
      'Get Started As Guest',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Login with Password`
  String get loginWithPassword {
    return Intl.message(
      'Login with Password',
      name: 'loginWithPassword',
      desc: '',
      args: [],
    );
  }

  /// `Boost you skill always and forever.`
  String get loginHeaderText {
    return Intl.message(
      'Boost you skill always and forever.',
      name: 'loginHeaderText',
      desc: '',
      args: [],
    );
  }

  /// `is required`
  String get isRequired {
    return Intl.message(
      'is required',
      name: 'isRequired',
      desc: '',
      args: [],
    );
  }

  /// `Your passwords do not match.`
  String get passNotMatch {
    return Intl.message(
      'Your passwords do not match.',
      name: 'passNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Rated`
  String get rated {
    return Intl.message(
      'Rated',
      name: 'rated',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Learner`
  String get learner {
    return Intl.message(
      'Learner',
      name: 'learner',
      desc: '',
      args: [],
    );
  }

  /// `Please Login`
  String get pleaseLogin {
    return Intl.message(
      'Please Login',
      name: 'pleaseLogin',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get certificates {
    return Intl.message(
      'Certificates',
      name: 'certificates',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us `
  String get support {
    return Intl.message(
      'Contact Us ',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `FAQs`
  String get faq {
    return Intl.message(
      'FAQs',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Supports & Legals`
  String get supportsLegals {
    return Intl.message(
      'Supports & Legals',
      name: 'supportsLegals',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get favourites {
    return Intl.message(
      'Favourites',
      name: 'favourites',
      desc: '',
      args: [],
    );
  }

  /// `Discover Your Perfect Learning Path.`
  String get welcomeText {
    return Intl.message(
      'Discover Your Perfect Learning Path.',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get course {
    return Intl.message(
      'Courses',
      name: 'course',
      desc: '',
      args: [],
    );
  }

  /// `Most Popular Courses`
  String get mostPopularCourse {
    return Intl.message(
      'Most Popular Courses',
      name: 'mostPopularCourse',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `All Courses`
  String get allCourse {
    return Intl.message(
      'All Courses',
      name: 'allCourse',
      desc: '',
      args: [],
    );
  }

  /// `View All Courses`
  String get viewAllCourses {
    return Intl.message(
      'View All Courses',
      name: 'viewAllCourses',
      desc: '',
      args: [],
    );
  }

  /// `Course Details`
  String get courseDetails {
    return Intl.message(
      'Course Details',
      name: 'courseDetails',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: '',
      args: [],
    );
  }

  /// `See More ...`
  String get seeMore {
    return Intl.message(
      'See More ...',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `See Less`
  String get seeLess {
    return Intl.message(
      'See Less',
      name: 'seeLess',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Course Instructor`
  String get courseInstructor {
    return Intl.message(
      'Course Instructor',
      name: 'courseInstructor',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get myCourses {
    return Intl.message(
      'My Courses',
      name: 'myCourses',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get myCoursesTab {
    return Intl.message(
      'My Courses',
      name: 'myCoursesTab',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get cClass {
    return Intl.message(
      'Class',
      name: 'cClass',
      desc: '',
      args: [],
    );
  }

  /// `You haven't’y rated yet`
  String get notRating {
    return Intl.message(
      'You haven\'t’y rated yet',
      name: 'notRating',
      desc: '',
      args: [],
    );
  }

  /// `Rate Now`
  String get rateNow {
    return Intl.message(
      'Rate Now',
      name: 'rateNow',
      desc: '',
      args: [],
    );
  }

  /// `You have already`
  String get youHaveAlready {
    return Intl.message(
      'You have already',
      name: 'youHaveAlready',
      desc: '',
      args: [],
    );
  }

  /// `rated this course.`
  String get ratedThisCourse {
    return Intl.message(
      'rated this course.',
      name: 'ratedThisCourse',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get minute {
    return Intl.message(
      'min',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Lifetime Access`
  String get lifetimeAccess {
    return Intl.message(
      'Lifetime Access',
      name: 'lifetimeAccess',
      desc: '',
      args: [],
    );
  }

  /// `Audio Book`
  String get audioBook {
    return Intl.message(
      'Audio Book',
      name: 'audioBook',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Back to course for show details.`
  String get backToCourseDec {
    return Intl.message(
      'Back to course for show details.',
      name: 'backToCourseDec',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Please Login First`
  String get plzLoginDec {
    return Intl.message(
      'Please Login First',
      name: 'plzLoginDec',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get purpose {
    return Intl.message(
      'Purpose',
      name: 'purpose',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Write Message`
  String get writeMessage {
    return Intl.message(
      'Write Message',
      name: 'writeMessage',
      desc: '',
      args: [],
    );
  }

  /// `or call us`
  String get orCallUs {
    return Intl.message(
      'or call us',
      name: 'orCallUs',
      desc: '',
      args: [],
    );
  }

  /// `File Info`
  String get fileInfo {
    return Intl.message(
      'File Info',
      name: 'fileInfo',
      desc: '',
      args: [],
    );
  }

  /// `For show the file details you have to download.`
  String get fileDes {
    return Intl.message(
      'For show the file details you have to download.',
      name: 'fileDes',
      desc: '',
      args: [],
    );
  }

  /// `Save Password`
  String get savePassword {
    return Intl.message(
      'Save Password',
      name: 'savePassword',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Course Price`
  String get coursePrice {
    return Intl.message(
      'Course Price',
      name: 'coursePrice',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message(
      'Coupon',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `Have any Coupon?`
  String get couponDec {
    return Intl.message(
      'Have any Coupon?',
      name: 'couponDec',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code`
  String get couponFilHint {
    return Intl.message(
      'Enter the code',
      name: 'couponFilHint',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message(
      'Pay Now',
      name: 'payNow',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful`
  String get paymentSuccessful {
    return Intl.message(
      'Payment Successful',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `You have accessed your desired course. Now you can boost your Skills Anytime, Anywhere with`
  String get paymentDes {
    return Intl.message(
      'You have accessed your desired course. Now you can boost your Skills Anytime, Anywhere with',
      name: 'paymentDes',
      desc: '',
      args: [],
    );
  }

  /// `Start Learning`
  String get startLearning {
    return Intl.message(
      'Start Learning',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `How was the course?`
  String get rateQus {
    return Intl.message(
      'How was the course?',
      name: 'rateQus',
      desc: '',
      args: [],
    );
  }

  /// `Write about what you have learned from this course and inspire others.`
  String get rateDec {
    return Intl.message(
      'Write about what you have learned from this course and inspire others.',
      name: 'rateDec',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `View Course`
  String get viewCourse {
    return Intl.message(
      'View Course',
      name: 'viewCourse',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled`
  String get enrolled {
    return Intl.message(
      'Enrolled',
      name: 'enrolled',
      desc: '',
      args: [],
    );
  }

  /// `Load More`
  String get loadMore {
    return Intl.message(
      'Load More',
      name: 'loadMore',
      desc: '',
      args: [],
    );
  }

  /// `Need Help?`
  String get needHelp {
    return Intl.message(
      'Need Help?',
      name: 'needHelp',
      desc: '',
      args: [],
    );
  }

  /// `Contact Our Support Team Today!`
  String get supportDes {
    return Intl.message(
      'Contact Our Support Team Today!',
      name: 'supportDes',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get createNewPass {
    return Intl.message(
      'New Password',
      name: 'createNewPass',
      desc: '',
      args: [],
    );
  }

  /// `Create a new and strong password that you can remember`
  String get newPassDes {
    return Intl.message(
      'Create a new and strong password that you can remember',
      name: 'newPassDes',
      desc: '',
      args: [],
    );
  }

  /// `OTP will send within`
  String get resend {
    return Intl.message(
      'OTP will send within',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Your order ID is`
  String get yourOrderID {
    return Intl.message(
      'Your order ID is',
      name: 'yourOrderID',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPass {
    return Intl.message(
      'Current Password',
      name: 'currentPass',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Certificate of`
  String get certificateOf {
    return Intl.message(
      'Certificate of',
      name: 'certificateOf',
      desc: '',
      args: [],
    );
  }

  /// `Your course has been completed and your certificate is now ready.`
  String get unlockCertificate {
    return Intl.message(
      'Your course has been completed and your certificate is now ready.',
      name: 'unlockCertificate',
      desc: '',
      args: [],
    );
  }

  /// `The certificate will be unlocked when your course has been finished.`
  String get lockCertificate {
    return Intl.message(
      'The certificate will be unlocked when your course has been finished.',
      name: 'lockCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to Download`
  String get tapToDownload {
    return Intl.message(
      'Tap here to Download',
      name: 'tapToDownload',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Upload From Gallery`
  String get uploadFromGallery {
    return Intl.message(
      'Upload From Gallery',
      name: 'uploadFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message(
      'Take Photo',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get cDefault {
    return Intl.message(
      'Default',
      name: 'cDefault',
      desc: '',
      args: [],
    );
  }

  /// `High to Low`
  String get hToL {
    return Intl.message(
      'High to Low',
      name: 'hToL',
      desc: '',
      args: [],
    );
  }

  /// `Low to High`
  String get lToH {
    return Intl.message(
      'Low to High',
      name: 'lToH',
      desc: '',
      args: [],
    );
  }

  /// `New First`
  String get newFirst {
    return Intl.message(
      'New First',
      name: 'newFirst',
      desc: '',
      args: [],
    );
  }

  /// `Popular First`
  String get popularFirst {
    return Intl.message(
      'Popular First',
      name: 'popularFirst',
      desc: '',
      args: [],
    );
  }

  /// `Long Duration First`
  String get longDurationFirst {
    return Intl.message(
      'Long Duration First',
      name: 'longDurationFirst',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `just now`
  String get justNow {
    return Intl.message(
      'just now',
      name: 'justNow',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `ago`
  String get ago {
    return Intl.message(
      'ago',
      name: 'ago',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get week {
    return Intl.message(
      'week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `weeks`
  String get weeks {
    return Intl.message(
      'weeks',
      name: 'weeks',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete your account?`
  String get deleteConfirmation {
    return Intl.message(
      'Are you sure want to delete your account?',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `For get your courses please login.`
  String get loginForGetCourse {
    return Intl.message(
      'For get your courses please login.',
      name: 'loginForGetCourse',
      desc: '',
      args: [],
    );
  }

  /// `The id or the password doesn't match. please try again.`
  String get loginFailDes {
    return Intl.message(
      'The id or the password doesn\'t match. please try again.',
      name: 'loginFailDes',
      desc: '',
      args: [],
    );
  }

  /// `Please enroll to see the lesson details`
  String get enrolDes {
    return Intl.message(
      'Please enroll to see the lesson details',
      name: 'enrolDes',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Choose your payment method`
  String get paymentMethodDec {
    return Intl.message(
      'Choose your payment method',
      name: 'paymentMethodDec',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get allReadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'allReadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Recommended for you`
  String get recommendedProduct {
    return Intl.message(
      ' Recommended for you',
      name: 'recommendedProduct',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `No Product Found!`
  String get noProductFound {
    return Intl.message(
      'No Product Found!',
      name: 'noProductFound',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get someThingWrong {
    return Intl.message(
      'Something went wrong!',
      name: 'someThingWrong',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get allCategories {
    return Intl.message(
      'All Categories',
      name: 'allCategories',
      desc: '',
      args: [],
    );
  }

  /// `No category found!`
  String get noCategoriesFound {
    return Intl.message(
      'No category found!',
      name: 'noCategoriesFound',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Manage Address`
  String get manageAddress {
    return Intl.message(
      'Manage Address',
      name: 'manageAddress',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Condition`
  String get termsConditions {
    return Intl.message(
      'Terms & Condition',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Profile is updated successful`
  String get profileUS {
    return Intl.message(
      'Profile is updated successful',
      name: 'profileUS',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Postal Code`
  String get postalCode {
    return Intl.message(
      'Postal Code',
      name: 'postalCode',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Make it default address`
  String get makeDefault {
    return Intl.message(
      'Make it default address',
      name: 'makeDefault',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterName {
    return Intl.message(
      'Enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterPhone {
    return Intl.message(
      'Enter your phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get orderId {
    return Intl.message(
      'Order ID',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status`
  String get paymentStatus {
    return Intl.message(
      'Payment Status',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subTotal {
    return Intl.message(
      'Subtotal',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Payable Amount`
  String get payableAmount {
    return Intl.message(
      'Payable Amount',
      name: 'payableAmount',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Enter promo code`
  String get enterPromoCode {
    return Intl.message(
      'Enter promo code',
      name: 'enterPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Applied`
  String get applied {
    return Intl.message(
      'Applied',
      name: 'applied',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkOut {
    return Intl.message(
      'Checkout',
      name: 'checkOut',
      desc: '',
      args: [],
    );
  }

  /// `Your Cart is Empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your Cart is Empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Go To Home`
  String get goToHome {
    return Intl.message(
      'Go To Home',
      name: 'goToHome',
      desc: '',
      args: [],
    );
  }

  /// `Credit Or Debit Card`
  String get card {
    return Intl.message(
      'Credit Or Debit Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Please select the payment method!`
  String get selectPaymentMethod {
    return Intl.message(
      'Please select the payment method!',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Whoops!!`
  String get whoops {
    return Intl.message(
      'Whoops!!',
      name: 'whoops',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Recover Password`
  String get recoverPassword {
    return Intl.message(
      'Recover Password',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `We will send you a  OTP code to recover your password`
  String get passRecoverDes {
    return Intl.message(
      'We will send you a  OTP code to recover your password',
      name: 'passRecoverDes',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message(
      'Send OTP',
      name: 'sendOtp',
      desc: '',
      args: [],
    );
  }

  /// ` Enter Code`
  String get enterOTP {
    return Intl.message(
      ' Enter Code',
      name: 'enterOTP',
      desc: '',
      args: [],
    );
  }

  /// `We sent an OTP code on `
  String get verifyOTPDes {
    return Intl.message(
      'We sent an OTP code on ',
      name: 'verifyOTPDes',
      desc: '',
      args: [],
    );
  }

  /// `Confirm OTP`
  String get confirmOTP {
    return Intl.message(
      'Confirm OTP',
      name: 'confirmOTP',
      desc: '',
      args: [],
    );
  }

  /// `sec`
  String get sec {
    return Intl.message(
      'sec',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect pin code`
  String get incorrectPin {
    return Intl.message(
      'Incorrect pin code',
      name: 'incorrectPin',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `No Internet connection was found. Check your connection or try again.`
  String get noInternetDes {
    return Intl.message(
      'No Internet connection was found. Check your connection or try again.',
      name: 'noInternetDes',
      desc: '',
      args: [],
    );
  }

  /// `Check Internet Connection`
  String get checkInternetConnection {
    return Intl.message(
      'Check Internet Connection',
      name: 'checkInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Password`
  String get createPassword {
    return Intl.message(
      'Create Password',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min {
    return Intl.message(
      'min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to change`
  String get nothingtochange {
    return Intl.message(
      'Nothing to change',
      name: 'nothingtochange',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get hour {
    return Intl.message(
      'hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `I accept and agree to the`
  String get accept {
    return Intl.message(
      'I accept and agree to the',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get terms {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Exam`
  String get startYourExam {
    return Intl.message(
      'Start Your Exam',
      name: 'startYourExam',
      desc: '',
      args: [],
    );
  }

  /// `Start Exam`
  String get startExam {
    return Intl.message(
      'Start Exam',
      name: 'startExam',
      desc: '',
      args: [],
    );
  }

  /// `Number of Questions`
  String get numberofQuestions {
    return Intl.message(
      'Number of Questions',
      name: 'numberofQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Question type`
  String get questiontype {
    return Intl.message(
      'Question type',
      name: 'questiontype',
      desc: '',
      args: [],
    );
  }

  /// `Total Mark`
  String get totalMark {
    return Intl.message(
      'Total Mark',
      name: 'totalMark',
      desc: '',
      args: [],
    );
  }

  /// `Exam duration`
  String get examDuration {
    return Intl.message(
      'Exam duration',
      name: 'examDuration',
      desc: '',
      args: [],
    );
  }

  /// `Instructions:`
  String get instructions {
    return Intl.message(
      'Instructions:',
      name: 'instructions',
      desc: '',
      args: [],
    );
  }

  /// `Ensure you have a stable internet connection.`
  String get ensureyouhavestableinternetconnection {
    return Intl.message(
      'Ensure you have a stable internet connection.',
      name: 'ensureyouhavestableinternetconnection',
      desc: '',
      args: [],
    );
  }

  /// `Carefully read each question before submiting your answer`
  String get carefullyreadeachquestionbeforesubmitingyouranswer {
    return Intl.message(
      'Carefully read each question before submiting your answer',
      name: 'carefullyreadeachquestionbeforesubmitingyouranswer',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Quiz`
  String get startYourQuiz {
    return Intl.message(
      'Start Your Quiz',
      name: 'startYourQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Start Quize`
  String get startQuize {
    return Intl.message(
      'Start Quize',
      name: 'startQuize',
      desc: '',
      args: [],
    );
  }

  /// `Per Question`
  String get perQuestion {
    return Intl.message(
      'Per Question',
      name: 'perQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Please Reiew Your Answers`
  String get pleaseReiewYourAnswers {
    return Intl.message(
      'Please Reiew Your Answers',
      name: 'pleaseReiewYourAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Once confident, tap and hold 'Submit' button bellow.`
  String get onceconfidenttapandoldSubmitbuttonbellow {
    return Intl.message(
      'Once confident, tap and hold \'Submit\' button bellow.',
      name: 'onceconfidenttapandoldSubmitbuttonbellow',
      desc: '',
      args: [],
    );
  }

  /// `Answered Questions`
  String get answeredQuestions {
    return Intl.message(
      'Answered Questions',
      name: 'answeredQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Missed`
  String get Missed {
    return Intl.message(
      'Missed',
      name: 'Missed',
      desc: '',
      args: [],
    );
  }

  /// `time Left`
  String get timeLeft {
    return Intl.message(
      'time Left',
      name: 'timeLeft',
      desc: '',
      args: [],
    );
  }

  /// `Quize`
  String get quize {
    return Intl.message(
      'Quize',
      name: 'quize',
      desc: '',
      args: [],
    );
  }

  /// `Exam`
  String get exam {
    return Intl.message(
      'Exam',
      name: 'exam',
      desc: '',
      args: [],
    );
  }

  /// `Your course has been enrolled successfully`
  String get coourseEnrolledSuccess {
    return Intl.message(
      'Your course has been enrolled successfully',
      name: 'coourseEnrolledSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Has to be a valid email address.`
  String get validation {
    return Intl.message(
      'Has to be a valid email address.',
      name: 'validation',
      desc: '',
      args: [],
    );
  }

  /// `Result of Your Exam`
  String get resultofYourExam {
    return Intl.message(
      'Result of Your Exam',
      name: 'resultofYourExam',
      desc: '',
      args: [],
    );
  }

  /// `Back to Class`
  String get backtoClass {
    return Intl.message(
      'Back to Class',
      name: 'backtoClass',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Failed!`
  String get failed {
    return Intl.message(
      'Failed!',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `You have received a mark of`
  String get youhavereceivedmarkof {
    return Intl.message(
      'You have received a mark of',
      name: 'youhavereceivedmarkof',
      desc: '',
      args: [],
    );
  }

  /// `out of`
  String get outof {
    return Intl.message(
      'out of',
      name: 'outof',
      desc: '',
      args: [],
    );
  }

  /// `File download successfully`
  String get filedownloadsuccessfully {
    return Intl.message(
      'File download successfully',
      name: 'filedownloadsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error downloading file`
  String get errordownloadingfile {
    return Intl.message(
      'Error downloading file',
      name: 'errordownloadingfile',
      desc: '',
      args: [],
    );
  }

  /// `downloader_send_port`
  String get downloadersendport {
    return Intl.message(
      'downloader_send_port',
      name: 'downloadersendport',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markallasread {
    return Intl.message(
      'Mark all as read',
      name: 'markallasread',
      desc: '',
      args: [],
    );
  }

  /// `Before submitting, review your answersto make any final changes and ensure you've answered every question to the best of your ability.`
  String get custom {
    return Intl.message(
      'Before submitting, review your answersto make any final changes and ensure you\'ve answered every question to the best of your ability.',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `No Notification`
  String get noNotification {
    return Intl.message(
      'No Notification',
      name: 'noNotification',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message(
      'Blogs',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Search Blog`
  String get searchBlog {
    return Intl.message(
      'Search Blog',
      name: 'searchBlog',
      desc: '',
      args: [],
    );
  }

  /// `Blog Details`
  String get blogDetails {
    return Intl.message(
      'Blog Details',
      name: 'blogDetails',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `No blog found!`
  String get noBlog {
    return Intl.message(
      'No blog found!',
      name: 'noBlog',
      desc: '',
      args: [],
    );
  }

  /// `Results of your quiz`
  String get resultofYourQuiz {
    return Intl.message(
      'Results of your quiz',
      name: 'resultofYourQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Search Category`
  String get searchCategory {
    return Intl.message(
      'Search Category',
      name: 'searchCategory',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
