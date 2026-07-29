import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/models/pharmacy_card_model.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/models/pharmacy_profile_model.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_profile_cubit.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_review_cubit.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/action_button_card.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/horizontal_info_badge.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/map_card.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/pharmacy_header_card.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/premium_card_decoration.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/section_title.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/service_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';

class PharmacyDetailsPage extends StatelessWidget {
  final PharmacyCardModel pharmacy;

  const PharmacyDetailsPage({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(
          title: "Pharmacy Details",
          subtitle:
              "Explore the pharmacy's services,performance, and location details",
        ),
      ),

      body: BlocProvider<PharmacyProfileCubit>(
        create: (context) =>
            getIt<PharmacyProfileCubit>()..getPharmacyProfile(pharmacy.id),
        child: BlocBuilder<PharmacyProfileCubit, PharmacyProfileState>(
          builder: (context, state) {
            if (state is PharmacyProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              );
            } else if (state is PharmacyProfileFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: ColorManager.error,
                        size: 64.h,
                      ),
                      16.verticalSpace,
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorManager.error,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      24.verticalSpace,
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PharmacyProfileCubit>()
                              .getPharmacyProfile(pharmacy.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          foregroundColor: ColorManager.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is PharmacyProfileSuccess) {
              final PharmacyProfileModel profile = state.pharmacyProfile;

              final double profileLat =
                  profile.location != null &&
                      profile.location!.coordinates.length >= 2
                  ? profile.location!.coordinates[1]
                  : 30.0444;
              final double profileLng =
                  profile.location != null &&
                      profile.location!.coordinates.length >= 2
                  ? profile.location!.coordinates[0]
                  : 31.2357;

              final String workingHoursText = profile.alwaysOpen
                  ? "24/7 Service"
                  : (profile.workingHours.isNotEmpty
                        ? "${profile.workingHours[0].days}: ${profile.workingHours[0].time}"
                        : "Closed");

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PharmacyHeaderCard(
                      name: profile.pharmacyName,
                      location: profile.addressText.isNotEmpty
                          ? profile.addressText
                          : pharmacy.location,
                      distance: pharmacy.distance,
                      isOpen: profile.openNow,
                      acceptsRx: pharmacy.acceptsRx,
                    ),

                    16.verticalSpace,

                    ActionButtonCard(
                      icon: SvgAssets.phone,
                      label: "Call Pharmacy",
                      onTap: () {},
                    ),

                    12.verticalSpace,

                    ActionButtonCard(
                      icon: SvgAssets.orderPharmacy,
                      label: "View Medicines",
                      color: ColorManager.primary,
                      onTap: () {
                        context.push(
                          AppRoutesNames.pharmacyMedicines,
                          extra: {
                            'pharmacyName': profile.pharmacyName.isNotEmpty
                                ? profile.pharmacyName
                                : pharmacy.name,
                            'pharmacyId': profile.id.isNotEmpty
                                ? profile.id
                                : pharmacy.id,
                          },
                        );
                      },
                    ),

                    12.verticalSpace,

                    ActionButtonCard(
                      icon: SvgAssets.suggestIcon,
                      label: "Add Review",
                      color: ColorManager.gold,
                      onTap: () {
                        _showAddReviewDialog(context, profile.id);
                      },
                    ),

                    24.verticalSpace,

                    const SectionTitle(title: "Performance & Capacity"),

                    12.verticalSpace,

                    SizedBox(
                      height: 80.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          HorizontalInfoBadge(
                            icon: Icons.schedule_rounded,
                            title: "Opening Hours",
                            value: workingHoursText,
                            color: ColorManager.lightGreen,
                          ),
                          HorizontalInfoBadge(
                            icon: Icons.speed_rounded,
                            title: "Avg Delivery",
                            value: profile.deliveryTime.isNotEmpty
                                ? profile.deliveryTime
                                : pharmacy.deliveryTime,
                            color: ColorManager.primary,
                          ),
                          HorizontalInfoBadge(
                            icon: Icons.medication_rounded,
                            title: "Stock Database",
                            value:
                                "${profile.availableMedicinesCount} Products",
                            color: ColorManager.darkGray,
                          ),
                          HorizontalInfoBadge(
                            icon: Icons.star_rounded,
                            title: "Trust Score",
                            value:
                                "${profile.rating} (${profile.totalReviews} reviews)",
                            color: ColorManager.gold,
                          ),
                        ],
                      ),
                    ),

                    24.verticalSpace,

                    const SectionTitle(title: "Available Services"),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: premiumCardDecoration(),
                      child: Column(
                        children: [
                          if (profile.services.isNotEmpty)
                            ...profile.services.map((service) {
                              final isLast = profile.services.last == service;
                              return Column(
                                children: [
                                  ServiceRow(
                                    icon: Icons.check_circle_outline_rounded,
                                    title: service,
                                    description:
                                        "Available service at ${profile.pharmacyName}.",
                                    color: ColorManager.primary,
                                  ),
                                  if (!isLast) const Divider(height: 24),
                                ],
                              );
                            })
                          else ...[
                            const ServiceRow(
                              icon: Icons.local_shipping_rounded,
                              title: "Express Home Delivery",
                              description:
                                  "Get your prescription delivered safely to your door step.",
                              color: ColorManager.primary,
                            ),
                            const Divider(height: 24),
                            const ServiceRow(
                              icon: Icons.biotech_rounded,
                              title: "Prescription Preparation",
                              description:
                                  "Submit your Rx files and retrieve compound formula medicines.",
                              color: ColorManager.lightGreen,
                            ),
                            const Divider(height: 24),
                            const ServiceRow(
                              icon: Icons.health_and_safety_rounded,
                              title: "Medical Insurance Support",
                              description:
                                  "Covers multi-national governmental & corporate health cards.",
                              color: ColorManager.gold,
                            ),
                          ],
                        ],
                      ),
                    ),

                    24.verticalSpace,

                    InteractiveMapCard(
                      lat: profileLat,
                      lng: profileLng,
                      location: profile.addressText.isNotEmpty
                          ? profile.addressText
                          : pharmacy.location,
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext parentContext, String pharmacyId) {
    showDialog(
      context: parentContext,
      builder: (context) {
        int rating = 5;
        final commentController = TextEditingController();

        return BlocProvider(
          create: (_) => getIt<PharmacyReviewCubit>(),
          child: BlocConsumer<PharmacyReviewCubit, PharmacyReviewState>(
            listener: (context, state) {
              if (state is PharmacyReviewSuccess) {
                context.pop();
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text("Review added successfully!"),
                    backgroundColor: ColorManager.primary,
                  ),
                );
                parentContext.read<PharmacyProfileCubit>().getPharmacyProfile(
                  pharmacyId,
                );
              } else if (state is PharmacyReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: ColorManager.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Add Review"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final starRating = index + 1;
                            return IconButton(
                              icon: Icon(
                                starRating <= rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: ColorManager.gold,
                                size: 36,
                              ),
                              onPressed: () {
                                setState(() {
                                  rating = starRating;
                                });
                              },
                            );
                          }),
                        ),
                        16.verticalSpace,
                        TextField(
                          controller: commentController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Write your comment here...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: state is PharmacyReviewLoading
                            ? null
                            : () => context.pop(),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: state is PharmacyReviewLoading
                            ? null
                            : () {
                                context
                                    .read<PharmacyReviewCubit>()
                                    .addPharmacyReview(
                                      pharmacyId,
                                      rating,
                                      commentController.text.trim(),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                        ),
                        child: state is PharmacyReviewLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
