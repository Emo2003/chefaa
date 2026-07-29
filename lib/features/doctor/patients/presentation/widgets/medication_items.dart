import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class MedicationItems extends StatelessWidget {
  final String medicationName;
  final String dosage;
  final String frequency;
  final String duration;

  const MedicationItems({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$medicationName  $dosage",
            style: getBoldStyle(color: ColorManager.black, fontSize: 17.sp),
          ),

          8.verticalSpace,
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p10,
                  vertical: AppPadding.p2,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue.withAlpha(100),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: ColorManager.input, width: 1),
                ),
                child: Text(
                  frequency,
                  style: getMediumStyle(
                    color: ColorManager.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              10.horizontalSpace,
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p10,
                  vertical: AppPadding.p2,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue.withAlpha(100),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: ColorManager.input, width: 1),
                ),
                child: Text(
                  duration,
                  style: getMediumStyle(
                    color: ColorManager.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),

          5.verticalSpace,
        ],
      ),
    );
  }
}
