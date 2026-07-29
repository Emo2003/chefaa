import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class DayTimeContainer extends StatelessWidget {
  final String title;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const DayTimeContainer({
    super.key,
    required this.title,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p12,
        ),

        decoration: BoxDecoration(
          color: ColorManager.gray.withAlpha(35),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: ColorManager.lightGray),
        ),

        child: Center(
          child: Text(
            time != null ? time!.format(context) : title,
            style: getBoldStyle(color: ColorManager.gray, fontSize: 15.sp),
          ),
        ),
      ),
    );
  }
}
