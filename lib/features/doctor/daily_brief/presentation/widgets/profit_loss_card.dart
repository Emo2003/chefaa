import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class ProfitLossCard extends StatelessWidget {
  final double netProfit;
  final String description;

  const ProfitLossCard({
    super.key,
    this.netProfit = 591,
    this.description =
    "The doctor has a positive net revenue for the month, with additional revenue expected from upcoming sessions.",
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = netProfit >= 0;
    final Color color =
    isPositive ? ColorManager.lightGreen : ColorManager.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color.withAlpha(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NET PROFIT",
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: 14.sp,
              ),
            ),

            5.verticalSpace,

            Text(
              "${netProfit.toStringAsFixed(0)} EGP",
              style: getBoldStyle(
                color: color,
                fontSize: 18.sp,
              ),
            ),

            5.verticalSpace,

            Text(
              description,
              style: getRegularStyle(
                color: ColorManager.gray,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}