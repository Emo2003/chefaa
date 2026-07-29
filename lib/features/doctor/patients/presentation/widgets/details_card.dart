import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';

class DetailsCard extends StatelessWidget {
  final List<DetailItem> items;

  const DetailsCard({super.key, required this.items});

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: getBoldStyle(color: ColorManager.gray, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(thickness: 1, color: ColorManager.lightBlue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          children: items.map((item) {
            return Column(
              children: [
                _infoRow(item.title, item.value),
                if (item != items.last) _divider(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DetailItem {
  final String title;
  final String value;

  DetailItem({required this.title, required this.value});
}
