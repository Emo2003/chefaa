import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class ClinicPerformanceCard extends StatelessWidget {
  final String clinicName;
  final num completed;
  final num upcoming;
  final double revenue;
  final double percentage;
  final Color accentColor;

  const ClinicPerformanceCard({
    super.key,
    required this.clinicName,
    required this.completed,
    required this.upcoming,
    required this.revenue,
    required this.percentage,
    this.accentColor = ColorManager.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(20),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  clinicName,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(color: ColorManager.black, fontSize: 14.sp)
                ),
              ),
              Text(
                "${revenue.toStringAsFixed(0)} EGP",
                style: getBoldStyle(color: accentColor, fontSize: 14.sp)
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            spacing: 8.w,
            children: [
              _StatChip(
                value: "$completed",
                label: "Done",
                color: ColorManager.lightGreen,
              ),
              _StatChip(
                value: "$upcoming",
                label: "Upcoming",
                color: Colors.grey.shade500,
              ),
              const Spacer(),
              Text(
                "${percentage.toStringAsFixed(0)}% of revenue",
                style: getSemiBoldStyle(color: ColorManager.error, fontSize: 12.sp)
              ),
            ],
          ),
          10.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0, 1),
              minHeight: 5.h,
              backgroundColor: accentColor.withAlpha(20),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        spacing: 5.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: getBoldStyle(color: color, fontSize: 12.sp)
          ),
          Text(
            label,
            style: getRegularStyle(color: color, fontSize: 12.sp)
          ),
        ],
      ),
    );
  }
}