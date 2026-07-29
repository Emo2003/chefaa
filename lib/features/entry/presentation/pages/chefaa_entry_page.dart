import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/resources/constants_manager.dart';
import '../../../../core/routes/app_routes_names.dart';
import '../../../../core/services/permissions_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/permissions_request_dialog.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:go_router/go_router.dart';


class ChefaaEntryPage extends StatefulWidget {
  const ChefaaEntryPage({super.key});

  @override
  State<ChefaaEntryPage> createState() => _ChefaaEntryPageState();
}

class _ChefaaEntryPageState extends State<ChefaaEntryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;

    debugPrint('Step 1: checking onboarding');
    final hasSeenOnboarding = await StorageService.hasSeenOnboarding();
    debugPrint('Step 1 done: $hasSeenOnboarding');

    if (!hasSeenOnboarding) {
      if (!mounted) return;
      FlutterNativeSplash.remove();
      context.go(AppRoutesNames.onboardingRoute);
      return;
    }

    debugPrint('Step 2: checking token/user');
    final token = await StorageService.getToken();
    final user = await StorageService.getUser();
    debugPrint('Step 2 done: token=$token user=$user');

    if (token == null || user == null) {
      if (!mounted) return;
      FlutterNativeSplash.remove();
      context.go(AppRoutesNames.login);
      return;
    }

    if (!mounted) return;

    // ⬅️ هنا أهم تعديل: شيل السبلاش قبل ما تعرض ديالوج الصلاحيات
    FlutterNativeSplash.remove();

    debugPrint('Step 3: checking permissions');
    await _requestPermissionsIfNeeded();
    debugPrint('Step 3 done');

    if (!mounted) return;
    final route = AppConstants.getLayoutFromRole(user.role);
    debugPrint('Step 4: navigating to $route');
    context.go(route);
  }
  Future<void> _requestPermissionsIfNeeded() async {
    final allPermissionsGranted =
    await PermissionsService.areCriticalPermissionsGranted();

    if (allPermissionsGranted) {
      return;
    }

    if (!mounted) return;

    final result = await showDialog<Map<String, PermissionStatus>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PermissionsRequestDialog(),
    );

    if (result != null && mounted) {
      debugPrint('Permissions requested: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      ),
    );
  }
}