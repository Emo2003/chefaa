import 'package:animated_toggle/animated_toggle.dart';
import 'package:chefaa/core/extensions/build_ex.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/features/auth/presentation/manager/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/auth/presentation/widgets/back_button.dart';
import 'package:go_router/go_router.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  int currentIndex = 0;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorManager.white,
        title: Center(child: Text(message)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          preferredHeight: 150.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: const AppBarContent(),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ForgotPassLoadingState) {
              Loading.show(context);
            } else if (state is ForgotPassSuccessState) {
              Loading.hide(context);
              context.push(AppRoutesNames.resetCode.replaceFirst(':index', currentIndex.toString()));
            } else if (state is ForgotPassErrorState) {
              Loading.hide(context);
              _showErrorDialog(context, state.message!);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.forgotPassFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackBtn(),
                    36.verticalSpace,
                    Text(
                      "Forgot Your Password?",
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s24,
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      "Enter your email or phone number,\nwe will send you confirmation codes",
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: 16,
                      ),
                    ),
                    32.verticalSpace,
                    AnimatedHorizontalToggle(
                      taps: const ['Email', 'Phone'],
                      width: context.width * .85,
                      height: 55,
                      duration: const Duration(milliseconds: 100),
                      initialIndex: 0,
                      background: ColorManager.input,
                      activeColor: ColorManager.white,
                      activeTextStyle: getSemiBoldStyle(
                        color: ColorManager.primary,
                        fontSize: 16,
                      ),
                      inActiveTextStyle: getSemiBoldStyle(
                        color: ColorManager.gray,
                        fontSize: 16,
                      ),
                      horizontalPadding: 4,
                      verticalPadding: 4,
                      activeHorizontalPadding: 2,
                      activeVerticalPadding: 4,
                      radius: 32,
                      activeButtonRadius: 32,
                      onChange: (int index, int targetIndex) {
                        setState(() => currentIndex = index);
                      },
                      showActiveButtonColor: true,
                      local: 'en',
                    ),
                    16.verticalSpace,
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: currentIndex == 0
                          ? CustomTextField(
                              key: const ValueKey('email'),
                              validator: Validators.validateEmail,
                              controller: cubit.emailController,
                              text: AppConstants.enterEmail,
                              prefixIcon: IconsAssets.emailIcon,
                            )
                          : CustomTextField(
                              key: const ValueKey('phone'),
                              validator: Validators.validatePhone,
                              controller: cubit.phoneController,
                              text: AppConstants.enterPhone,
                              prefixIcon: IconsAssets.phoneIcon,
                            ),
                    ),
                    56.verticalSpace,
                    CustomBtn(
                      text: "Reset your password",
                      onPressed: () => cubit.forgotPass(currentIndex),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
