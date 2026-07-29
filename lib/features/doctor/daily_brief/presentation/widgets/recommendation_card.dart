import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';

class RecommendationsCard extends StatelessWidget {
  final List<String> recommendations;

  const RecommendationsCard({
    super.key,
    this.recommendations = const [
      "Focus on reducing the cancellation rate by implementing a reminder system for patients.",
      "Encourage patients to prepay for sessions to ensure commitment.",
      "Promote the clinics with pending approval to increase patient reach and revenue.",
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(recommendations.length, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppMargin.m12),
          padding: const EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.primary.withAlpha(15)),
            color: ColorManager.primary.withAlpha(10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ColorManager.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: getSemiBoldStyle(color: ColorManager.white, fontSize: 12.sp)
                ),
              ),
              Expanded(
                child: Text(
                  recommendations[index],
                  style: getRegularStyle(color: ColorManager.darkGray, fontSize: 13.sp)
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}