import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/components/offline.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeApp();
    });
  }

  void _initializeApp() async {
    try {
      // Listen for connectivity changes
      ConnectivityWrapper.instance.onStatusChange.listen((event) {
        if (event == ConnectivityStatus.CONNECTED) {
          _loadMasterData();
        }
      });

      // Initial load attempt
      _loadMasterData();
    } catch (e) {
      print('Splash screen initialization error: $e');
      // Fallback to auth screen if everything fails
      _navigateToAuth();
              }
            }

  void _loadMasterData() async {
    try {
      final value = await ref.read(othersController.notifier).getMasterData();
      
        if (value.isSuccess) {
          final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
        var firstOpen = appSettingsBox.get(AppHSC.firstOpen, defaultValue: true);
        
        try {
          if (!ref.read(hiveStorageProvider).isGuest()) {
            final token = ref.read(hiveStorageProvider).getAuthToken();
            if (token != null) {
              ref.read(apiClientProvider).updateToken(token: token);
          }
          }
        } catch (e) {
          print('Token update error: $e');
        }

        _navigateToNextScreen(firstOpen);
        } else {
        print('Master data load failed: ${value.message}');
        // Show error but still navigate to auth screen
          ApGlobalFunctions.showCustomSnackbar(
            message: value.message,
            isSuccess: false,
          );
        _navigateToAuth();
        }
    } catch (e) {
      print('Master data load error: $e');
      _navigateToAuth();
    }
  }

  void _navigateToNextScreen(bool firstOpen) {
    try {
      context.nav.pushNamedAndRemoveUntil(
        firstOpen ? Routes.authHomeScreen : Routes.dashboard,
        (route) => false,
      );
    } catch (e) {
      print('Navigation error: $e');
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    try {
      context.nav.pushNamedAndRemoveUntil(
        Routes.authHomeScreen,
        (route) => false,
      );
    } catch (e) {
      print('Auth navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ref.read(hiveStorageProvider).getTheme()
                  ? 'assets/images/app_name_logo_dark.png'
                  : 'assets/images/app_name_logo_light.png',
              width: 150.h,
              height: 80.h,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
