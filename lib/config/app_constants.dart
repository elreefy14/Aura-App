class AppConstants {
  // API URL
  // Testing
  // static const String baseUrl = 'https://uat.readylms.app/api';

    // Live backend API base URL (no trailing slash)
    static const String baseUrl = 'https://aurafoundation.site/api';

    // dev
    // static const String baseUrl = '';

  static const String register = '$baseUrl/register';
  static const String loginUrl = '$baseUrl/login';
  static const String activateAccount = '$baseUrl/account-activation/activate';
  static const String updatePass = '$baseUrl/update-password';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String validateOtpForResetPass =
      '$baseUrl/reset-password/validate';
  static const String updateUser = '$baseUrl/profile/update';
  static const String categories = '$baseUrl/categories';
  static const String courseList = '$baseUrl/course/list';
  static const String enrolledCourses = '$baseUrl/enrolled_courses';
  static const String courseDetail = '$baseUrl/course/show/';
  static const String purchase = '$baseUrl/enroll/';
  static const String favouriteList = '$baseUrl/favourite/list';
  static const String certificateList = '$baseUrl/certificate/list';
  static const String favouriteUpdate = '$baseUrl/favourite/modify/';
  static const String guestCreate = '$baseUrl/guest/create';
  static const String review = '$baseUrl/review/';
  static const String couponValidate = '$baseUrl/coupon/validate';
  static const String activeAccountRequest =
      '$baseUrl/account-activation/send-code';
  static const String viewContent = '$baseUrl/view_content/';
  static const String contactSupport = '$baseUrl/contact/submit';
  static const String deleteAccount = '$baseUrl/profile/delete';
  static const String master = '$baseUrl/master';
  static const String showCertificate = '$baseUrl/certificate/show/';
  static const String startQuiz = '$baseUrl/quiz/start/';
  static const String submitQuiz = '$baseUrl/quiz/submit/';
  static const String startExam = '$baseUrl/exam/start/';
  static const String submitExam = '$baseUrl/exam/submit/';
  static const String freeEnroll = '$baseUrl/free/enroll/';
  static const String notificiations = '$baseUrl/notifications';
  static const String notificationRead = '$baseUrl/notification-read';
  static const String notificationReadAll = '$baseUrl/notification-mark-all';
  static const String blogList = '$baseUrl/blog/list';
  static const String blogDetail = '$baseUrl/blog/show/';

  static const defaultAvatarImageUrl =
      'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/251940768/original/60fa660ce4c45a23dd122b7deb681a8052672843/a-nice-cartoon-avatar-from-your-real-photo-your-pet-or-any-character-or-animal.jpg';

  // static const String merchantCountryCode = 'USA';
  // static const String currencyCode = 'USD';
  static String currencySymbol = '';
  static const String perPage = 'items_per_page';
  static const String page = 'page_number';
  static String appName = 'AURA';

    // Payment gateways (client-side toggles)
    // Enable to force-show Paymob as a payment option if the backend master API
    // doesn't include it yet. Default is false to avoid UI drift from backend.
    static const bool enablePaymob = false;
    static const String paymobGateway = 'paymob';
    static const String paymobName = 'Paymob';
    // Optional logo to display in the payment methods list when injecting Paymob.
    // You can host your own image and replace this URL.
    static const String paymobLogoUrl =
            'https://upload.wikimedia.org/wikipedia/commons/5/5b/Paymob_logo.png';

    // Apple IAP (iOS) toggles – when enabled and running on iOS, we'll expose
    // an "Apple In‑App Purchase" method in the payment list. Your backend must
    // validate the receipt and enroll the user.
    static const bool enableAppleIAP = true;
    static const String appleIapGateway = 'apple_iap';
    static const String appleIapName = 'Apple In‑App Purchase';
    static const String appleIapLogoUrl =
        'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg';

    // Map course IDs to Apple product IDs (from App Store Connect). Fill this
    // before submitting to the App Store. If a course ID is missing, checkout
    // will fall back to the regular web-based flow.
  // Note: We now auto-generate a default product ID as
  //   <bundleId>.course.<courseId>
  // on iOS if not present here, and cache it for the session.
  static final Map<int, String> appleProductIds = {
      // Example: 101: 'com.aurafoundation.course.101',
    };

  // Optional override to force a prefix when bundleId is unavailable.
  static const String defaultAppleProductPrefix = 'com.aurafoundation';

  // validation
  static const kTextValidatorEmailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // input border
  static const double hintColorBorderOpacity = .2;
}

enum FileSystem { document, audio, image, video, iframe }
