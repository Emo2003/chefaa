import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/services/storage_service.dart';
import 'package:chefaa/core/widgets/custom_app_bar.dart';
import 'package:chefaa/features/facility/profile/presentation/manager/facility_profile_cubit.dart';
import 'package:chefaa/features/facility/profile/presentation/widgets/facility_info_section.dart';
import 'package:chefaa/features/facility/profile/presentation/widgets/facility_profile_header_section.dart';
import 'package:chefaa/features/facility/profile/presentation/widgets/location_section.dart';
import 'package:chefaa/features/facility/profile/presentation/widgets/profile_stats_section.dart';
import 'package:chefaa/features/facility/profile/presentation/widgets/update_profile_bottom_sheet.dart';
import 'package:chefaa/features/patient/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FacilityProfilePage extends StatefulWidget {
  const FacilityProfilePage({super.key});

  @override
  State<FacilityProfilePage> createState() => _FacilityProfilePageState();
}

class _FacilityProfilePageState extends State<FacilityProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = StorageService.user;
    return BlocProvider(
      create: (context) => getIt<FacilityProfileCubit>()..getProfile(),
      child: Scaffold(
        backgroundColor: ColorManager.lightGray,
        appBar: CustomAppBar(
          preferredHeight: AppSize.s140.h,
          borderRadiusValue: AppRadius.r24.r,
          padding: EdgeInsets.zero,
          child: BlocBuilder<FacilityProfileCubit, FacilityProfileState>(
            builder: (context, state) {
              final profileData = context
                  .read<FacilityProfileCubit>()
                  .profileData;
              final chips = <String>[];
              if (profileData != null) {
                if (profileData.facilityType != null) {
                  chips.add(profileData.facilityType!.toUpperCase());
                }
                if (profileData.settings?.homeSampleCollection == true) {
                  chips.add('Home service');
                }
              } else {
                chips.addAll(['Lab', 'Radiology', 'Home service']);
              }

              return FacilityProfileHeaderSection(
                title:
                    profileData?.name ?? user?.name ?? 'Cairo MRI & Lab Center',
                location: (profileData?.addresses?.isNotEmpty == true)
                    ? (profileData!.addresses!.first.addressText ?? '')
                    : 'Maadi, Cairo, Egypt',
                chips: chips,
                onEditPressed: () {
                  showUpdateProfileBottomSheet(context);
                },
              );
            },
          ),
        ),
        body: SafeArea(
          child: BlocListener<FacilityProfileCubit, FacilityProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  ),
                );
              } else if (state is UpdateProfileSuccess) {
                if (context.canPop()) context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully.'),
                    backgroundColor: ColorManager.primary,
                  ),
                );
              } else if (state is UpdateProfileFailure) {
                if (context.canPop()) context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<FacilityProfileCubit, FacilityProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    ),
                  );
                } else if (state is GetProfileFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        state.errorMessage,
                        style: getRegularStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                final profileData = context
                    .read<FacilityProfileCubit>()
                    .profileData;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p24.w,
                      vertical: AppPadding.p12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSize.s24.h),
                        ProfileStatsSection(
                          rating: profileData?.rating,
                          servicesCount: profileData?.servicesCount,
                        ),
                        SizedBox(height: AppSize.s24.h),
                        LocationSection(addresses: profileData?.addresses),
                        SizedBox(height: AppSize.s20.h),
                        FacilityInfoSection(profileData: profileData),
                        SizedBox(height: AppSize.s24.h),
                        const LogOutBtn(),
                        SizedBox(height: AppSize.s24.h),
                      ],
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
