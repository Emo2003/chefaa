import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/services/storage_service.dart';
import 'package:chefaa/features/patient/home/presentation/manager/users_cubit.dart';
import 'package:chefaa/features/patient/medication/presentation/manager/medication_cubit.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/values_manager.dart';
import '../../../../../core/widgets/custom_circle_avatar.dart';
import '../../data/models/profile_response.dart';
import '../manager/profile_cubit.dart';
import '../widgets/appointment_card.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/edit_medical_information.dart';
import '../widgets/edit_user_details.dart';
import '../widgets/item_column.dart';
import '../widgets/item_container.dart';
import '../widgets/item_content.dart';
import '../widgets/location_helper.dart';
import 'package:go_router/go_router.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = getIt<ProfileCubit>()..getProfileData();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(170),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorManager.primary,
                shadowColor: ColorManager.black.withValues(alpha: .25),
                elevation: 15,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomCircleAvatar(
                        imagePath: ImageAssets.patient,
                        radius: 50,
                      ),
                      Text(
                        StorageService.user?.name ?? "user name",
                        style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s20.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: REdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    16.verticalSpace,
                    _buildSectionTitle("Personal info."),
                    16.verticalSpace,
                    ItemContainer(
                      child: Column(
                        children: [
                          ItemContent(
                            image: "assets/svg_images/person.svg",
                            widget: const ItemColumn(
                              text: "Basic Details",
                              subText: "Name, Gender, DOB,\n Weight, Height",
                            ),
                            onTap: () => ProfileBottomSheet.show(
                              context,
                              BlocProvider.value(
                                value: context.read<ProfileCubit>(),
                                child: const EditUserDetails(),
                              ),
                            ),
                          ),
                          const Divider(
                            color: ColorManager.input,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("Location"),
                              const SizedBox(height: 16),

                              BlocConsumer<ProfileCubit, ProfileState>(
                                listener: (context, state) {
                                  if (state is GetProfileDataSuccessState) {
                                    final profile =
                                        state.profileData as ProfileResponse;

                                    final address =
                                        profile.address?.addressText ?? "";

                                    if (address.isEmpty) {
                                      Future.microtask(() {
                                        if (!context.mounted) return;
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text(
                                              "Location Required",
                                            ),
                                            content: const Text(
                                              "Please add your location to continue.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  context.pop();
                                                  LocationHelper.getCurrentLocation(
                                                    context,
                                                  );
                                                },
                                                child: const Text(
                                                  "Add Location",
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  final cubit = context.read<ProfileCubit>();

                                  if (state is GetProfileDataSuccessState) {
                                    final profile =
                                        state.profileData as ProfileResponse;

                                    cubit.locationController.text =
                                        profile.address?.addressText ?? "";

                                    cubit.latitude = profile.address?.latitude;
                                    cubit.longitude =
                                        profile.address?.longitude;
                                  }

                                  return InkWell(
                                    onTap: () =>
                                        LocationHelper.getCurrentLocation(
                                          context,
                                        ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              cubit
                                                      .locationController
                                                      .text
                                                      .isEmpty
                                                  ? "Tap to choose your location"
                                                  : cubit
                                                        .locationController
                                                        .text,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Divider(
                            color: ColorManager.input,
                            thickness: 1,
                          ),
                          ItemContent(
                            image: "assets/svg_images/love.svg",
                            widget: const ItemColumn(
                              text: "Medical Info.",
                              subText:
                                  "Blood type, Allergies,\n chronic conditions",
                            ),
                            onTap: () => ProfileBottomSheet.show(
                              context,
                              BlocProvider.value(
                                value: context.read<ProfileCubit>(),
                                child: const EditMedicalInformation(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.verticalSpace,
                    _buildSectionTitle("Payments"),
                    16.verticalSpace,
                    ItemContainer(
                      child: ItemContent(
                        image: "assets/svg_images/wallet.svg",
                        text: "Payments History",
                        onTap: () => ProfileBottomSheet.show(
                          context,
                          const AppointmentCard(),
                          // const Column(
                        ),
                      ),
                    ),
                    32.verticalSpace,
                    _buildSectionTitle("Language"),
                    16.verticalSpace,
                    ItemContainer(
                      child: ItemContent(
                        image: "assets/svg_images/earth.svg",
                        text: "English",
                        onTap: () {},
                      ),
                    ),
                    32.verticalSpace,
                    const VersionContainer(),
                    32.verticalSpace,
                    const LogOutBtn(),
                    24.verticalSpace,
                    const DeleteAccount(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: getBoldStyle(
          color: ColorManager.black,
          fontSize: FontSize.s20.sp,
        ),
      ),
    );
  }
}

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Delete account",
      style: getSemiBoldStyle(
        color: ColorManager.error,
        fontSize: FontSize.s16,
      ),
    );
  }
}

class LogOutBtn extends StatelessWidget {
  const LogOutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await StorageService.clearAll();
        if (context.mounted) {
          await context.read<UsersCubit>().logout();
        }
        if (context.mounted) {
          context.read<MedicationCubit>().reset();
        }
        if (context.mounted) {
          context.go(AppRoutesNames.login,
          );
        }
      },
      child: ItemContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg_images/Logout.svg",
              colorFilter: const ColorFilter.mode(
                ColorManager.error,
                BlendMode.srcIn,
              ),
            ),
            24.horizontalSpace,
            Text(
              "Logout",
              style: getSemiBoldStyle(
                color: ColorManager.error,
                fontSize: FontSize.s20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VersionContainer extends StatelessWidget {
  const VersionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ItemContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 23, vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version',
                  style: getSemiBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16.sp,
                  ),
                ),
                Text(
                  '1.0.0',
                  style: getMediumStyle(
                    color: ColorManager.gray,
                    fontSize: FontSize.s12.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ColorManager.input, height: 1.h, thickness: 1),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 23, vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms and Privacy',
                  style: getSemiBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16.sp,
                  ),
                ),
                Text(
                  'View',
                  style:
                      getMediumStyle(
                        color: ColorManager.primary,
                        fontSize: FontSize.s12.sp,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorManager.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> getCurrentLocation(BuildContext context) async {
  final cubit = context.read<ProfileCubit>();

  try {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String address = "";

    if (places.isNotEmpty) {
      final p = places.first;
      String street = p.street ?? "";

      if (street.contains("+")) {
        street = "";
      }
      address = [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].where((e) => e != null && e.trim().isNotEmpty).join(", ");
    }

    cubit.setLocation(
      addressText: address,
      lat: position.latitude,
      lng: position.longitude,
    );

    await cubit.updateProfileData();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location saved successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}
