import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class ActionItemCard extends StatelessWidget {
  final String clinicName;
  final String message;

  const ActionItemCard({
    super.key,
    required this.clinicName,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorManager.error.withAlpha(25),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.error.withAlpha(100)),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p8),
            decoration: BoxDecoration(
              color: ColorManager.error.withAlpha(25),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.priority_high_rounded,
              size: 16.sp,
              color: ColorManager.error,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinicName,
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  message,
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
