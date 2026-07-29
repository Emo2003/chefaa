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
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:go_router/go_router.dart';

class MapPickerResult {
  final String address;
  final double latitude;
  final double longitude;
  final String? city;

  MapPickerResult({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.city,
  });
}

class MapPicker extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const MapPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _customIcon;
  Set<Marker> _markers = {};
  LatLng? _selectedPosition;
  String _selectedAddress = "";
  String? _selectedCity;
  bool _isResolving = false;
  bool _canShowMyLocation = false;

  final TextEditingController _searchController = TextEditingController();
  static const LatLng _fallbackPosition = LatLng(30.0444, 31.2357); // Cairo fallback

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeMapPicker();
  }

  Future<void> _initializeMapPicker() async {
    await _loadMarkerIcon();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      final pos = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      setState(() {
        _selectedPosition = pos;
        _selectedAddress = widget.initialAddress ?? "";
        _markers = {
          Marker(
            markerId: const MarkerId("selected"),
            position: pos,
            icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          ),
        };
      });
      // Try to reverse geocode if address is not supplied
      if (_selectedAddress.isEmpty) {
        await _reverseGeocode(pos);
      }
    } else {
      await _resolveCurrentLocation();
    }
  }

  Future<void> _loadMarkerIcon() async {
    _customIcon = await const Icon(
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
    setState(() => _isResolving = true);
    final hasPermission = await _requestLocationPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!hasPermission || !serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _selectedPosition ??= _fallbackPosition;
        _isResolving = false;
        _canShowMyLocation = false;
        _markers = {
          Marker(
            markerId: const MarkerId("selected"),
            position: _fallbackPosition,
            icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          ),
        };
      });
      await _reverseGeocode(_fallbackPosition);
      await _moveCamera(_fallbackPosition);
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
        _selectedPosition = currentLocation;
        _isResolving = false;
        _canShowMyLocation = true;
        _markers = {
          Marker(
            markerId: const MarkerId('selected'),
            position: currentLocation,
            icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          ),
        };
      });
      await _reverseGeocode(currentLocation);
      await _moveCamera(currentLocation);
    } catch (_) {
      if (mounted) {
        setState(() => _isResolving = false);
        // Fallback
        final pos = _selectedPosition ?? _fallbackPosition;
        await _reverseGeocode(pos);
        await _moveCamera(pos);
      }
    }
  }

  Future<void> _reverseGeocode(LatLng position) async {
    setState(() => _isResolving = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        String street = p.street ?? "";
        if (street.contains("+")) {
          street = "";
        }
        final address = [
          street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((e) => e != null && e.trim().isNotEmpty).join(", ");
        final city = p.locality ?? p.subAdministrativeArea ?? p.administrativeArea ?? "";
        
        setState(() {
          _selectedAddress = address;
          _selectedCity = city;
          _isResolving = false;
        });
      } else {
        setState(() {
          _selectedAddress = "Unknown Location";
          _selectedCity = "";
          _isResolving = false;
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Location at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        _selectedCity = "";
        _isResolving = false;
      });
    }
  }

  Future<void> _searchLocation(String address) async {
    if (address.isEmpty) return;
    setState(() => _isResolving = true);
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        LatLng newPos = LatLng(locations[0].latitude, locations[0].longitude);

        setState(() {
          _selectedPosition = newPos;
          _markers = {
            Marker(
              markerId: const MarkerId("selected"),
              position: newPos,
              icon: _customIcon ?? BitmapDescriptor.defaultMarker,
            ),
          };
        });

        await _moveCamera(newPos);
        await _reverseGeocode(newPos);
      }
    } catch (e) {
      setState(() => _isResolving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No results found for this address")),
        );
      }
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16),
      ),
    );
  }

  Future<bool> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) openAppSettings();
    return false;
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId("selected"),
          position: position,
          icon: _customIcon ?? BitmapDescriptor.defaultMarker,
        ),
      };
    });
    await _reverseGeocode(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(title: "Select Location"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: _canShowMyLocation,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _selectedPosition ?? _fallbackPosition,
                zoom: 15,
              ),
              markers: _markers,
              onTap: _onMapTapped,
            ),
          ),

          // Search Field Floating
          Positioned(
            top: 20.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p8.w,
                vertical: AppPadding.p2.h,
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
                      if (query.isNotEmpty) {
                        _searchLocation(query);
                      }
                    },
                    icon: const Icon(
                      Icons.search,
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
          ),

          // My Location Button
          Positioned(
            bottom: 220.h,
            right: AppPadding.p16.w,
            child: FloatingActionButton(
              heroTag: "map_picker_my_location",
              mini: true,
              backgroundColor: ColorManager.white,
              elevation: AppSize.s4,
              onPressed: _resolveCurrentLocation,
              child: const Icon(Icons.my_location, color: ColorManager.primary),
            ),
          ),

          // Bottom Confirmation Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(AppPadding.p20.r),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.r24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.black.withValues(alpha: 0.1),
                    blurRadius: AppSize.s14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: ColorManager.primary,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          "Selected Address",
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  _isResolving
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(
                              color: ColorManager.primary,
                            ),
                          ),
                        )
                      : Text(
                          _selectedAddress.isEmpty
                              ? "Tap on the map or search to select a location"
                              : _selectedAddress,
                          style: getRegularStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s14.sp,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                  20.verticalSpace,
                  CustomBtn(
                    text: "Confirm Location",
                    isDisabled: _selectedPosition == null || _isResolving,
                    onPressed: () {
                      if (_selectedPosition != null) {
                        context.pop(MapPickerResult(
                            address: _selectedAddress,
                            latitude: _selectedPosition!.latitude,
                            longitude: _selectedPosition!.longitude,
                            city: _selectedCity,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
