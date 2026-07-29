import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/onboarding/presentation/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/features/onboarding/presentation/widgets/option_card.dart';
import 'package:go_router/go_router.dart';

class FacilityOptionScreen extends StatefulWidget {
  const FacilityOptionScreen({super.key});

  @override
  State<FacilityOptionScreen> createState() => _FacilityOptionScreenState();
}

class _FacilityOptionScreenState extends State<FacilityOptionScreen> {
  String? selectedRole;

  void onSelect(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        preferredHeight: 130.h,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: const AppBarContent(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text(
                "Choose Facility",
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s24,
                ),
              ),
              const SizedBox(height: 22),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OptionCard(
                      width: 330,
                      title: AppConstants.pharmacy,
                      image: ImageAssets.drugs,
                      isSelected: selectedRole == AppConstants.pharmacy,
                      onTap: () => onSelect(AppConstants.pharmacy),
                    ),

                    OptionCard(
                      width: 330.w,
                      title: "Medical Lab /\nRadiology Center",
                      image: "assets/images/lab.png",
                      isSelected: selectedRole == AppConstants.lab,
                      onTap: () => onSelect(AppConstants.lab),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NextButton(
                            isEnabled: selectedRole != null,
                            onTap: () {
                              if (selectedRole == AppConstants.lab) {
                                context.pushReplacement(AppRoutesNames.facilitySignUp, extra: AppConstants.lab.toLowerCase(),
                                );
                              } else if (selectedRole ==
                                  AppConstants.pharmacy) {
                                context.pushReplacement(AppRoutesNames.pharmacySignUp, extra: AppConstants.pharmacy
                                      .toLowerCase(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
