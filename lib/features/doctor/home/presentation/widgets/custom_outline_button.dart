import 'package:flutter/material.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final bool isAdd;
  final VoidCallback onPressed;

  const CustomOutlineButton({
    super.key,
    this.isAdd = true,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p10,
          vertical: AppPadding.p8,
        ),
        side: const BorderSide(color: ColorManager.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () {
        onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isAdd
              ? const Icon(Icons.add, color: ColorManager.primary, size: 23)
              : const SizedBox.shrink(),
          Text(
            text,
            style: getMediumStyle(color: ColorManager.primary, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
