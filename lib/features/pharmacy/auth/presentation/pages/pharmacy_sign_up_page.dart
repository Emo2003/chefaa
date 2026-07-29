import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/terms_of_service.dart';
import 'package:chefaa/core/widgets/upload_container.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/shared/file_handler/presentation/manager/file_handler_cubit.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/license_formatter.dart';
import 'package:chefaa/features/pharmacy/auth/presentation/manager/pharmacy_cubit.dart';
import 'package:go_router/go_router.dart';

class PharmacySignUpPage extends StatefulWidget {
  const PharmacySignUpPage({super.key});

  @override
  State<PharmacySignUpPage> createState() => _PharmacySignUpPageState();
}

class _PharmacySignUpPageState extends State<PharmacySignUpPage> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final PharmacyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PharmacyCubit>();
    FileHandlerCubit.get(context).clearFile();
  }

  @override
  void dispose() {
    _cubit.close();
    FileHandlerCubit.get(context).clearFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xffe1e3ec),
        appBar: CustomAppBar(
          preferredHeight: 150.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: const AppBarContent(),
        ),
        body: BlocListener<PharmacyCubit, PharmacyState>(
          listener: (context, state) {
            if (state is PharmacyLoadingState) {
              Loading.show(context);
            } else if (state is PharmacyErrorState) {
              Loading.hide(context);
              AnimatedSnackBar.rectangle(
                AppConstants.error,
                state.message,
                type: AnimatedSnackBarType.error,
                brightness: Brightness.dark,
              ).show(context);
            } else if (state is PharmacySuccessState) {
              Loading.hide(context);
              AnimatedSnackBar.rectangle(
                AppConstants.success,
                "Welcome Pharmacy. ${state.pharmacy.name}!",
                type: AnimatedSnackBarType.success,
                brightness: Brightness.dark,
              ).show(context);
              context.go(AppRoutesNames.login);
            }
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p18,
                  vertical: AppPadding.p16,
                ),
                child: Builder(
                  builder: (context) {
                    var cubit = PharmacyCubit.get(context);
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppPadding.p18),
                            margin: const EdgeInsets.all(AppMargin.m8),
                            decoration: BoxDecoration(
                              color: ColorManager.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                20.verticalSpace,
                                const Text(
                                  "Pharmacy Name",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.businessNameValidator,
                                  controller: cubit.name,
                                  text: "Full Pharmacy legal name",
                                  keyboardType: TextInputType.name,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.phoneNumber,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.validatePhone,
                                  prefixIcon: IconsAssets.phoneIcon,
                                  controller: cubit.phoneNumber,
                                  text: AppConstants.phoneHint,
                                  keyboardType: TextInputType.phone,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.workEmail,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.validateEmail,
                                  prefixIcon: IconsAssets.emailIcon,
                                  controller: cubit.email,
                                  text: AppConstants.emailPharmacyHint,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.password,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.validatePassword,
                                  prefixIcon: IconsAssets.passwordIcon,
                                  controller: cubit.password,
                                  text: AppConstants.enterPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.confirmPassword,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.visiblePassword,

                                  validator: (value) =>
                                      Validators.validateConfirmPassword(
                                        value,
                                        cubit.password.text,
                                      ),
                                  prefixIcon: IconsAssets.passwordIcon,
                                  controller: cubit.confirmPasswordController,
                                  text: AppConstants.reEnterPassword,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.commercialLicenseNumber,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9]'),
                                    ),
                                    LicenseFormatter(),
                                  ],
                                  validator: Validators.validateLicense,
                                  controller: cubit.registerNumber,
                                  text: AppConstants.licenseHint,
                                ),
                                20.verticalSpace,
                                const Text(
                                  AppConstants.medicalLicenseUpload,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                10.verticalSpace,
                                const UploadCard(
                                  text: AppConstants.uploadYourLicence,
                                  dialogText:
                                      AppConstants.uploadYourMedicalLicence,
                                  fileName: AppConstants.licensePdf,
                                ),
                              ],
                            ),
                          ),
                          40.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 27.h,
                                width: 27.w,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                  icon: isChecked
                                      ? SvgPicture.asset(
                                          IconsAssets.checkIconActive,
                                        )
                                      : SvgPicture.asset(
                                          IconsAssets.checkIconInactive,
                                        ),
                                ),
                              ),
                              14.horizontalSpace,
                              const Expanded(child: TermsOfService()),
                            ],
                          ),
                          25.verticalSpace,

                          BlocSelector<PharmacyCubit, PharmacyState, bool>(
                            selector: (state) => state is PharmacyLoadingState,
                            builder: (context, isLoading) {
                              return CustomBtn(
                                isDisabled: !isChecked || isLoading,
                                text: AppConstants.submitForVerification,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final file = context
                                        .read<FileHandlerCubit>()
                                        .pickedFile;

                                    cubit.pharmacySignUp(medicalLicence: file);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
