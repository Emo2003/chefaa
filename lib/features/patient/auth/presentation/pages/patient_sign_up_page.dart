import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/already_have_account.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/core/widgets/terms_of_service.dart';
import 'package:chefaa/features/patient/auth/presentation/manager/patient_cubit.dart';
import 'package:chefaa/features/patient/auth/presentation/manager/patient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_bar_content.dart';
import '../../../../../core/widgets/validators.dart';

class PatientSignUpPage extends StatefulWidget {
  final String? role;

  const PatientSignUpPage({super.key, required this.role});

  @override
  State<PatientSignUpPage> createState() => _PatientSignUpPageState();
}

class _PatientSignUpPageState extends State<PatientSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  late final PatientCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PatientCubit>()..setRole(widget.role!);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          preferredHeight: 150.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: const AppBarContent(),
        ),
        body: BlocListener<PatientCubit, PatientState>(
          listener: (context, state) {
            if (state is SignUpLoadingState) {
              Loading.show(context);
            }
            if (state is SignUpErrorState) {
              Loading.hide(context);
            }
            if (state is SignUpSuccessState) {
              Loading.hide(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(AppRoutesNames.patientSignUpCompleteData);
            }
          },
          child: SafeArea(
            child: Builder(
              builder: (context) {
                final cubit = PatientCubit.get(context);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p28,
                      vertical: AppPadding.p48,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            spacing: 7,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  validator: Validators.nameValidator,
                                  controller: cubit.nameController,
                                  text: AppConstants.firstName,
                                  prefixIcon: IconsAssets.userIcon,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              Expanded(
                                child: CustomTextField(
                                  validator: Validators.nameValidator,
                                  controller: cubit.lastNameController,
                                  text: AppConstants.lastName,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ],
                          ),
                          15.verticalSpace,
                          CustomTextField(
                            validator: Validators.validatePhone,
                            controller: cubit.phoneController,
                            text: AppConstants.enterPhone,
                            prefixIcon: IconsAssets.phoneIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                          ),

                          15.verticalSpace,
                          CustomTextField(
                            validator: Validators.validateEmail,
                            controller: cubit.emailController,
                            text: AppConstants.enterEmail,
                            prefixIcon: IconsAssets.emailIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          15.verticalSpace,
                          CustomTextField(
                            validator: Validators.validatePassword,
                            controller: cubit.passwordController,
                            text: AppConstants.enterPassword,
                            prefixIcon: IconsAssets.passwordIcon,
                            isPass: true,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          15.verticalSpace,
                          CustomTextField(
                            validator: (value) =>
                                Validators.validateConfirmPassword(
                                  value,
                                  cubit.passwordController.text,
                                ),
                            controller: cubit.confirmPasswordController,
                            text: " Confirm your Password",
                            prefixIcon: IconsAssets.passwordIcon,
                            isPass: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          27.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          50.verticalSpace,
                          BlocSelector<PatientCubit, PatientState, bool>(
                            selector: (state) => state is SignUpLoadingState,
                            builder: (context, isLoading) {
                              return CustomBtn(
                                isDisabled: isLoading || !isChecked,
                                text: AppConstants.createAccount,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.patientSignUp();
                                  }
                                },
                              );
                            },
                          ),
                          12.verticalSpace,
                          AlreadyHaveAccount(
                            onPressed: () {
                              context.go(AppRoutesNames.login);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
