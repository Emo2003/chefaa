import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/manager/complete_cubit.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/widgets/complete_data_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SecondCompletePage extends StatefulWidget {
  const SecondCompletePage({super.key});

  @override
  State<SecondCompletePage> createState() => _SecondCompletePageState();
}

class _SecondCompletePageState extends State<SecondCompletePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: Column(
            children: [
              50.verticalSpace,
              Text(
                "Do you have any chronic conditions?",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,
              Expanded(
                child: CompleteDataContainer(
                  isList: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppPadding.p8),
                    child:
                        BlocSelector<
                          CompleteCubit,
                          CompleteState,
                          List<String>
                        >(
                          selector: (state) => state.chronicConditions,
                          builder: (context, chronicConditions) {
                            return ListView.separated(
                              itemCount: AppConstants.chronicConditions.length,
                              separatorBuilder: (context, index) => Divider(
                                indent: 10.w,
                                endIndent: 12.w,
                                color: Colors.grey.shade300,
                                thickness: 2,
                                height: 0.h,
                              ),
                              itemBuilder: (context, index) {
                                final disease =
                                    AppConstants.chronicConditions[index];
                                final isSelected = chronicConditions.contains(
                                  disease,
                                );
                                return GestureDetector(
                                  onTap: () => context
                                      .read<CompleteCubit>()
                                      .toggleChronicConditions(disease),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.h,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 16.w,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorManager.gray.withValues(
                                              alpha: 0.35,
                                            )
                                          : ColorManager.transparent,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.2,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      disease,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorManager.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  ),
                ),
              ),
              50.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                child: CustomTextField(
                  controller: controller,
                  text: "Enter the name of chronic diseases",
                ),
              ),
              30.verticalSpace,
              CustomBtn(
                text: "Continue",
                onPressed: () {
                  final cubit = CompleteCubit.get(context);
                  cubit.addCustomChronicDisease(controller.text);
                  context.push(
                    AppRoutesNames.patientSignUpCompleteMedicines,
                    extra: CompleteCubit.get(context),
                  );
                },
              ),
              15.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
