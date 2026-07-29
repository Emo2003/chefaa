import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'day_time_container.dart';

class DayActiveContainer extends StatelessWidget {
  final String? activeDay;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final VoidCallback onOpenTap;
  final VoidCallback onCloseTap;

  const DayActiveContainer({
    super.key,
    required this.activeDay,
    required this.openTime,
    required this.closeTime,
    required this.onOpenTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                activeDay!,
                style: getSemiBoldStyle(
                  color: ColorManager.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          7.verticalSpace,

          Row(
            children: [
              Expanded(
                child: DayTimeContainer(
                  title: "Open Time",
                  time: openTime,
                  onTap: () {
                    onOpenTap();
                  },
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: DayTimeContainer(
                  title: "Close Time",
                  time: closeTime,
                  onTap: () {
                    onCloseTap();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
