import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleNavigationService {
  final BuildContext context;

  RoleNavigationService(this.context);

  void toLayout(String? role) {
    final route = _getLayoutRoute(role);
    context.go(route);
  }

  void toSignUp(String? role) {
    final navigationData = _getSignUpRoute(role);
    if (navigationData.route != null) {
      context.pushReplacement(navigationData.route!, extra: navigationData.arguments,
      );
    }
  }

  void toLogin(String? role) {
    context.push(AppRoutesNames.login, extra: role);
  }

  String _getLayoutRoute(String? role) {
    return AppConstants.getLayoutFromRole(role);
  }

  ({String? route, dynamic arguments}) _getSignUpRoute(String? role) {
    switch (role) {
      case "patient":
        return (
          route: AppRoutesNames.patientSignUp,
          arguments: AppConstants.patient.toLowerCase(),
        );
      case "doctor":
        return (route: AppRoutesNames.docSignUp, arguments: null);
      case "pharmacy":
        return (route: AppRoutesNames.pharmacySignUp, arguments: null);
      case "facility":
        return (route: AppRoutesNames.facilitySignUp, arguments: null);
      default:
        return (route: AppRoutesNames.option, arguments: null);
    }
  }
}
