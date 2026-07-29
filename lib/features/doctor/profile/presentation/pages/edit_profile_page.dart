import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_dropdown_btn.dart';
import 'package:chefaa/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:chefaa/features/doctor/profile/presentation/manager/doctor_profile_cubit.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  final DoctorProfileEntity? doctorData;

  const EditProfilePage({super.key, this.doctorData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late DoctorProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<DoctorProfileCubit>();
    _cubit.initializeControllers(widget.doctorData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _cubit;

    return BlocListener<DoctorProfileCubit, DoctorProfileState>(
      listenWhen: (previous, current) =>
          current is UpdateDoctorDataLoadingState ||
          current is UpdateDoctorDataSuccessState ||
          current is UpdateDoctorDataErrorState,
      listener: (context, state) {
        if (state is UpdateDoctorDataLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            ),
          );
        } else if (state is UpdateDoctorDataSuccessState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: ColorManager.lightGreen,
            ),
          );
          context.pop();
        } else if (state is UpdateDoctorDataErrorState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const InsideAppBar(
                  title: "Edit Profile",
                  subtitle: "Update your personal details",
                  height: AppSize.s120,
                ),
                SizedBox(height: AppSize.s32.h),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: AppSize.s50.r,
                        backgroundColor: ColorManager.lightGray,
                        child: Icon(
                          Icons.person,
                          size: AppSize.s50.r,
                          color: ColorManager.gray,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(AppPadding.p6.r),
                            decoration: const BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: ColorManager.white,
                              size: AppSize.s20.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSize.s32.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
                  child: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
                    buildWhen: (previous, current) =>
                        current is DoctorProfileUIUpdatedState ||
                        current is DoctorProfileControllersInitializedState,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('Basic Information'),
                          CustomTextField(
                            controller: cubit.nameController,
                            text: 'Full Name',
                            prefixIcon: IconsAssets.userIcon,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          SizedBox(height: AppSize.s16.h),

                          CustomTextField(
                            controller: cubit.specializationController,
                            text: 'Specialization',
                            prefixIcon: IconsAssets.specializationIcon,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Specialization is required'
                                : null,
                          ),
                          SizedBox(height: AppSize.s16.h),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomDropDownBtn(
                                  items: const ['Male', 'Female'],
                                  hintText: 'Gender',
                                  value: cubit.selectedGender,
                                  onChanged: cubit.changeGender,
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                      ? 'Select gender'
                                      : null,
                                ),
                              ),
                              SizedBox(width: AppSize.s12.w),
                              Expanded(
                                child: CustomTextField(
                                  controller: cubit.ageController,
                                  text: 'Age',

                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return null;
                                    }
                                    final age = int.tryParse(v.trim());
                                    if (age == null) return 'Enter a valid age';
                                    if (age < 24) return 'Minimum age is 24';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.s16.h),

                          CustomTextField(
                            controller: cubit.yearsOfExperienceController,
                            text: 'Years of Experience',
                            prefixIcon: IconsAssets.appointmentIcon,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return null;
                              if (int.tryParse(v.trim()) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSize.s16.h),

                          CustomTextField(
                            controller: cubit.aboutController,
                            text: 'About',
                            prefixIcon: IconsAssets.aboutIcon,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                          SizedBox(height: AppSize.s24.h),

                          _sectionLabel('Contact'),
                          CustomTextField(
                            controller: cubit.contactNumberController,
                            text: 'Contact Number',
                            validator: Validators.validatePhone,
                            prefixIcon: IconsAssets.phoneIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: AppSize.s24.h),

                          _sectionLabel('Payment'),
                          CustomDropDownBtn(
                            items: const ['Prepayment', 'Postpayment'],
                            hintText: 'Payment Option',
                            value: cubit.selectedPaymentOption,
                            onChanged: cubit.changePaymentOption,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Select payment option'
                                : null,
                          ),
                          SizedBox(height: AppSize.s16.h),

                          CustomTextField(
                            controller: cubit.clinicConsultationPriceController,
                            text: 'Clinic Consultation Price',
                            prefixIcon: IconsAssets.cashIcon,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return null;
                              if (num.tryParse(v.trim()) == null) {
                                return 'Enter a valid price';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSize.s24.h),

                          if (cubit.selectedPaymentOption == 'Prepayment') ...[
                            _buildDynamicList(
                              sectionLabel: 'Pre-payment Numbers',
                              fieldHint: 'Number',
                              addLabel: 'Add Number',
                              controllers: cubit.prePaymentNumberControllers,
                              keyboardType: TextInputType.phone,
                              prefixIcon: IconsAssets.phoneIcon,
                              onAdd: cubit.addPrePaymentField,
                              onRemove: cubit.removePrePaymentField,
                            ),
                            SizedBox(height: AppSize.s24.h),
                          ],

                          _buildDynamicList(
                            sectionLabel: 'Degrees & Certifications',
                            fieldHint: 'Degree',
                            addLabel: 'Add Degree',
                            controllers: cubit.degreeControllers,
                            prefixIcon: IconsAssets.degreeIcon,
                            onAdd: cubit.addDegreeField,
                            onRemove: cubit.removeDegreeField,
                          ),
                          SizedBox(height: AppSize.s48.h),

                          CustomBtn(
                            text: 'Save Changes',
                            onPressed: cubit.saveProfileChanges,
                          ),
                          SizedBox(height: AppSize.s24.h),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppPadding.p8.h),
        child: Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.primary,
            fontSize: FontSize.s13.sp,
          ).copyWith(letterSpacing: 0.4),
        ),
      ),
    );
  }

  Widget _buildDynamicList({
    required String sectionLabel,
    required String fieldHint,
    required String addLabel,
    required List<TextEditingController> controllers,
    required VoidCallback onAdd,
    required void Function(int index) onRemove,
    String? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(sectionLabel),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controllers.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppPadding.p10.h),
              key: ObjectKey(controllers[i]),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controllers[i],
                      text: '$fieldHint ${i + 1}',
                      prefixIcon: prefixIcon,
                      keyboardType: keyboardType,
                      textInputAction: i == controllers.length - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                    ),
                  ),
                  if (controllers.length > 1) ...[
                    SizedBox(width: AppSize.s8.w),
                    GestureDetector(
                      onTap: () => onRemove(i),
                      child: Container(
                        padding: EdgeInsets.all(AppPadding.p8.r),
                        decoration: BoxDecoration(
                          color: ColorManager.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: ColorManager.error,
                          size: AppSize.s18.r,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        SizedBox(height: AppSize.s4.h),
        GestureDetector(
          onTap: onAdd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: ColorManager.primary,
                size: AppSize.s20.r,
              ),
              SizedBox(width: AppSize.s6.w),
              Text(
                addLabel,
                style: getSemiBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
