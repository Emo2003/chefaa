import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/patient/cart/presentation/widgets/order_summary_card.dart';
import 'package:chefaa/features/patient/payment/presentation/manager/payment_cubit.dart';
import 'package:chefaa/features/patient/payment/presentation/widgets/card_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes_names.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final double subtotal;
  final double deliveryFee;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.subtotal,
    required this.deliveryFee,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final cardNumber = TextEditingController();
  final holder = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();

  double get total => widget.subtotal + widget.deliveryFee;

  @override
  void dispose() {
    cardNumber.dispose();
    holder.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCubit>(
      create: (context) => getIt<PaymentCubit>(),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: InsideAppBar(
            title: "Payment",
            subtitle: "Enter your card details to complete the payment",
          ),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentLoading) {
              Loading.show(context);
            } else if (state is PaymentSuccess) {
              Loading.hide(context);
              AnimatedSnackBar.rectangle(
                AppConstants.success,
                state.response.message,
                type: AnimatedSnackBarType.success,
                brightness: Brightness.dark,
              ).show(context);
              context.go(AppRoutesNames.trackOrderPage.replaceFirst(':orderId', widget.orderId));
            } else if (state is PaymentFailure) {
              Loading.hide(context);
              if (state.message == "This order is already paid.") {
                AnimatedSnackBar.rectangle(
                  AppConstants.success,
                  state.message,
                  type: AnimatedSnackBarType.success,
                  brightness: Brightness.dark,
                ).show(context);
                context.go(AppRoutesNames.trackOrderPage.replaceFirst(':orderId', widget.orderId));
              } else {
                AnimatedSnackBar.rectangle(
                  AppConstants.error,
                  state.message,
                  type: AnimatedSnackBarType.error,
                  brightness: Brightness.dark,
                ).show(context);
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CardDetails(
                    cardNumber: cardNumber,
                    holder: holder,
                    expiry: expiry,
                    cvv: cvv,
                  ),
                  16.verticalSpace,
                  OrderSummaryCard(
                    subtotal: widget.subtotal,
                    deliveryFee: widget.deliveryFee,
                    total: total,
                    onPressed: () {
                      if (holder.text.trim().isEmpty ||
                          cardNumber.text.trim().isEmpty ||
                          expiry.text.trim().isEmpty ||
                          cvv.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all card details"),
                            backgroundColor: ColorManager.error,
                          ),
                        );
                        return;
                      }

                      final paymentData = {
                        "orderId": widget.orderId,
                        "cardholderName": holder.text.trim(),
                        "cardNumber": cardNumber.text.trim(),
                        "expiryDate": expiry.text.trim(),
                        "cvv": cvv.text.trim(),
                      };

                      context.read<PaymentCubit>().processOnlinePayment(
                        paymentData,
                      );
                    },
                    btnTitle: "Payment Now",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
