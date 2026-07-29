import 'package:flutter/material.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:go_router/go_router.dart';

class Loading {
  static bool _isLoading = false;

  static Future<void> show(BuildContext context) async {
    _isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              title: Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            ),
          );
        },
      );
    });
  }

  static void hide(BuildContext context) {
    if (_isLoading && context.mounted) {
      context.pop();
      _isLoading = false;
    }
  }

  static void reset() {
    _isLoading = false;
  }
}
