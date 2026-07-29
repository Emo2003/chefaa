import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 300.w,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 48.h),
              Image.asset("assets/images/oclok.png"),
              SizedBox(height: 32.h),
              Text(
                "Verification in progress",
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s22,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Access to the doctor features will be\n available once the verification is\n completed",
                style: getMediumStyle(color: ColorManager.gray, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.primary, width: 2),
                    color: ColorManager.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Ok',
                    style: getRegularStyle(
                      color: ColorManager.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
