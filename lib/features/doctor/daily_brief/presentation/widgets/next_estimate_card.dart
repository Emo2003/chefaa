import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class NextEstimateCard extends StatelessWidget {
  final String estimate;
  final String confidence;
  final String description;

  const NextEstimateCard({
    super.key,
    this.estimate = "1,600 EGP",
    this.confidence = "Medium confidence",
    this.description =
    "Based on the revenue expected from upcoming appointments and the current average revenue per session.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "NEXT 30 DAYS ESTIMATE",
                        style: getSemiBoldStyle(color: ColorManager.black, fontSize: 12.sp)
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p4),
                      decoration: BoxDecoration(
                        color: ColorManager.error.withAlpha(40),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        confidence,
                        style: getBoldStyle(color: ColorManager.error, fontSize: 10.sp)
                      ),
                    ),
                  ],
                ),
                Text(
                  estimate,
                  style: getBoldStyle(color: ColorManager.primary, fontSize: 18.sp)
                ),
                Text(
                  description,
                  style: getRegularStyle(color: ColorManager.gray, fontSize: 12.sp)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}