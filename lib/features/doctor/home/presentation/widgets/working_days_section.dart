import 'package:chefaa/features/doctor/home/presentation/widgets/working_day_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/patient/profile/presentation/widgets/item_container.dart';
import 'day_active_container.dart';

class WorkingDaysSection extends StatelessWidget {
  final String? activeDay;
  final List<String> weekDays;
  final Map<String, bool> selectedDays;
  final Map<String, TimeOfDay?> openTimes;
  final Map<String, TimeOfDay?> closeTimes;

  final Function(String day) onDayTap;

  final Future<void> Function({required String day, required bool isOpen})
  pickTime;

  const WorkingDaysSection({
    super.key,
    required this.activeDay,
    required this.weekDays,
    required this.selectedDays,
    required this.openTimes,
    required this.closeTimes,
    required this.onDayTap,
    required this.pickTime,
  });

  @override
  Widget build(BuildContext context) {
    return ItemContainer(
      isMedication: true,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Working Days & Hours",
              style: getBoldStyle(color: ColorManager.black, fontSize: 18),
            ),

            10.verticalSpace,

            Text(
              "Select your available working days and hours.",
              style: getMediumStyle(color: ColorManager.gray, fontSize: 16),
            ),

            20.verticalSpace,
            WorkingDayItems(
              weekDays: weekDays,
              selectedDays: selectedDays,
              onDayTap: onDayTap,
            ),

            if (activeDay != null) ...[
              24.verticalSpace,

              DayActiveContainer(
                activeDay: activeDay!,
                openTime: openTimes[activeDay],
                closeTime: closeTimes[activeDay],
                onOpenTap: () => pickTime(day: activeDay!, isOpen: true),
                onCloseTap: () => pickTime(day: activeDay!, isOpen: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
