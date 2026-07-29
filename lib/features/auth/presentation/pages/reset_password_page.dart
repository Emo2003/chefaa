import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/features/auth/presentation/manager/auth_cubit.dart';
import 'package:chefaa/features/auth/presentation/widgets/back_button.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
    return Scaffold(
      appBar: CustomAppBar(
        preferredHeight: 150.h,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: const AppBarContent(),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPassLoadingState) {
            Loading.show(context);
          } else if (state is ResetPassSuccessState) {
            Loading.hide(context);
            context.go(AppRoutesNames.login,
            );
          } else if (state is ResetPassErrorState) {
            Loading.hide(context);
            _showErrorDialog(
              context,
              state.message?.toString() ??
                  "An error occurred. Please try again.",
            );
          }
        },
        child: Builder(
          builder: (context) {
            final cubit = AuthCubit.get(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
            child: Form(
              key: cubit.resetPassFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackBtn(),
                  36.verticalSpace,
                  Text(
                    "Create New Password",
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    "Create your new password to login",
                    style: getMediumStyle(
                      color: ColorManager.gray,
                      fontSize: 16,
                    ),
                  ),
                  62.verticalSpace,
                  CustomTextField(
                    validator: Validators.validatePassword,
                    controller: cubit.password,
                    text: "Enter your new password",
                    prefixIcon: IconsAssets.passwordIcon,
                    isPass: true,
                  ),
                  8.verticalSpace,
                  CustomTextField(
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      cubit.password.text,
                    ),
                    controller: cubit.confirmPasswordController,
                    text: "Confirm password",
                    prefixIcon: IconsAssets.passwordIcon,
                    isPass: true,
                  ),
                  56.verticalSpace,
                  CustomBtn(
                    text: "Reset Password",
                    onPressed: () => cubit.resetPass(),
                  ),
                ],
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}
