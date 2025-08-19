import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';  // Temporarily disabled
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/notification.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/hive_mode/hive_cart_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/global_function.dart';

import 'firebase_options.dart';
import 'utils/notifactionhandler.dart';

void main() async {
  try {
  WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
    }

    // Initialize FlutterDownloader - Temporarily disabled
    // try {
    //   await FlutterDownloader.initialize(
    //       debug: false, // Set to false to avoid potential issues
    //       ignoreSsl: true
    //   );
    //   print('FlutterDownloader initialized successfully');
    // } catch (e) {
    //   print('FlutterDownloader initialization failed: $e');
    //   // Continue without FlutterDownloader if it fails
    // }

    // Initialize notifications
    try {
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  firebaseMessagingForgroundHandler();
  print('FCM TOKEN: ${await FirebaseMessaging.instance.getToken()}');
    } catch (e) {
      print('Notification setup failed: $e');
    }

    // Initialize Hive
    try {
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.appSettingsBox);
  Hive.registerAdapter(HiveCartModelAdapter());
  await Hive.openBox<HiveCartModel>(AppHSC.cartBox);
      print('Hive initialized successfully');
    } catch (e) {
      print('Hive initialization failed: $e');
    }

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    print('Main initialization failed: $e');
    // Fallback app initialization
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Locale resolveLocal({required String langCode}) {
    return Locale(langCode);
  }

  _listenToFirebaseMessaging({required WidgetRef ref}) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      ref.read(notificationProvider.notifier).getNotification(
            itemPerPage: 20,
            pageNumber: 1,
          );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
    _listenToFirebaseMessaging(ref: ref);
    } catch (e) {
      print('Error setting up Firebase messaging: $e');
    }
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return ScreenUtilInit(
      designSize: const Size(360, 800), // XD Design Sizes
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        try {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
          builder: (context, appSettingsBox, _) {
              try {
            final isDark = appSettingsBox.get(AppHSC.isDarkTheme,
                defaultValue: false) as bool;
            final selectedLocal =
                appSettingsBox.get(AppHSC.appLocal) as String?;
            if (selectedLocal == null) {
              appSettingsBox.put(AppHSC.appLocal, 'en');
            }

            return ConnectivityAppWrapper(
              app: MaterialApp(
                navigatorKey: ApGlobalFunctions.navigatorKey,
                scaffoldMessengerKey: ApGlobalFunctions.getSnackbarKey(),
                title: 'AURA',
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FormBuilderLocalizations.delegate,
                ],
                locale: resolveLocal(langCode: selectedLocal ?? 'en'),
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                      try {
                  if (selectedLocal == '') {
                    appSettingsBox.put(
                      AppHSC.appLocal,
                      deviceLocal?.languageCode,
                    );
                  }
                  for (final locale in supportedLocales) {
                    if (locale.languageCode == deviceLocal!.languageCode) {
                      return deviceLocal;
                    }
                  }
                  return supportedLocales.first;
                      } catch (e) {
                        print('Locale resolution error: $e');
                        return supportedLocales.first;
                      }
                },
                supportedLocales: S.delegate.supportedLocales,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: getAppTheme(
                  context: context,
                  isDarkTheme: false,
                ),
                darkTheme: getAppTheme(
                  context: context,
                  isDarkTheme: true,
                ),
                onGenerateRoute: generatedRoutes,
                initialRoute: Routes.splash,
                builder: EasyLoading.init(),
              ),
            );
              } catch (e) {
                print('Error in app settings builder: $e');
                // Fallback to basic app
                return MaterialApp(
                  title: 'AURA',
                  home: const Scaffold(
                    body: Center(
                      child: Text('AURA'),
                    ),
                  ),
                );
              }
          },
        );
        } catch (e) {
          print('Error in ScreenUtilInit builder: $e');
          // Fallback to basic app
          return MaterialApp(
            title: 'AURA',
            home: const Scaffold(
              body: Center(
                child: Text('AURA'),
              ),
            ),
          );
        }
      },
    );
  }
}
