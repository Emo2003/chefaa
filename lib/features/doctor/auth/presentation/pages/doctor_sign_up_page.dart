import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/already_have_account.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/core/widgets/terms_of_service.dart';
import 'package:chefaa/core/widgets/upload_container.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/features/doctor/auth/presentation/manager/doctor_auth_cubit.dart';
import 'package:chefaa/shared/file_handler/presentation/manager/file_handler_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DocSignUp extends StatefulWidget {
  const DocSignUp({super.key});

  @override
  State<DocSignUp> createState() => _DocSignUpState();
}

class _DocSignUpState extends State<DocSignUp> {
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  late final DoctorAuthCubit _cubit;
  late final FileHandlerCubit _fileHandlerCubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DoctorAuthCubit>();
    _fileHandlerCubit = context.read<FileHandlerCubit>();
    _fileHandlerCubit.clearFile();
  }

  @override
  void dispose() {
    _cubit.close();
    _fileHandlerCubit.clearFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          preferredHeight: 150.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: const AppBarContent(),
        ),
        body: BlocListener<DoctorAuthCubit, DoctorAuthState>(
          listener: (context, state) {
            if (state is SingUpLoading) {
              Loading.show(context);
            } else if (state is SingUpFailure) {
              Loading.hide(context);
              AnimatedSnackBar.rectangle(
                AppConstants.error,
                state.errorMessage,
                type: AnimatedSnackBarType.error,
                brightness: Brightness.dark,
              ).show(context);
            } else if (state is SingUpSuccess) {
              Loading.hide(context);
              AnimatedSnackBar.rectangle(
                AppConstants.success,
                "Welcome Dr. ${state.userName}!",
                type: AnimatedSnackBarType.success,
                brightness: Brightness.dark,
              ).show(context);
              context.go(AppRoutesNames.login);
            }
          },
          child: SafeArea(
            child: Builder(
              builder: (context) {
                var cubit = DoctorAuthCubit.get(context);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          45.verticalSpace,

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  validator: Validators.nameValidator,
                                  controller: cubit.name,
                                  text: AppConstants.firstName,
                                  prefixIcon: IconsAssets.userIcon,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  validator: Validators.nameValidator,
                                  controller: cubit.lastName,
                                  text: AppConstants.lastName,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,

                          CustomTextField(
                            validator: Validators.validatePhone,
                            controller: cubit.phoneNumber,
                            text: AppConstants.enterPhone,
                            prefixIcon: IconsAssets.phoneIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            validator: Validators.validateEmail,
                            controller: cubit.email,
                            text: AppConstants.enterEmail,
                            prefixIcon: IconsAssets.emailIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            validator: Validators.validatePassword,
                            controller: cubit.password,
                            text: AppConstants.enterPassword,
                            prefixIcon: IconsAssets.passwordIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,

                            isPass: true,
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validators.validateConfirmPassword(
                                  value,
                                  cubit.password.text,
                                ),
                            controller: cubit.confirmPasswordController,
                            text: AppConstants.reEnterPassword,
                            prefixIcon: IconsAssets.passwordIcon,
                            keyboardType: TextInputType.visiblePassword,

                            isPass: true,
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            controller: cubit.specialization,
                            text: "Enter your specialization",
                            prefixIcon: IconsAssets.drugIcon,
                          ),
                          8.verticalSpace,
                          const UploadCard(),
                          16.verticalSpace,

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  isChecked = !isChecked;
                                  setState(() {});
                                },
                                child: isChecked
                                    ? SvgPicture.asset(
                                        IconsAssets.checkIconActive,
                                      )
                                    : SvgPicture.asset(
                                        IconsAssets.checkIconInactive,
                                      ),
                              ),
                              12.horizontalSpace,
                              const Expanded(child: TermsOfService()),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          BlocSelector<DoctorAuthCubit, DoctorAuthState, bool>(
                            selector: (state) => state is SingUpLoading,
                            builder: (context, isLoading) {
                              return CustomBtn(
                                isDisabled: !isChecked || isLoading,
                                text: AppConstants.submitForVerification,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final file = context
                                        .read<FileHandlerCubit>()
                                        .pickedFile;

                                    cubit.signUp(membershipFile: file);
                                  }
                                },
                              );
                            },
                          ),
                          AlreadyHaveAccount(
                            onPressed: () {
                              context.go(
                                AppRoutesNames.login,
                                extra: AppConstants.doctor.toLowerCase(),
                              );
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
