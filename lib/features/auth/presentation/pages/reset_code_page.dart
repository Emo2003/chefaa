import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/app_bar_content.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/auth/presentation/manager/auth_cubit.dart';
import 'package:chefaa/features/auth/presentation/widgets/back_button.dart';
import 'package:go_router/go_router.dart';

class ResetCode extends StatefulWidget {
  const ResetCode({super.key, required this.index});

  final int index;

  @override
  State<ResetCode> createState() => _ResetCodeState();
}

class _ResetCodeState extends State<ResetCode> {
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
          if (state is ResetCodeLoadingState) {
            Loading.show(context);
          } else if (state is ResetCodeSuccessState) {
            Loading.hide(context);
            context.push(AppRoutesNames.resetPassword);
          } else if (state is ResetCodeErrorState) {
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const BackBtn(),
                    36.verticalSpace,
                  Text(
                    "Enter Verification Code",
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  16.verticalSpace,
                  RichText(
                    text: TextSpan(
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(
                          text: "Enter code that we have sent to your\n",
                        ),
                        TextSpan(
                          text: widget.index == 0 ? "email " : "number ",
                        ),
                        TextSpan(
                          text: widget.index == 0
                              ? cubit.emailController.text
                              : cubit.phoneController.text,
                          style: getMediumStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  62.verticalSpace,
                  OtpTextField(
                    numberOfFields: 4,
                    fieldWidth: 50.w,
                    fieldHeight: 50.h,
                    contentPadding: const EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    borderColor: ColorManager.gray,
                    focusedBorderColor: ColorManager.primary,
                    cursorColor: ColorManager.primary,
                    enabledBorderColor: ColorManager.gray,
                    borderRadius: BorderRadius.circular(16.r),
                    borderWidth: 2.w,
                    showFieldAsBox: true,
                    showCursor: false,
                    textStyle: getSemiBoldStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                    ),
                    handleControllers: (controllers) {
                      cubit.setOtpControllers(controllers);
                    },
                    onSubmit: (String verificationCode) {},
                  ),
                  56.verticalSpace,
                  CustomBtn(
                    text: "Verify",
                    onPressed: () => cubit.resetCode(widget.index),
                  ),
                  16.verticalSpace,
                  RichText(
                    text: TextSpan(
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Didn't receive the code? "),
                        TextSpan(
                          text: "Resend",
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: 14,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
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
