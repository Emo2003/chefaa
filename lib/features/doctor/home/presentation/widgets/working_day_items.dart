import 'package:flutter/material.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';

class WorkingDayItems extends StatelessWidget {
  final List<String> weekDays;
  final Map<String, bool> selectedDays;
  final Function(String day) onDayTap;

  const WorkingDayItems({
    super.key,
    required this.weekDays,
    required this.selectedDays,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: weekDays.map((day) {
        final isSelected = selectedDays[day] ?? false;

        return GestureDetector(
          onTap: () => onDayTap(day),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

              color: isSelected ? ColorManager.primary : ColorManager.input,

              border: Border.all(
                color: isSelected
                    ? ColorManager.primary
                    : ColorManager.lightGray,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  day,
                  style: getBoldStyle(
                    color: isSelected ? Colors.white : ColorManager.gray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
