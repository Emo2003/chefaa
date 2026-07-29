import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.color = ColorManager.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p12,
        horizontal: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5.h,
        children: [
          Text(
            value,
            style: getBoldStyle(color: color, fontSize: 14.sp),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              color: ColorManager.gray,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
