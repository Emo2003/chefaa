import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class FinanceMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const FinanceMiniCard({
    super.key,
    required this.title,
    required this.value,
    this.color = ColorManager.lightGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p12,
        horizontal: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorManager.gray.withAlpha(100)),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: getBoldStyle(color: color, fontSize: 14.sp),
          ),
          Text(
            title,
            style: getBoldStyle(color: ColorManager.black, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
