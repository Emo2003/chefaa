import 'package:chefaa/core/extensions/build_ex.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/services/storage_service.dart';
import 'package:chefaa/features/onboarding/data/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'next_button.dart';

class OnboardingContainer extends StatelessWidget {
  final List<OnboardingModel> onboarding;
  final int screenIndex;
  final void Function() next;

  const OnboardingContainer({
    super.key,
    required this.next,
    required this.screenIndex,
    required this.onboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height * 0.38,
      padding: REdgeInsets.all(AppPadding.p48),
      decoration: const BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s32),
          topRight: Radius.circular(AppSize.s32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            onboarding[screenIndex].title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s24.sp,
            ),
          ),
          SizedBox(height: AppSize.s16.h),
          Text(
            onboarding[screenIndex].description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              color: ColorManager.gray,
              fontSize: FontSize.s16.sp,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(onboarding.length, (index) {
                  bool isActive = screenIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 28.w : 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? ColorManager.primary
                          : ColorManager.gray,
                      borderRadius: BorderRadius.circular(36),
                    ),
                  );
                }),
              ),
              NextButton(
                onTap: () async {
                  final isLastPage = screenIndex == onboarding.length - 1;

                  if (!isLastPage) {
                    next();
                  } else {
                    if (!context.mounted) return;
                    await StorageService.markOnboardingSeen();
                    if (!context.mounted) return;
                    context.go(AppRoutesNames.login);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
