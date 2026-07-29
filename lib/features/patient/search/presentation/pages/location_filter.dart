import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/patient/profile/presentation/widgets/bottom_sheet.dart';
import 'package:chefaa/features/patient/search/domain/entities/clinic_model.dart';
import 'package:chefaa/features/patient/search/presentation/widgets/search_card.dart';
import 'package:go_router/go_router.dart';

class LocationFilter extends StatefulWidget {
  const LocationFilter({super.key});

  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  GoogleMapController? _mapController;
  BitmapDescriptor? customIcon;
  Set<Marker> markers = {};
  LatLng? _currentPosition;
  bool _isResolvingLocation = true;
  bool _canShowMyLocation = false;
  final TextEditingController _searchController = TextEditingController();
  static const LatLng _fallbackPosition = LatLng(30.0444, 31.2357);

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await loadMarker();
    await _resolveCurrentLocation();
  }

  void _searchLocation(String address) async {
    try {
      setState(() => _isResolvingLocation = true);
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        LatLng newPos = LatLng(locations[0].latitude, locations[0].longitude);

        setState(() {
          _currentPosition = newPos;
          _isResolvingLocation = false;
          markers = {
            Marker(
              markerId: const MarkerId("selected"),
              position: newPos,
              icon: customIcon ?? BitmapDescriptor.defaultMarker,
            ),
          };
        });

        await _moveCamera(newPos);
      }
    } catch (e) {
      setState(() => _isResolvingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No results found for this address")),
        );
      }
    }
  }

  Future<void> loadMarker() async {
    customIcon =
        await const Icon(
          Icons.location_on,
          color: ColorManager.primary,
          size: 50,
        ).toBitmapDescriptor(
          logicalSize: const Size(150, 150),
          imageSize: const Size(300, 300),
        );
    if (mounted) setState(() {});
  }

  Future<void> _resolveCurrentLocation() async {
    setState(() => _isResolvingLocation = true);
    final hasPermission = await _requestLocationPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!hasPermission || !serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _currentPosition ??= _fallbackPosition;
        _isResolvingLocation = false;
        _canShowMyLocation = false;
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final currentLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;
      setState(() {
        _currentPosition = currentLocation;
        _isResolvingLocation = false;
        _canShowMyLocation = true;
        markers = {
          Marker(
            markerId: const MarkerId('current-location'),
            position: currentLocation,
            icon: customIcon ?? BitmapDescriptor.defaultMarker,
          ),
        };
      });
      await _moveCamera(currentLocation);
    } catch (_) {
      if (mounted) setState(() => _isResolvingLocation = false);
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ),
    );
  }

  Future<bool> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) openAppSettings();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: _canShowMyLocation,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? _fallbackPosition,
                zoom: 14,
              ),
              markers: markers,
              onTap: (LatLng position) {
                setState(() {
                  _currentPosition = position;
                  markers = {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: position,
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                    ),
                  };
                });
              },
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: AppSize.s220.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorManager.white,
                    ColorManager.white.withValues(alpha: 0.92),
                    ColorManager.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Nearby",
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s20.sp,
                          color: ColorManager.black,
                        ),
                      ),
                      const Spacer(),
                      AppSize.s48.horizontalSpace,
                    ],
                  ),
                  AppSize.s12.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p8.w,
                      vertical: AppPadding.p6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(AppRadius.r18),
                      border: Border.all(
                        color: ColorManager.input.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withValues(alpha: 0.06),
                          blurRadius: AppSize.s14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        final query = value.trim();
                        if (query.isNotEmpty) _searchLocation(query);
                      },
                      decoration: InputDecoration(
                        hintText: "Search by area, street, or landmark",
                        hintStyle: getRegularStyle(
                          color: ColorManager.gray,
                          fontSize: FontSize.s14.sp,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: ColorManager.gray,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            final query = _searchController.text.trim();
                            if (query.isEmpty) {
                              _searchController.clear();
                              return;
                            }
                            _searchLocation(query);
                          },
                          icon: const Icon(
                            Icons.north_east,
                            color: ColorManager.primary,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppPadding.p14.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isResolvingLocation)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),

          Positioned(
            bottom: 0.32.sh,
            right: AppPadding.p16.w,
            child: FloatingActionButton(
              heroTag: "my_location_btn",
              mini: true,
              backgroundColor: ColorManager.white,
              elevation: AppSize.s4,
              onPressed: _resolveCurrentLocation,
              child: const Icon(Icons.my_location, color: ColorManager.primary),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProfileBottomSheet(
              heightFactor: 0.3.sh,
              content: SearchCard(
                clinicModel: ClinicModel(
                  doctorName: "Dr. Ahmed",
                  doctorSpecialty: "Cardiology",
                  doctorRating: "4.8",
                  doctorRatingCount: "120",
                  clinicPrice: "500",
                  availableDays: [DateTime.now()],
                  clinicId: "1",
                  clinicName: "Main Clinic",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
