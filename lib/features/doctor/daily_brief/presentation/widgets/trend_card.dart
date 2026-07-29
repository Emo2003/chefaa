import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class TrendCard extends StatelessWidget {
  final String value;
  final String title;

  const TrendCard({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:const  EdgeInsets.symmetric(vertical: AppPadding.p14, horizontal: AppPadding.p8),
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
      child: Column(
        spacing: 5.h,
        children: [
          Text(
            value,
            style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(color: ColorManager.gray, fontSize: 11.sp)
          ),
        ],
      ),
    );
  }
}