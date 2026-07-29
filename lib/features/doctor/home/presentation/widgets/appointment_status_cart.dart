import 'package:chefaa/features/doctor/home/presentation/widgets/indicator_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class AppointmentStatusCart extends StatelessWidget {
  const AppointmentStatusCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 120.h,
          width: 115.w,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 50.r,
              sections: [
                PieChartSectionData(
                  showTitle: false,
                  value: 60,
                  color: ColorManager.lightGreen,
                  radius: 20,
                ),
                PieChartSectionData(
                  showTitle: false,
                  value: 25,
                  color: ColorManager.error,
                  radius: 20.r,
                ),
                PieChartSectionData(
                  showTitle: false,
                  value: 15,
                  color: ColorManager.primary,
                  radius: 20.r,
                ),
              ],
            ),
          ),
        ),
        30.horizontalSpace,
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IndicatorStatus(
              title: "Done",
              color: ColorManager.lightGreen,
              value: "60",
            ),
            IndicatorStatus(
              title: "Upcoming",
              color: ColorManager.error,
              value: "25",
            ),
            IndicatorStatus(
              title: "Cancel",
              color: ColorManager.primary,
              value: "15",
            ),
          ],
        ),
      ],
    );
  }
}
