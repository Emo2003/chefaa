import 'dart:async';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/features/patient/lab_search/data/models/search_centers_response.dart';
import 'package:chefaa/features/patient/lab_search/presentation/manager/lab_search_cubit.dart';
import 'package:chefaa/features/patient/lab_search/presentation/manager/lab_search_state.dart';
import 'package:chefaa/features/patient/lab_search/presentation/widgets/center_recommendation_card.dart';
import 'package:chefaa/features/patient/lab_search/presentation/widgets/filter_chip_item.dart';
import 'package:chefaa/features/patient/lab_search/presentation/widgets/lab_details_bottom_sheet.dart';

class FindLabPage extends StatelessWidget {
  const FindLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LabSearchCubit>()..searchCenters(),
      child: const _FindLabView(),
    );
  }
}

class _FindLabView extends StatefulWidget {
  const _FindLabView();

  @override
  State<_FindLabView> createState() => _FindLabViewState();
}

class _FindLabViewState extends State<_FindLabView> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  Timer? _debounce;

  GoogleMapController? _mapController;
  final bool _canShowMyLocation = true;
  LatLng? _currentPosition;
  final LatLng _fallbackPosition = const LatLng(29.9602, 31.2569);
  Set<Marker> _markers = {};
  BitmapDescriptor? _customIcon;

  final List<String> _filters = ["All", "Lab only", "Radiology", "Home scan"];

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _triggerSearch();
    });
  }

  void _triggerSearch() {
    context.read<LabSearchCubit>().searchCenters(
      requiredServices: _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null,
      homeService: _selectedFilterIndex == 3 ? true : null,
    );
  }

  List<CenterModel> _getFilteredCenters(List<CenterModel> originalCenters) {
    var list = originalCenters;
    if (_selectedFilterIndex == 1) {
      list = list.where((c) => c.facilityType?.toLowerCase() == 'lab').toList();
    } else if (_selectedFilterIndex == 2) {
      list = list
          .where(
            (c) =>
                c.facilityType?.toLowerCase() == 'scan' ||
                c.facilityType?.toLowerCase() == 'both',
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize:  Size.fromHeight(100),
        child: InsideAppBar(title: "Find Lab"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p20.w,
              vertical: AppPadding.p16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                CustomTextField(
                  controller: _searchController,
                  text: "Search labs, radiology, or services...",
                  prefixIcon: IconsAssets.searchIcon,
                  isSearch: true,
                  onChanged: _onSearchChanged,
                ),
                20.verticalSpace,
                _buildFilterList(),
                20.verticalSpace,
                BlocBuilder<LabSearchCubit, LabSearchState>(
                  builder: (context, state) {
                    List<CenterModel> centers = [];
                    bool isLoading = false;
                    String? error;

                    if (state is LabSearchLoading) {
                      isLoading = true;
                    } else if (state is LabSearchSuccess) {
                      centers = _getFilteredCenters(
                        state.response.centers ?? [],
                      );
                    } else if (state is LabSearchError) {
                      error = state.error;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMapSection(centers.length),
                        24.verticalSpace,
                        _buildSectionHeader(),
                        16.verticalSpace,
                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (error != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: ColorManager.error,
                                  ),
                                  16.verticalSpace,
                                  Text(error, textAlign: TextAlign.center),
                                  16.verticalSpace,
                                  ElevatedButton(
                                    onPressed: _triggerSearch,
                                    child: const Text("Try Again"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (centers.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                "No centers found",
                                style: getMediumStyle(
                                  color: ColorManager.gray,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          )
                        else
                          _buildRecommendedList(centers),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildHeader(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       InkWell(
  //         onTap: () => context.pop(),
  //         borderRadius: BorderRadius.circular(AppRadius.r20.r),
  //         child: Container(
  //           width: 40.w,
  //           height: 40.w,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha: 0.08),
  //                 blurRadius: 6,
  //                 offset: const Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //           child: Icon(
  //             Icons.arrow_back,
  //             color: ColorManager.black,
  //             size: 20.sp,
  //           ),
  //         ),
  //       ),
  //       IconButton(
  //         onPressed: () {},
  //         icon: SvgPicture.asset(
  //           IconsAssets.notification,
  //           width: 24.w,
  //           height: 24.h,
  //           colorFilter: const ColorFilter.mode(
  //             ColorManager.darkGray,
  //             BlendMode.srcIn,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFilterList() {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          return FilterChipItem(
            label: _filters[index],
            isSelected: _selectedFilterIndex == index,
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
              _triggerSearch();
            },
          );
        },
      ),
    );
  }

  Widget _buildMapSection(int centersCount) {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.input, width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: _canShowMyLocation,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? _fallbackPosition,
              zoom: 14,
            ),
            markers: _markers,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onTap: (LatLng position) {
              setState(() {
                _currentPosition = position;
                _markers = {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: position,
                    icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                  ),
                };
              });
              _mapController?.animateCamera(CameraUpdate.newLatLng(position));
            },
          ),
          PositionedDirectional(
            bottom: 12.h,
            start: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: ColorManager.input, width: 1.w),
              ),
              child: Text(
                "$centersCount Centers found in Maadi",
                style: getMediumStyle(
                  color: ColorManager.black,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "AI Recommended",
          style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
        ),
        Text(
          "Sort by: Relevance",
          style: getSemiBoldStyle(color: ColorManager.primary, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildRecommendedList(List<CenterModel> centers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: centers.length,
      itemBuilder: (context, index) {
        return CenterRecommendationCard(
          centerData: centers[index],
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => LabDetailsBottomSheet(
                centerData: centers[index],
              ),
            );
          },
        );
      },
    );
  }
}
