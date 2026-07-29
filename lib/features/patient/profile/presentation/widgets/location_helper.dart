import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../manager/profile_cubit.dart';
import 'package:go_router/go_router.dart';

class LocationHelper {
  static Future<void> getCurrentLocation(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission denied"),
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();

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
          street,
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
        const SnackBar(
          content: Text("Location saved successfully"),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
  static Future<void> showLocationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text(
          "Please allow your location to continue.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              context.pop();

              await getCurrentLocation(context);
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}