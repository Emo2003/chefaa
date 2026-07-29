import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/widgets/error_page.dart';
import 'package:chefaa/features/auth/presentation/pages/forget_password_page.dart';
import 'package:chefaa/features/auth/presentation/pages/login_page.dart';
import 'package:chefaa/features/auth/presentation/pages/reset_code_page.dart';
import 'package:chefaa/features/doctor/auth/presentation/pages/doctor_sign_up_page.dart';
import 'package:chefaa/features/doctor/home/presentation/pages/clinic_details_page.dart';
import 'package:chefaa/features/doctor/home/presentation/pages/clinics_page.dart';
import 'package:chefaa/features/doctor/layout/doctor_layout.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/pages/patient_details.dart';
import 'package:chefaa/features/doctor/profile/presentation/manager/doctor_profile_cubit.dart';
import 'package:chefaa/features/doctor/profile/presentation/pages/edit_profile_page.dart';
import 'package:chefaa/features/entry/presentation/pages/chefaa_entry_page.dart';
import 'package:chefaa/features/facility/auth/presentation/pages/facility_sign_up_page.dart';
import 'package:chefaa/features/facility/dashboard/presentation/pages/create_patient_request_page.dart';
import 'package:chefaa/features/facility/dashboard/presentation/pages/facility_results_page.dart';
import 'package:chefaa/features/facility/layout/presentation/pages/facility_layout_page.dart';
import 'package:chefaa/features/onboarding/presentation/pages/facility_option.dart';
import 'package:chefaa/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:chefaa/features/onboarding/presentation/pages/option_screen.dart';
import 'package:chefaa/features/patient/ai_lab/data/models/report_analysis.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/pages/ai_lab_analysis.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/pages/history_report_page.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/pages/report_details_page.dart';
import 'package:chefaa/features/patient/appointment/presentation/pages/appointment_page.dart';
import 'package:chefaa/features/patient/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:chefaa/features/patient/booking/presentation/pages/choose_doctor_page.dart';
import 'package:chefaa/features/patient/cart/presentation/pages/cart_page.dart';
import 'package:chefaa/features/patient/checkout_order/presentation/pages/checkout_page.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/manager/complete_cubit.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/pages/first_complete_page.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/pages/last_complete_data.dart';
import 'package:chefaa/features/patient/complete_auth_data/presentation/pages/second_complete_page.dart';
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_cubit.dart';
import 'package:chefaa/features/patient/lab_results/presentation/pages/lab_results_page.dart';
import 'package:chefaa/features/patient/lab_search/presentation/pages/find_lab_page.dart';
import 'package:chefaa/features/patient/layout/presentation/pages/patient_layout.dart';
import 'package:chefaa/features/patient/medication/presentation/pages/medication_page.dart';
import 'package:chefaa/features/patient/notification/presentation/manager/patient_notification_cubit.dart';
import 'package:chefaa/features/patient/notification/presentation/pages/patient_notification_page.dart';
import 'package:chefaa/features/patient/order/presentation/pages/orders_list_page.dart';
import 'package:chefaa/features/patient/order/presentation/pages/track_order_page.dart';
import 'package:chefaa/features/patient/payment/presentation/pages/payment_page.dart';
import 'package:chefaa/features/patient/pharmacy/medicines/presentation/pages/medicine_details_page.dart';
import 'package:chefaa/features/patient/pharmacy/medicines/presentation/pages/pharmacy_medicines_page.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/models/pharmacy_card_model.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/pages/pharmacy_details_page.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/pages/pharmacy_layout.dart'
as p_layout;
import 'package:chefaa/features/patient/search/presentation/manager/search_cubit.dart';
import 'package:chefaa/features/patient/search/presentation/pages/location_filter.dart';
import 'package:chefaa/features/patient/search/presentation/pages/search_page.dart';
import 'package:chefaa/features/patient/search/presentation/pages/speciality_page.dart';
import 'package:chefaa/features/pharmacy/auth/presentation/pages/pharmacy_sign_up_page.dart';
import 'package:chefaa/features/pharmacy/inventory/presentation/pages/add_medicine_page.dart';
import 'package:chefaa/features/pharmacy/layout/presentation/pages/pharmacy_layout.dart';
import 'package:chefaa/features/pharmacy/profile/data/models/pharmacy_profile_response.dart';
import 'package:chefaa/features/pharmacy/profile/presentation/manager/pharmacy_profile_cubit.dart';
import 'package:chefaa/features/pharmacy/profile/presentation/pages/edit_pharmacy_profile_page.dart';
import 'package:chefaa/features/pharmacy/settings/presentation/pages/pharmacy_settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/reset_password_page.dart';

import '../widgets/map_picker.dart';
import 'app_routes_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutesNames.appEntryRoute,
    errorBuilder: (context, state) =>
        const ErrorPage(message: '404 Route Not Found'),
    routes: [
      GoRoute(
        path: AppRoutesNames.login,
        builder: (context, state) {
          final role = state.extra as String?;
          return LoginPage(role: role);
        },
      ),
      GoRoute(
        path: AppRoutesNames.onboardingRoute,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutesNames.clinicsPage,
        builder: (context, state) => const ClinicsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.clinicsDetailsPage,
        builder: (context, state) {
          final clinic = state.extra;
          if (clinic == null) {
            return const ErrorPage(
              message: 'Missing/invalid route argument: clinic',
            );
          }
          return const ClinicDetailsPage();
        },
      ),
      GoRoute(
        path: AppRoutesNames.searchPharmacy,
        builder: (context, state) => const p_layout.MainLayout(),
      ),
      GoRoute(
        path: AppRoutesNames.option,
        builder: (context, state) => const OptionScreen(),
      ),
      GoRoute(
        path: AppRoutesNames.checkoutPage,
        builder: (context, state) {
          final checkoutArgs = state.extra as Map<String, dynamic>?;
          return CheckoutPage(
            pharmacyId: checkoutArgs?['pharmacyId'] as String?,
            items: List<Map<String, dynamic>>.from(
              checkoutArgs?['items'] ?? [],
            ),
            subtotal: (checkoutArgs?['subtotal'] as num?)?.toDouble(),
            deliveryFee: (checkoutArgs?['deliveryFee'] as num?)?.toDouble(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.paymentPage,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          final args = state.extra as Map<String, dynamic>?;
          return PaymentPage(
            orderId: orderId ?? "",
            subtotal: (args?['subtotal'] as num?)?.toDouble() ?? 0.0,
            deliveryFee: (args?['deliveryFee'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.trackOrderPage,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          return TrackOrderPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutesNames.ordersListPage,
        builder: (context, state) => const OrdersListPage(),
      ),
      GoRoute(
        path: AppRoutesNames.appEntryRoute,
        builder: (context, state) => const ChefaaEntryPage(),
      ),
      GoRoute(
        path: AppRoutesNames.docSignUp,
        builder: (context, state) => const DocSignUp(),
      ),
      GoRoute(
        path: AppRoutesNames.facilitySignUp,
        builder: (context, state) => const FacilitySignup(),
      ),
      GoRoute(
        path: AppRoutesNames.facilityOption,
        builder: (context, state) => const FacilityOptionScreen(),
      ),
      GoRoute(
        path: AppRoutesNames.patientSignUp,
        builder: (context, state) {
          final role = state.pathParameters['role'];
          if (role == null) {
            return const ErrorPage(
              message: 'Missing/invalid route argument: role',
            );
          }
          return PatientSignUpPage(role: role);
        },
      ),

      // ----------------------------------------------------
      // COMPLETE WIZARD FLOW (SHELL ROUTE FOR CUBIT SHARING)
      // ----------------------------------------------------
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => getIt<CompleteCubit>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutesNames.patientSignUpCompleteData,
            builder: (context, state) => const FirstCompletePage(),
          ),
          GoRoute(
            path: AppRoutesNames.patientSignUpCompleteChronicDiseases,
            builder: (context, state) => const SecondCompletePage(),
          ),
          GoRoute(
            path: AppRoutesNames.patientSignUpCompleteMedicines,
            builder: (context, state) => const LastCompleteData(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutesNames.resetCode,
        builder: (context, state) {
          final indexStr = state.pathParameters['index'];
          final index = int.tryParse(indexStr ?? '');
          if (index == null) {
            return const ErrorPage(
              message: 'Missing/invalid route argument: index',
            );
          }
          return ResetCode(index: index);
        },
      ),
      GoRoute(
        path: AppRoutesNames.resetPassword,
        builder: (context, state) => const ResetPassword(),
      ),
      GoRoute(
        path: AppRoutesNames.historyReportPage,
        builder: (context, state) => const ReportsHistoryPage(),
      ),
      GoRoute(
        path: AppRoutesNames.pharmacySignUp,
        builder: (context, state) => const PharmacySignUpPage(),
      ),
      GoRoute(
        path: AppRoutesNames.forgetPassword,
        builder: (context, state) => const ForgetPassword(),
      ),
      GoRoute(
        path: AppRoutesNames.aiLabAnalysis,
        builder: (context, state) => const AILabAnalysis(),
      ),
      GoRoute(
        path: AppRoutesNames.appointmentPage,
        builder: (context, state) => const AppointmentPage(),
      ),
      GoRoute(
        path: AppRoutesNames.specialityPage,
        builder: (context, state) => const SpecialityPage(),
      ),
      GoRoute(
        path: AppRoutesNames.patientSearch,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SearchCubit>(),
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.medicationPage,
        builder: (context, state) => const MedicationPage(),
      ),
      GoRoute(
        path: AppRoutesNames.findLabPage,
        builder: (context, state) => const FindLabPage(),
      ),
      GoRoute(
        path: AppRoutesNames.patientDetailsPage,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<PatientsCubit>(),
          child: const PatientDetailsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.facilityResults,
        builder: (context, state) => const FacilityResultsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.createPatientRequest,
        builder: (context, state) => const CreatePatientRequestPage(),
      ),
      GoRoute(
        path: AppRoutesNames.chooseDoctor,
        builder: (context, state) => const ChooseDoctor(),
      ),
      GoRoute(
        path: AppRoutesNames.locationFilter,
        builder: (context, state) => const LocationFilter(),
      ),
      GoRoute(
        path: AppRoutesNames.labResultsPage,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LabResultsCubit>(),
          child: const LabResultsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.editPharmacyProfile,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final profileData = args?['profileData'] as PharmacyProfileData?;
          return BlocProvider(
            create: (_) => getIt<PharmacyProfileCubit>(),
            child: EditPharmacyProfilePage(profileData: profileData),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.pharmacySettings,
        builder: (context, state) => const PharmacySettingsPage(),
      ),
      GoRoute(
        path: AppRoutesNames.addMedicine,
        builder: (context, state) => const AddMedicinePage(),
      ),
      GoRoute(
        path: AppRoutesNames.reportDetails,
        builder: (context, state) {
          final report = state.extra;
          if (report is! ReportAnalysis) {
            return const ErrorPage(
              message: 'Missing/invalid route argument: report',
            );
          }
          return ReportDetailsPage(report: report);
        },
      ),
      GoRoute(
        path: AppRoutesNames.patientNotification,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<PatientNotificationCubit>(),
          child: const PatientNotificationPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesNames.pharmacyDetails,
        builder: (context, state) {
          final pharmacy = state.extra;
          if (pharmacy is! PharmacyCardModel) {
            return const ErrorPage(
              message: 'Missing/invalid route argument: pharmacy',
            );
          }
          return PharmacyDetailsPage(pharmacy: pharmacy);
        },
      ),
      GoRoute(
        path: AppRoutesNames.medicineDetails,
        builder: (context, state) {
          final medicineId = state.pathParameters['medicineId'];
          final args = state.extra as Map<String, dynamic>?;
          return MedicineDetailsPage(
            name: args?['name'] as String? ?? '',
            activeIngredient: args?['activeIngredient'] as String? ?? '',
            price: args?['price'] as String? ?? '0',
            medicineId: medicineId ?? '',
            pharmacyId:
                state.pathParameters['pharmacyId'] ??
                args?['pharmacyId'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.cart,
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: AppRoutesNames.editDoctorProfile,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final doctorData = args?['doctorData'];
          return BlocProvider(
            create: (_) => getIt<DoctorProfileCubit>(),
            child: EditProfilePage(doctorData: doctorData),
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.mapPicker,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return MapPicker(
            initialLatitude: args?['initialLatitude'] as double?,
            initialLongitude: args?['initialLongitude'] as double?,
            initialAddress: args?['initialAddress'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutesNames.pharmacyMedicines,
        builder: (context, state) {
          final pharmacyId = state.pathParameters['pharmacyId'];
          final args = state.extra as Map<String, dynamic>?;
          return PharmacyMedicinesPage(
            pharmacyName: args?['pharmacyName'] ?? '',
            pharmacyId: pharmacyId ?? '',
          );
        },
      ),

      GoRoute(
        path: AppRoutesNames.patientLayout,
        builder: (context, state) => const PatientLayout(),
      ),
      GoRoute(
        path: AppRoutesNames.doctorLayout,
        builder: (context, state) => const DoctorLayout(),
      ),
      GoRoute(
        path: AppRoutesNames.pharmacyLayout,
        builder: (context, state) => const PharmacyLayout(),
      ),
      GoRoute(
        path: AppRoutesNames.facilityLayout,
        builder: (context, state) => const FacilityLayout(),
      ),
    ],
  );
}
