import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';

class RiskFlagsCard extends StatelessWidget {
  final List<String> risks;

  const RiskFlagsCard({
    super.key,
    this.risks = const [
      "High cancellation rate may impact revenue stability.",
      "Pending clinic approvals limit the doctor's ability to expand patient base.",
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: risks.map((risk) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppMargin.m12),
          padding: const EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            color: ColorManager.error.withAlpha(40),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorManager.error.withAlpha(100)),
          ),
          child: Row(
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: ColorManager.error, size: 16.sp),
              Expanded(
                child: Text(
                  risk,
                  style: getRegularStyle(
                    color: ColorManager.darkGray,
                    fontSize: 14.sp,
                )),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}