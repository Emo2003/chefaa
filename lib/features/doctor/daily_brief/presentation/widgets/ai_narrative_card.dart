import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class AiNarrativeCard extends StatelessWidget {
  final String narrative;

  const AiNarrativeCard({
    super.key,
    this.narrative =
    "Dr. Sara Ahmed's financial performance shows a positive net revenue of 591 EGP this month, with an additional 1600 EGP expected from upcoming sessions. However, the low completion rate and high cancellation rate indicate potential risks to sustained revenue growth.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: ColorManager.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorManager.primary.withAlpha(50)),
      ),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: ColorManager.primary, size: 18.sp),
          Expanded(
            child: Text(
              narrative,
              style: getRegularStyle(color: ColorManager.black, fontSize: 13.sp)
            ),
          ),
        ],
      ),
    );
  }
}