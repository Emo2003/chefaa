import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabTests extends StatelessWidget {
  final List<String> tests;
  const LabTests({super.key, required this.tests});

  @override
  Widget build(BuildContext context) {
    // final List<String> tests = [
    //   "CBC",
    //   "Lipid Profile",
    //   "Liver Function",
    //   "HbA1c",
    //   "Vitamin D",
    //   "Iron Test",
    // ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: ColorManager.black.withAlpha(50), blurRadius: 8),
        ],
      ),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: tests.map((test) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorManager.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorManager.primary.withAlpha(80)),
            ),
            child: Text(
              test,
              style: getBoldStyle(fontSize: 14.sp, color: ColorManager.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
