import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class ClinicStatus extends StatelessWidget {
  final List<dynamic> days;

  const ClinicStatus({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final today = _getTodayName();
    final isOpen = days.any((day) => day.day == today && day.isActive == true);

    return Container(
      height: 35.h,

      decoration: BoxDecoration(
        color: isOpen ? ColorManager.lightGreen : ColorManager.error,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.timelapse_outlined,
            color: ColorManager.white,
            size: 20,
          ),

          10.horizontalSpace,

          Text(
            isOpen ? "Clinic Open Today" : "Clinic Closed Today",

            style: getBoldStyle(color: ColorManager.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _getTodayName() {
    final now = DateTime.now();

    switch (now.weekday) {
      case 1:
        return "Monday";

      case 2:
        return "Tuesday";

      case 3:
        return "Wednesday";

      case 4:
        return "Thursday";

      case 5:
        return "Friday";

      case 6:
        return "Saturday";

      case 7:
        return "Sunday";

      default:
        return "";
    }
  }
}
