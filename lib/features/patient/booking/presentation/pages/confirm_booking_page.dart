import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/features/patient/booking/presentation/manager/booking_cubit.dart';
import 'package:chefaa/features/patient/booking/presentation/manager/booking_state.dart';
import 'package:chefaa/features/patient/booking/presentation/widgets/confirm_booking/appointment_card.dart';
import 'package:chefaa/features/patient/booking/presentation/widgets/confirm_booking/payment_card_form.dart';
import 'package:chefaa/features/patient/booking/presentation/widgets/confirm_booking/payment_methods_card.dart';
import 'package:chefaa/features/patient/booking/presentation/widgets/sub_text.dart';
import 'package:chefaa/features/patient/booking/presentation/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConfirmBooking extends StatelessWidget {
  const ConfirmBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          current is BookingInitialState ||
          current is BookingLoadingState ||
          current is BookingErrorState ||
          current is BookingSuccessState,
      listenWhen: (previous, current) =>
          current is BookingSuccessState || current is BookingErrorState,
      listener: (context, state) {
        if (state is BookingSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              padding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: ColorManager.lightBlue100,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: ColorManager.primary,
                        size: 20.sp,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        state.message ?? "",
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go(AppRoutesNames.patientLayout);
              }
            }
          });
        }

        if (state is BookingErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(text: "Review & Confirm"),
                  8.verticalSpace,
                  const SubText(text: "Check your appointment details"),
                  32.verticalSpace,

                  AppointmentCard(cubit: cubit),

                  24.verticalSpace,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(text: "Payment Methods"),
                      4.verticalSpace,
                      const SubText(text: "Choose the best way to pay"),
                      16.verticalSpace,
                    ],
                  ),

                  PaymentMethodsCard(
                    title: "Credit Card",
                    image: "assets/images/card_image.png",
                    isSelected:
                        cubit.selectedPaymentMethod == PaymentMethod.creditCard,
                    isGroupHeader: cubit.needsCard,
                    onTap: () =>
                        cubit.selectPaymentMethod(PaymentMethod.creditCard),
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: cubit.needsCard
                        ? PaymentCardForm(
                            formKey: cubit.cardFormKey,
                            cardNumberController: cubit.cardNumberController,
                            cardHolderNameController:
                                cubit.cardHolderNameController,
                            expiryDateController: cubit.expiryDateController,
                            cvvController: cubit.cvvController,
                            borderColor: ColorManager.primary,
                            borderWidth: 2,
                            removeTopBorder: true,
                            showShadow: false,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Column(
                    children: [
                      16.verticalSpace,
                      PaymentMethodsCard(
                        image: "assets/images/cash.png",
                        title: "Cash",
                        isSelected:
                            cubit.selectedPaymentMethod == PaymentMethod.cash,
                        onTap: () =>
                            cubit.selectPaymentMethod(PaymentMethod.cash),
                      ),
                    ],
                  ),

                  32.verticalSpace,

                  if (cubit.selectedPaymentMethod != null)
                    Column(
                      children: [
                        CustomBtn(
                          text: state is BookingLoadingState
                              ? "Booking..."
                              : "Continue",
                          onPressed: state is BookingLoadingState
                              ? () {}
                              : () async {
                                  final canProceed = cubit
                                      .onConfirmBookingPressed();
                                  if (!canProceed) return;

                                  final isCard =
                                      cubit.selectedPaymentMethod ==
                                      PaymentMethod.creditCard;

                                  await cubit.bookAppointment(
                                    clinicId: cubit.selectedClinic!.clinicId,
                                    isFollowUp: false,
                                    paymentOption: isCard
                                        ? "prePay"
                                        : "atClinic",

                                    cardNumber: isCard
                                        ? cubit.cardNumberController.text
                                        : null,
                                    expiryMonth: isCard
                                        ? cubit.expiryDateController.text.split(
                                            "/",
                                          )[0]
                                        : null,
                                    expiryYear: isCard
                                        ? cubit.expiryDateController.text.split(
                                            "/",
                                          )[1]
                                        : null,
                                    cvv: isCard
                                        ? cubit.cvvController.text
                                        : null,
                                    cardholderName: isCard
                                        ? cubit.cardHolderNameController.text
                                        : null,
                                  );
                                },
                        ),

                        12.verticalSpace,

                        Text(
                          "By confirming, you agree to our terms and cancellation policy",
                          style: getMediumStyle(
                            color: ColorManager.gray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
