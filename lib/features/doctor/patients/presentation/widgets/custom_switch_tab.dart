import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class CustomSwitchTab extends StatefulWidget {
  final Function(int index) onChanged;
  final List<String> items;

  const CustomSwitchTab({
    super.key,
    required this.onChanged,
    required this.items,
  });

  @override
  State<CustomSwitchTab> createState() => _CustomSwitchTabState();
}

class _CustomSwitchTabState extends State<CustomSwitchTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      padding: const EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: ColorManager.gray.withAlpha(50),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / widget.items.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: itemWidth * selectedIndex,
                top: 0,
                bottom: 0,
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),

              Row(
                children: List.generate(
                  widget.items.length,
                  (index) =>
                      _buildTab(title: widget.items[index], index: index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab({required String title, required int index}) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30.r),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });

          widget.onChanged(index);
        },
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title,
            style: getBoldStyle(
              fontSize: isSelected ? 15.sp : 12.sp,
              color: isSelected ? ColorManager.primary : ColorManager.gray,
            ),
          ),
        ),
      ),
    );
  }
}
