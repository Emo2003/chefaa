import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/features/onboarding/presentation/widgets/next_button.dart';
import 'package:chefaa/features/onboarding/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                48.verticalSpace,
                Text(
                  "Choose who you are",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s24,
                  ),
                ),
                24.verticalSpace,
                OptionCard(
                  title: AppConstants.doctor,
                  image: ImageAssets.doctor,
                  isSelected: selectedRole == AppConstants.doctor,
                  onTap: () => onSelect(AppConstants.doctor),
                ),
                32.verticalSpace,

                OptionCard(
                  title: AppConstants.patient,
                  image: ImageAssets.patient,
                  isSelected: selectedRole == AppConstants.patient,
                  onTap: () => onSelect(AppConstants.patient),
                ),

                32.verticalSpace,

                OptionCard(
                  title: AppConstants.pharmacy,
                  image: ImageAssets.drugs,
                  isSelected: selectedRole == AppConstants.pharmacy,
                  onTap: () => onSelect(AppConstants.pharmacy),
                ),
                32.verticalSpace,
                OptionCard(
                  title: "Medical Lab /\nRadiology Center",
                  image: "assets/images/lab.png",
                  isSelected: selectedRole == AppConstants.lab,
                  onTap: () => onSelect(AppConstants.lab),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p60,
                    vertical: AppPadding.p48,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NextButton(
                        isEnabled: selectedRole != null,
                        onTap: () {
                          if (selectedRole == AppConstants.doctor) {
                            context.pushReplacement(
                              AppRoutesNames.docSignUp,
                              extra: AppConstants.doctor.toLowerCase(),
                            );
                          } else if (selectedRole == AppConstants.patient) {
                            context.pushReplacement(
                              AppRoutesNames.patientSignUp.replaceFirst(':role', AppConstants.patient.toLowerCase()),
                            );
                          } else if (selectedRole == AppConstants.lab) {
                            context.pushReplacement(AppRoutesNames.facilitySignUp, extra: AppConstants.lab.toLowerCase());
                          } else if (selectedRole == AppConstants.pharmacy) {
                            context.pushReplacement(AppRoutesNames.pharmacySignUp, extra: AppConstants.pharmacy.toLowerCase());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
