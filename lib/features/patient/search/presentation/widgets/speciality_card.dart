import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:go_router/go_router.dart';

class SpecialityCard extends StatelessWidget {
  final Map<String, String> item;

  const SpecialityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop(item["specialityName"]);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppPadding.p10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.black.withValues(alpha: .1),
                    blurRadius: AppSize.s5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(item["specialityImage"]!, fit: BoxFit.contain),
            ),
          ),

          6.verticalSpace,

          Text(
            item["specialityName"]!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
