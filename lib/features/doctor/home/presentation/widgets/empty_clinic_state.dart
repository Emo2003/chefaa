import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';

class EmptyClinicsState extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyClinicsState({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital_outlined,
            size: 80.sp,
            color: ColorManager.primary.withAlpha(80),
          ),
          24.verticalSpace,
          Text(
            "No Clinics Yet",
            style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Add your first clinic to start managing appointments",
              style: getMediumStyle(color: ColorManager.gray, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
          ),
          32.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: onAdd,
            child: Text(
              "Add Clinic",
              style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
