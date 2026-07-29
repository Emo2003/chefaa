import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_calender.dart';
import 'package:chefaa/core/widgets/custom_dropdown_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/manager/complete_cubit.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/widgets/complete_data_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes_names.dart';

class FirstCompletePage extends StatefulWidget {
  const FirstCompletePage({super.key});

  @override
  State<FirstCompletePage> createState() => _FirstCompletePageState();
}

class _FirstCompletePageState extends State<FirstCompletePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    bloodTypeController.dispose();
    birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p32,
            vertical: AppPadding.p48,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CompleteDataContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p14,
                      vertical: AppPadding.p16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,

                        const Text(
                          "Gender",
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        12.verticalSpace,

                        BlocSelector<CompleteCubit, CompleteState, String?>(
                          selector: (state) => state.gender,
                          builder: (context, gender) {
                            return CustomDropDownBtn(
                              items: const ["Male", "Female"],
                              hintText: "Select Your Gender",
                              value: gender,
                              onChanged: (value) {
                                context.read<CompleteCubit>().updateGender(
                                  value,
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                        23.verticalSpace,

                        const Text(
                          "Date of Birth",
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        12.verticalSpace,

                        CustomCalendarField(
                          hintText: "Select Date of Birth",
                          controller: birthController,
                          onDateSelected: (date) {
                            final formatted =
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            context.read<CompleteCubit>().updateBirthDate(date);
                            birthController.text = formatted;
                          },
                        ),

                        23.verticalSpace,

                        const Text(
                          "Weight",
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        12.verticalSpace,

                        CustomTextField(
                          suffixText: "kg",
                          completeData: true,
                          controller: weightController,
                          text: "Weight",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            return null;
                          },
                        ),

                        23.verticalSpace,

                        const Text(
                          "Height",
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        12.verticalSpace,

                        CustomTextField(
                          suffixText: "cm",
                          completeData: true,
                          controller: heightController,
                          text: "Height",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            return null;
                          },
                        ),

                        23.verticalSpace,

                        const Text(
                          "Blood Type",
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        12.verticalSpace,

                        CustomTextField(
                          completeData: true,
                          controller: bloodTypeController,
                          text: "Blood Type with ( + or - )",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your blood type';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                50.verticalSpace,

                CustomBtn(
                  text: "Continue",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final cubit = CompleteCubit.get(context);
                      final error = cubit.captureBasicInfo(
                        weightText: weightController.text,
                        heightText: heightController.text,
                        bloodTypeText: bloodTypeController.text,
                      );

                      if (error != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error)));
                        return;
                      }
                      context.push(
                        AppRoutesNames.patientSignUpCompleteChronicDiseases,
                        extra: cubit,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
