import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicRevenueShare {
  final String label;
  final double percentage;
  final Color color;

  const ClinicRevenueShare({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

class RevenueSplitCard extends StatelessWidget {
  final List<ClinicRevenueShare> shares;

  const RevenueSplitCard({super.key, required this.shares});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revenue Split",
            style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
          ),
          Center(
            child: SizedBox(
              height: 150.h,
              width: 110.w,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 38.r,
                  sectionsSpace: 1,
                  sections: shares
                      .map(
                        (s) => PieChartSectionData(
                          showTitle: false,
                          value: s.percentage,
                          color: s.color,
                          radius: 20.r,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          15.verticalSpace,
          Column(
            children: shares
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.p4),
                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: s.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            s.label,
                            overflow: TextOverflow.ellipsis,
                            style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: 14.sp,)
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
