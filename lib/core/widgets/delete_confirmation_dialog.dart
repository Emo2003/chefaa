import 'package:flutter/material.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:go_router/go_router.dart';

class DeleteConfirmationDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: ColorManager.lightGray,
        title: Text(
          title,
          style: getBoldStyle(color: ColorManager.primary, fontSize: 22),
        ),
        content: Text(
          message,
          style: getRegularStyle(color: ColorManager.black, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              "Cancel",
              style: getMediumStyle(color: ColorManager.gray, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onConfirm();
            },
            child: Text(
              "Delete",
              style: getMediumStyle(color: ColorManager.error, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
