import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';

class IndicatorStatus extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const IndicatorStatus({
    super.key,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        7.horizontalSpace,
        Text(
          title,
          style: getBoldStyle(color: ColorManager.darkGray, fontSize: 18.sp),
        ),
        15.horizontalSpace,
        Text(
          value,
          style: getBoldStyle(color: ColorManager.gray, fontSize: 18.sp),
        ),
      ],
    );
  }
}
