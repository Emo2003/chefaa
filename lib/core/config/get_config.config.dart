// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chefaa/core/services/network_service.dart' as _i492;
import 'package:chefaa/features/auth/data/data_sources/data_source.dart'
    as _i970;
import 'package:chefaa/features/auth/data/data_sources/data_source_imp.dart'
    as _i617;
import 'package:chefaa/features/auth/data/repositories/repo_imp.dart' as _i479;
import 'package:chefaa/features/auth/domain/repositories/repo.dart' as _i116;
import 'package:chefaa/features/auth/presentation/manager/auth_cubit.dart'
    as _i1019;
import 'package:chefaa/features/doctor/auth/data/data_sources/data_source.dart'
    as _i480;
import 'package:chefaa/features/doctor/auth/data/data_sources/data_source_imp.dart'
    as _i327;
import 'package:chefaa/features/doctor/auth/data/repositories/repo_imp.dart'
    as _i685;
import 'package:chefaa/features/doctor/auth/domain/repositories/repo.dart'
    as _i197;
import 'package:chefaa/features/doctor/auth/presentation/manager/doctor_auth_cubit.dart'
    as _i1056;
import 'package:chefaa/features/doctor/chatbot/data/data_sources/doc_chatbot_data_source.dart'
    as _i348;
import 'package:chefaa/features/doctor/chatbot/data/data_sources/doc_chatbot_data_source_imp.dart'
    as _i352;
import 'package:chefaa/features/doctor/chatbot/data/repositories/doc_chatbot_repo_imp.dart'
    as _i761;
import 'package:chefaa/features/doctor/chatbot/domain/repositories/doc_chatbot_repo.dart'
    as _i858;
import 'package:chefaa/features/doctor/chatbot/presentation/manager/doc_chatbot_cubit.dart'
    as _i817;
import 'package:chefaa/features/doctor/daily_brief/data/data_sources/brief_data_source.dart'
    as _i813;
import 'package:chefaa/features/doctor/daily_brief/data/data_sources/brief_data_source_imp.dart'
    as _i913;
import 'package:chefaa/features/doctor/daily_brief/data/repositories/brief_repo_imp.dart'
    as _i705;
import 'package:chefaa/features/doctor/daily_brief/domain/repositories/brief_repo.dart'
    as _i350;
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_cubit.dart'
    as _i370;
import 'package:chefaa/features/doctor/home/data/data_sources/clinic_data_source.dart'
    as _i336;
import 'package:chefaa/features/doctor/home/data/data_sources/clinic_data_source_imp.dart'
    as _i798;
import 'package:chefaa/features/doctor/home/data/repositories/clinic_repo_imp.dart'
    as _i549;
import 'package:chefaa/features/doctor/home/domain/repositories/clinic_repo.dart'
    as _i729;
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart'
    as _i1072;
import 'package:chefaa/features/doctor/patients/data/data_sources/patients_data_source.dart'
    as _i324;
import 'package:chefaa/features/doctor/patients/data/data_sources/patients_data_source_imp.dart'
    as _i259;
import 'package:chefaa/features/doctor/patients/data/repositories/patients_repo_imp.dart'
    as _i84;
import 'package:chefaa/features/doctor/patients/domain/repositories/patients_repo.dart'
    as _i289;
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart'
    as _i200;
import 'package:chefaa/features/doctor/profile/data/data_sources/local_data_source/doctor_profile_local_data_source.dart'
    as _i1011;
import 'package:chefaa/features/doctor/profile/data/data_sources/local_data_source/doctor_profile_local_data_source_imp.dart'
    as _i948;
import 'package:chefaa/features/doctor/profile/data/data_sources/remote_data_source/remote_data_source.dart'
    as _i477;
import 'package:chefaa/features/doctor/profile/data/data_sources/remote_data_source/remote_data_source_imp.dart'
    as _i304;
import 'package:chefaa/features/doctor/profile/data/repositories/doctor_profile_repo_impl.dart'
    as _i378;
import 'package:chefaa/features/doctor/profile/domain/repositories/doctor_profile_repo.dart'
    as _i353;
import 'package:chefaa/features/doctor/profile/domain/use_cases/get_doctor_data_use_case.dart'
    as _i291;
import 'package:chefaa/features/doctor/profile/domain/use_cases/update_doctor_data_use_case.dart'
    as _i619;
import 'package:chefaa/features/doctor/profile/presentation/manager/doctor_profile_cubit.dart'
    as _i411;
import 'package:chefaa/features/facility/auth/data/data_sources/facility_auth_source.dart'
    as _i959;
import 'package:chefaa/features/facility/auth/data/data_sources/facility_auth_source_impl.dart'
    as _i981;
import 'package:chefaa/features/facility/auth/data/repositories/facility_auth_repo_impl.dart'
    as _i966;
import 'package:chefaa/features/facility/auth/domain/repositories/facility_auth_repo.dart'
    as _i1041;
import 'package:chefaa/features/facility/auth/presentation/manager/facility_auth_cubit.dart'
    as _i683;
import 'package:chefaa/features/facility/dashboard/data/data_sources/dashboard_remote_source.dart'
    as _i572;
import 'package:chefaa/features/facility/dashboard/data/data_sources/dashboard_remote_source_impl.dart'
    as _i654;
import 'package:chefaa/features/facility/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i704;
import 'package:chefaa/features/facility/dashboard/domain/repositories/dashboard_repository.dart'
    as _i84;
import 'package:chefaa/features/facility/dashboard/presentation/manager/dashboard_cubit.dart'
    as _i111;
import 'package:chefaa/features/facility/profile/data/data_sources/profile_remote_source.dart'
    as _i987;
import 'package:chefaa/features/facility/profile/data/data_sources/profile_remote_source_impl.dart'
    as _i410;
import 'package:chefaa/features/facility/profile/data/repositories/profile_repository_impl.dart'
    as _i928;
import 'package:chefaa/features/facility/profile/domain/repositories/profile_repository.dart'
    as _i481;
import 'package:chefaa/features/facility/profile/presentation/manager/facility_profile_cubit.dart'
    as _i793;
import 'package:chefaa/features/facility/services/data/data_sources/services_remote_source.dart'
    as _i872;
import 'package:chefaa/features/facility/services/data/data_sources/services_remote_source_impl.dart'
    as _i1044;
import 'package:chefaa/features/facility/services/data/repositories/services_repository_impl.dart'
    as _i471;
import 'package:chefaa/features/facility/services/domain/repositories/services_repository.dart'
    as _i678;
import 'package:chefaa/features/facility/services/presentation/manager/services_cubit.dart'
    as _i813;
import 'package:chefaa/features/patient/ai_lab/data/data_sources/ai_report_data_source.dart'
    as _i278;
import 'package:chefaa/features/patient/ai_lab/data/data_sources/ai_report_data_source_imp.dart'
    as _i87;
import 'package:chefaa/features/patient/ai_lab/data/repositories/ai_report_repo_imp.dart'
    as _i889;
import 'package:chefaa/features/patient/ai_lab/domain/repositories/ai_report_repo.dart'
    as _i433;
import 'package:chefaa/features/patient/ai_lab/presentation/manager/ai_report_cubit.dart'
    as _i871;
import 'package:chefaa/features/patient/appointment/data/data_sources/appointment_remote_data_source.dart'
    as _i1049;
import 'package:chefaa/features/patient/appointment/data/data_sources/appointment_remote_data_source_impl.dart'
    as _i321;
import 'package:chefaa/features/patient/appointment/data/repositories/appointment_repo_impl.dart'
    as _i776;
import 'package:chefaa/features/patient/appointment/domain/repositories/appointment_repo.dart'
    as _i1010;
import 'package:chefaa/features/patient/appointment/presentation/manager/appointment_cubit.dart'
    as _i676;
import 'package:chefaa/features/patient/auth/data/data_sources/patient_data_source.dart'
    as _i222;
import 'package:chefaa/features/patient/auth/data/data_sources/patient_data_source_imp.dart'
    as _i38;
import 'package:chefaa/features/patient/auth/data/repositories/patient_repo_imp.dart'
    as _i406;
import 'package:chefaa/features/patient/auth/domain/repositories/patient_repo.dart'
    as _i643;
import 'package:chefaa/features/patient/auth/presentation/manager/patient_cubit.dart'
    as _i88;
import 'package:chefaa/features/patient/booking/data/data_sources/remote_date_source/remote_data_source.dart'
    as _i379;
import 'package:chefaa/features/patient/booking/data/data_sources/remote_date_source/remote_data_source_impl.dart'
    as _i42;
import 'package:chefaa/features/patient/booking/data/repositories/booking_repo_imp.dart'
    as _i526;
import 'package:chefaa/features/patient/booking/domain/repositories/booking_repo.dart'
    as _i684;
import 'package:chefaa/features/patient/booking/presentation/manager/booking_cubit.dart'
    as _i1024;
import 'package:chefaa/features/patient/chatbot/data/data_sources/chatbot_remote_data_source.dart'
    as _i581;
import 'package:chefaa/features/patient/chatbot/data/data_sources/chatbot_remote_data_source_imp.dart'
    as _i181;
import 'package:chefaa/features/patient/chatbot/data/repositories/chatbot_repo_imp.dart'
    as _i986;
import 'package:chefaa/features/patient/chatbot/domain/repositories/chatbot_repo.dart'
    as _i765;
import 'package:chefaa/features/patient/chatbot/presentation/manager/chatbot_cubit.dart'
    as _i654;
import 'package:chefaa/features/patient/complete_auth_data/data/data_sources/complete_data_source.dart'
    as _i542;
import 'package:chefaa/features/patient/complete_auth_data/data/data_sources/complete_data_source_imp.dart'
    as _i645;
import 'package:chefaa/features/patient/complete_auth_data/data/repositories/complete_patient_repo_imp.dart'
    as _i623;
import 'package:chefaa/features/patient/complete_auth_data/domain/repositories/complete_patient_repo.dart'
    as _i588;
import 'package:chefaa/features/patient/complete_auth_data/presentation/manager/complete_cubit.dart'
    as _i306;
import 'package:chefaa/features/patient/home/data/data_sources/home_data_source.dart'
    as _i1041;
import 'package:chefaa/features/patient/home/data/data_sources/home_data_source_imp.dart'
    as _i178;
import 'package:chefaa/features/patient/home/data/repositories/home_repo_imp.dart'
    as _i705;
import 'package:chefaa/features/patient/home/domain/repositories/home_repo.dart'
    as _i37;
import 'package:chefaa/features/patient/home/domain/use_cases/user_usecase.dart'
    as _i868;
import 'package:chefaa/features/patient/home/presentation/manager/users_cubit.dart'
    as _i355;
import 'package:chefaa/features/patient/lab_results/data/data_sources/lab_results_remote_data_source.dart'
    as _i501;
import 'package:chefaa/features/patient/lab_results/data/data_sources/lab_results_remote_data_source_impl.dart'
    as _i665;
import 'package:chefaa/features/patient/lab_results/data/repositories/lab_results_repository_impl.dart'
    as _i997;
import 'package:chefaa/features/patient/lab_results/domain/repositories/lab_results_repository.dart'
    as _i747;
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_cubit.dart'
    as _i977;
import 'package:chefaa/features/patient/lab_search/data/data_sources/lab_search_remote_data_source.dart'
    as _i774;
import 'package:chefaa/features/patient/lab_search/data/data_sources/lab_search_remote_data_source_impl.dart'
    as _i523;
import 'package:chefaa/features/patient/lab_search/data/repositories/lab_search_repo_impl.dart'
    as _i841;
import 'package:chefaa/features/patient/lab_search/domain/repositories/lab_search_repo.dart'
    as _i817;
import 'package:chefaa/features/patient/lab_search/presentation/manager/lab_search_cubit.dart'
    as _i216;
import 'package:chefaa/features/patient/medication/data/data_sources/medication_data_source.dart'
    as _i709;
import 'package:chefaa/features/patient/medication/data/data_sources/medication_data_source_imp.dart'
    as _i195;
import 'package:chefaa/features/patient/medication/data/repositories/medication_repo_imp.dart'
    as _i600;
import 'package:chefaa/features/patient/medication/domain/repositories/medication_repo.dart'
    as _i157;
import 'package:chefaa/features/patient/medication/presentation/manager/medication_cubit.dart'
    as _i608;
import 'package:chefaa/features/patient/notification/data/data_sources/patient_notific_data_source.dart'
    as _i210;
import 'package:chefaa/features/patient/notification/data/data_sources/patient_notific_data_source_imp.dart'
    as _i765;
import 'package:chefaa/features/patient/notification/data/repositories/patient_notific_repo_imp.dart'
    as _i297;
import 'package:chefaa/features/patient/notification/domain/repositories/patient_notific_repo.dart'
    as _i307;
import 'package:chefaa/features/patient/notification/presentation/manager/patient_notification_cubit.dart'
    as _i476;
import 'package:chefaa/features/patient/order/data/data_sources/orders_list_data_source.dart'
    as _i326;
import 'package:chefaa/features/patient/order/data/data_sources/orders_list_data_source_imp.dart'
    as _i722;
import 'package:chefaa/features/patient/order/data/data_sources/track_order_data_source.dart'
    as _i85;
import 'package:chefaa/features/patient/order/data/data_sources/track_order_data_source_imp.dart'
    as _i361;
import 'package:chefaa/features/patient/order/data/repositories/orders_list_repo_impl.dart'
    as _i150;
import 'package:chefaa/features/patient/order/data/repositories/track_order_repo_impl.dart'
    as _i516;
import 'package:chefaa/features/patient/order/domain/repositories/orders_list_repo.dart'
    as _i306;
import 'package:chefaa/features/patient/order/domain/repositories/track_order_repo.dart'
    as _i213;
import 'package:chefaa/features/patient/order/presentation/manager/orders_list_cubit.dart'
    as _i59;
import 'package:chefaa/features/patient/order/presentation/manager/track_order_cubit.dart'
    as _i594;
import 'package:chefaa/features/patient/payment/data/data_sources/online_payment_data_source.dart'
    as _i246;
import 'package:chefaa/features/patient/payment/data/data_sources/online_payment_data_source_imp.dart'
    as _i526;
import 'package:chefaa/features/patient/payment/data/repositories/online_payment_repo_impl.dart'
    as _i477;
import 'package:chefaa/features/patient/payment/domain/repositories/online_payment_repo.dart'
    as _i216;
import 'package:chefaa/features/patient/payment/presentation/manager/payment_cubit.dart'
    as _i800;
import 'package:chefaa/features/patient/pharmacy/medicines/presentation/manager/medicine_details_cubit.dart'
    as _i674;
import 'package:chefaa/features/patient/pharmacy/medicines/presentation/manager/pharmacy_medicines_cubit.dart'
    as _i1036;
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/data_sources/pharmacy_patient_data_source.dart'
    as _i242;
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/data_sources/pharmacy_patient_data_source_imp.dart'
    as _i394;
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/data_sources/pharmacy_remote_data_source.dart'
    as _i638;
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/data_sources/pharmacy_remote_data_source_imp.dart'
    as _i790;
import 'package:chefaa/features/patient/pharmacy/pharmacies/data/repositories/pharmacy_profile_repo_imp.dart'
    as _i700;
import 'package:chefaa/features/patient/pharmacy/pharmacies/domain/repositories/pharmacy_profile_repo.dart'
    as _i931;
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_checkout_cubit.dart'
    as _i2;
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_profile_cubit.dart'
    as _i339;
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_review_cubit.dart'
    as _i328;
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/manager/pharmacy_search_cubit.dart'
    as _i389;
import 'package:chefaa/features/patient/profile/data/data_sources/remote_date_source/profile_remote_data_source.dart'
    as _i414;
import 'package:chefaa/features/patient/profile/data/data_sources/remote_date_source/profile_remote_data_source_imp.dart'
    as _i845;
import 'package:chefaa/features/patient/profile/data/repositories/profile_repo_imp.dart'
    as _i1070;
import 'package:chefaa/features/patient/profile/domain/repositories/profile_repo.dart'
    as _i972;
import 'package:chefaa/features/patient/profile/presentation/manager/profile_cubit.dart'
    as _i418;
import 'package:chefaa/features/patient/search/data/data_sources/local_data_source/search_local_data_source.dart'
    as _i272;
import 'package:chefaa/features/patient/search/data/data_sources/local_data_source/search_local_data_source_imp.dart'
    as _i232;
import 'package:chefaa/features/patient/search/data/data_sources/remote_data_source/search_remote_data_source.dart'
    as _i266;
import 'package:chefaa/features/patient/search/data/data_sources/remote_data_source/search_remote_data_source_imp.dart'
    as _i362;
import 'package:chefaa/features/patient/search/data/repositories/search_repo_imp.dart'
    as _i744;
import 'package:chefaa/features/patient/search/domain/repositories/search_repo.dart'
    as _i988;
import 'package:chefaa/features/patient/search/presentation/manager/search_cubit.dart'
    as _i816;
import 'package:chefaa/features/pharmacy/auth/data/data_sources/pharmacy_data_source.dart'
    as _i705;
import 'package:chefaa/features/pharmacy/auth/data/data_sources/pharmacy_data_source_imp.dart'
    as _i486;
import 'package:chefaa/features/pharmacy/auth/data/repositories/pharmacy_repo_imp.dart'
    as _i682;
import 'package:chefaa/features/pharmacy/auth/domain/repositories/pharmacy_repo.dart'
    as _i563;
import 'package:chefaa/features/pharmacy/auth/presentation/manager/pharmacy_cubit.dart'
    as _i929;
import 'package:chefaa/features/pharmacy/chatbot/data/data_sources/pharmacy_chatbot_data_source.dart'
    as _i106;
import 'package:chefaa/features/pharmacy/chatbot/data/data_sources/pharmacy_chatbot_data_source_impl.dart'
    as _i308;
import 'package:chefaa/features/pharmacy/chatbot/data/repositories/pharmacy_chatbot_repo_impl.dart'
    as _i476;
import 'package:chefaa/features/pharmacy/chatbot/domain/repositories/pharmacy_chatbot_repo.dart'
    as _i378;
import 'package:chefaa/features/pharmacy/chatbot/presentation/manager/pharmacy_chatbot_cubit.dart'
    as _i941;
import 'package:chefaa/features/pharmacy/inventory/data/data_sources/pharmacy_inventory_data_source.dart'
    as _i502;
import 'package:chefaa/features/pharmacy/inventory/data/data_sources/pharmacy_inventory_data_source_impl.dart'
    as _i103;
import 'package:chefaa/features/pharmacy/inventory/data/repositories/pharmacy_inventory_repo_impl.dart'
    as _i818;
import 'package:chefaa/features/pharmacy/inventory/domain/repositories/pharmacy_inventory_repo.dart'
    as _i921;
import 'package:chefaa/features/pharmacy/inventory/presentation/manager/pharmacy_inventory_cubit.dart'
    as _i555;
import 'package:chefaa/features/pharmacy/profile/data/data_sources/pharmacy_profile_data_source.dart'
    as _i170;
import 'package:chefaa/features/pharmacy/profile/data/data_sources/pharmacy_profile_data_source_impl.dart'
    as _i194;
import 'package:chefaa/features/pharmacy/profile/data/repositories/pharmacy_profile_repo_impl.dart'
    as _i954;
import 'package:chefaa/features/pharmacy/profile/domain/repositories/pharmacy_profile_repo.dart'
    as _i668;
import 'package:chefaa/features/pharmacy/profile/presentation/manager/pharmacy_profile_cubit.dart'
    as _i658;
import 'package:chefaa/features/pharmacy/settings/data/data_sources/pharmacy_settings_data_source.dart'
    as _i215;
import 'package:chefaa/features/pharmacy/settings/data/data_sources/pharmacy_settings_data_source_impl.dart'
    as _i925;
import 'package:chefaa/features/pharmacy/settings/data/repositories/pharmacy_settings_repo_impl.dart'
    as _i1043;
import 'package:chefaa/features/pharmacy/settings/domain/repositories/pharmacy_settings_repo.dart'
    as _i902;
import 'package:chefaa/features/pharmacy/settings/presentation/manager/pharmacy_settings_cubit.dart'
    as _i900;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i868.UserUseCase>(() => _i868.UserUseCase());
    gh.lazySingleton<_i492.NetworkService>(() => _i492.NetworkService());
    gh.lazySingleton<_i355.UsersCubit>(
        () => _i355.UsersCubit(gh<_i868.UserUseCase>()));
    gh.factory<_i1011.DoctorProfileLocalDataSource>(
        () => _i948.DoctorProfileLocalDataSourceImp());
    gh.factory<_i272.SearchLocalDataSource>(
        () => _i232.SearchDoctorLocalDataSourceImp());
    gh.factory<_i705.PharmacyDataSource>(() => _i486.PharmacyDataSourceImp(
        networkService: gh<_i492.NetworkService>()));
    gh.factory<_i581.ChatbotRemoteDataSource>(
        () => _i181.ChatbotRemoteDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i563.PharmacyRepo>(() => _i682.PharmacyRepoImp(
        pharmacyDataSource: gh<_i705.PharmacyDataSource>()));
    gh.factory<_i85.TrackOrderDataSource>(
        () => _i361.TrackOrderDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i222.PatientDataSource>(
        () => _i38.PatientDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i572.DashboardRemoteSource>(
        () => _i654.DashboardRemoteSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i326.OrdersListDataSource>(
        () => _i722.OrdersListDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i813.BriefDataSource>(() =>
        _i913.BriefDataSourceImp(networkService: gh<_i492.NetworkService>()));
    gh.factory<_i350.BriefRepo>(
        () => _i705.BriefRepoImp(briefDataSource: gh<_i813.BriefDataSource>()));
    gh.factory<_i278.AIReportDataSource>(
        () => _i87.AIReportDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i872.ServicesRemoteSource>(
        () => _i1044.ServicesRemoteSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i929.PharmacyCubit>(
        () => _i929.PharmacyCubit(gh<_i563.PharmacyRepo>()));
    gh.factory<_i379.BookingRemoteDataSource>(
        () => _i42.BookingRemoteDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i501.LabResultsRemoteDataSource>(
        () => _i665.LabResultsRemoteDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i1041.HomeDataSource>(
        () => _i178.HomeDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i959.FacilityAuthDataSource>(
        () => _i981.FacilityAuthDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i433.AIReportRepo>(
        () => _i889.AiReportRepoImp(gh<_i278.AIReportDataSource>()));
    gh.factory<_i709.MedicationDataSource>(
        () => _i195.MedicationDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i414.ProfileRemoteDataSource>(
        () => _i845.ProfileRemoteDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i210.PatientNotificatorDataSource>(() =>
        _i765.PatientNotificatorDataSourceImp(
            networkService: gh<_i492.NetworkService>()));
    gh.factory<_i970.AuthDataSource>(
        () => _i617.AuthDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i502.PharmacyInventoryDataSource>(() =>
        _i103.PharmacyInventoryDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i348.DocChatbotDataSource>(() => _i352.DocChatbotDataSourceImp(
        networkService: gh<_i492.NetworkService>()));
    gh.factory<_i774.LabSearchRemoteDataSource>(
        () => _i523.LabSearchRemoteDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i170.PharmacyProfileDataSource>(
        () => _i194.PharmacyProfileDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i477.DoctorProfileRemoteDataSource>(() =>
        _i304.DoctorProfileRemoteDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i638.PharmacyRemoteDataSource>(
        () => _i790.PharmacyRemoteDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i246.OnlinePaymentDataSource>(
        () => _i526.OnlinePaymentDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i106.PharmacyChatbotDataSource>(
        () => _i308.PharmacyChatbotDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i921.PharmacyInventoryRepo>(() =>
        _i818.PharmacyInventoryRepoImpl(
            pharmacyInventoryDataSource:
                gh<_i502.PharmacyInventoryDataSource>()));
    gh.factory<_i324.PatientsDataSource>(
        () => _i259.PatientsDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i643.PatientRepo>(
        () => _i406.PatientRepoImp(gh<_i222.PatientDataSource>()));
    gh.factory<_i871.AiReportCubit>(
        () => _i871.AiReportCubit(gh<_i433.AIReportRepo>()));
    gh.factory<_i215.PharmacySettingsDataSource>(
        () => _i925.PharmacySettingsDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i353.DoctorProfileRepo>(() => _i378.DoctorProfileRepoImpl(
          gh<_i477.DoctorProfileRemoteDataSource>(),
          gh<_i1011.DoctorProfileLocalDataSource>(),
        ));
    gh.factory<_i266.SearchRemoteDataSource>(
        () => _i362.SearchDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i1049.AppointmentRemoteDataSource>(() =>
        _i321.AppointmentRemoteDataSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i678.ServicesRepository>(
        () => _i471.ServicesRepositoryImpl(gh<_i872.ServicesRemoteSource>()));
    gh.factory<_i289.PatientsRepo>(
        () => _i84.PatientsRepoImp(gh<_i324.PatientsDataSource>()));
    gh.factory<_i480.DoctorAuthDataSource>(
        () => _i327.DoctorAuthDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i555.PharmacyInventoryCubit>(
        () => _i555.PharmacyInventoryCubit(gh<_i921.PharmacyInventoryRepo>()));
    gh.factory<_i336.ClinicDataSource>(
        () => _i798.ClinicDataSourceImp(gh<_i492.NetworkService>()));
    gh.factory<_i684.BookingRepo>(
        () => _i526.BookingRepoImp(gh<_i379.BookingRemoteDataSource>()));
    gh.factory<_i88.PatientCubit>(() => _i88.PatientCubit(
          patientRepo: gh<_i643.PatientRepo>(),
          usersCubit: gh<_i355.UsersCubit>(),
        ));
    gh.factory<_i242.PharmacyPatientDataSource>(() =>
        _i394.PharmacyPatientDataSourceImp(
            networkService: gh<_i492.NetworkService>()));
    gh.factory<_i987.ProfileRemoteSource>(
        () => _i410.ProfileRemoteSourceImpl(gh<_i492.NetworkService>()));
    gh.factory<_i542.CompleteDataSource>(() => _i645.CompleteDataSourceImp(
        networkService: gh<_i492.NetworkService>()));
    gh.factory<_i197.DoctorAuthRepo>(
        () => _i685.DoctorAuthRepoImp(gh<_i480.DoctorAuthDataSource>()));
    gh.factory<_i213.TrackOrderRepo>(
        () => _i516.TrackOrderRepoImpl(gh<_i85.TrackOrderDataSource>()));
    gh.factory<_i1041.FacilityAuthRepo>(
        () => _i966.FacilityAuthRepoImpl(gh<_i959.FacilityAuthDataSource>()));
    gh.factory<_i747.LabResultsRepository>(() =>
        _i997.LabResultsRepositoryImpl(gh<_i501.LabResultsRemoteDataSource>()));
    gh.factory<_i683.FacilityAuthCubit>(
        () => _i683.FacilityAuthCubit(gh<_i1041.FacilityAuthRepo>()));
    gh.factory<_i216.OnlinePaymentRepo>(
        () => _i477.OnlinePaymentRepoImpl(gh<_i246.OnlinePaymentDataSource>()));
    gh.factory<_i200.PatientsCubit>(
        () => _i200.PatientsCubit(gh<_i289.PatientsRepo>()));
    gh.factory<_i84.DashboardRepository>(
        () => _i704.DashboardRepositoryImpl(gh<_i572.DashboardRemoteSource>()));
    gh.factory<_i116.AuthRepo>(
        () => _i479.AuthRepoImp(gh<_i970.AuthDataSource>()));
    gh.factory<_i37.HomeRepo>(
        () => _i705.HomeRepoImp(gh<_i1041.HomeDataSource>()));
    gh.factory<_i307.PatientNotificatorRepo>(() =>
        _i297.PatientNotificatorRepoImp(
            patientNotificatorDataSource:
                gh<_i210.PatientNotificatorDataSource>()));
    gh.factory<_i972.ProfileRepo>(
        () => _i1070.ProfileRepoImpl(gh<_i414.ProfileRemoteDataSource>()));
    gh.factory<_i668.PharmacyProfileRepo>(() => _i954.PharmacyProfileRepoImpl(
        pharmacyProfileDataSource: gh<_i170.PharmacyProfileDataSource>()));
    gh.factory<_i729.ClinicRepo>(
        () => _i549.ClinicRepoImp(gh<_i336.ClinicDataSource>()));
    gh.factory<_i306.OrdersListRepo>(
        () => _i150.OrdersListRepoImpl(gh<_i326.OrdersListDataSource>()));
    gh.factory<_i378.PharmacyChatbotRepo>(() => _i476.PharmacyChatbotRepoImpl(
        pharmacyChatbotDataSource: gh<_i106.PharmacyChatbotDataSource>()));
    gh.factory<_i588.CompletePatientRepo>(() => _i623.CompletePatientRepoImp(
        completeDataSource: gh<_i542.CompleteDataSource>()));
    gh.factory<_i370.BriefCubit>(
        () => _i370.BriefCubit(briefRepo: gh<_i350.BriefRepo>()));
    gh.factory<_i765.ChatbotRepo>(
        () => _i986.ChatbotRepoImp(gh<_i581.ChatbotRemoteDataSource>()));
    gh.factory<_i418.ProfileCubit>(
        () => _i418.ProfileCubit(gh<_i972.ProfileRepo>()));
    gh.factory<_i654.ChatbotCubit>(
        () => _i654.ChatbotCubit(gh<_i765.ChatbotRepo>()));
    gh.factory<_i1024.BookingCubit>(
        () => _i1024.BookingCubit(gh<_i684.BookingRepo>()));
    gh.factory<_i988.SearchRepo>(() => _i744.SearchRepoImp(
          gh<_i266.SearchRemoteDataSource>(),
          gh<_i272.SearchLocalDataSource>(),
        ));
    gh.factory<_i858.DocChatbotRepo>(() => _i761.DocChatbotRepoImp(
        docChatbotDataSource: gh<_i348.DocChatbotDataSource>()));
    gh.factory<_i157.MedicationRepo>(
        () => _i600.MedicationRepoImp(gh<_i709.MedicationDataSource>()));
    gh.factory<_i813.ServicesCubit>(
        () => _i813.ServicesCubit(gh<_i678.ServicesRepository>()));
    gh.factory<_i931.PharmacyProfileRepo>(() =>
        _i700.PharmacyProfileRepoImp(gh<_i638.PharmacyRemoteDataSource>()));
    gh.factory<_i1010.AppointmentRepo>(() =>
        _i776.AppointmentRepoImpl(gh<_i1049.AppointmentRemoteDataSource>()));
    gh.factory<_i1056.DoctorAuthCubit>(() => _i1056.DoctorAuthCubit(
          doctorAuthRepo: gh<_i197.DoctorAuthRepo>(),
          usersCubit: gh<_i355.UsersCubit>(),
        ));
    gh.factory<_i594.TrackOrderCubit>(
        () => _i594.TrackOrderCubit(gh<_i213.TrackOrderRepo>()));
    gh.factory<_i800.PaymentCubit>(
        () => _i800.PaymentCubit(gh<_i216.OnlinePaymentRepo>()));
    gh.factory<_i1072.ClinicCubit>(
        () => _i1072.ClinicCubit(gh<_i729.ClinicRepo>()));
    gh.factory<_i977.LabResultsCubit>(
        () => _i977.LabResultsCubit(gh<_i747.LabResultsRepository>()));
    gh.factory<_i816.SearchCubit>(
        () => _i816.SearchCubit(gh<_i988.SearchRepo>()));
    gh.factory<_i306.CompleteCubit>(
        () => _i306.CompleteCubit(gh<_i588.CompletePatientRepo>()));
    gh.factory<_i817.LabSearchRepo>(
        () => _i841.LabSearchRepoImpl(gh<_i774.LabSearchRemoteDataSource>()));
    gh.factory<_i902.PharmacySettingsRepo>(() =>
        _i1043.PharmacySettingsRepoImpl(
            pharmacySettingsDataSource:
                gh<_i215.PharmacySettingsDataSource>()));
    gh.factory<_i291.GetDoctorDataUseCase>(
        () => _i291.GetDoctorDataUseCase(gh<_i353.DoctorProfileRepo>()));
    gh.factory<_i619.UpdateDoctorDataUseCase>(
        () => _i619.UpdateDoctorDataUseCase(gh<_i353.DoctorProfileRepo>()));
    gh.factory<_i481.ProfileRepository>(
        () => _i928.ProfileRepositoryImpl(gh<_i987.ProfileRemoteSource>()));
    gh.factory<_i476.PatientNotificationCubit>(() =>
        _i476.PatientNotificationCubit(
            patientNotificatorRepo: gh<_i307.PatientNotificatorRepo>()));
    gh.factory<_i59.OrdersListCubit>(
        () => _i59.OrdersListCubit(gh<_i306.OrdersListRepo>()));
    gh.factory<_i658.PharmacyProfileCubit>(
        () => _i658.PharmacyProfileCubit(gh<_i668.PharmacyProfileRepo>()));
    gh.factory<_i674.MedicineDetailsCubit>(
        () => _i674.MedicineDetailsCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i1036.PharmacyMedicinesCubit>(
        () => _i1036.PharmacyMedicinesCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i2.PharmacyCheckoutCubit>(
        () => _i2.PharmacyCheckoutCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i339.PharmacyProfileCubit>(
        () => _i339.PharmacyProfileCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i328.PharmacyReviewCubit>(
        () => _i328.PharmacyReviewCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i389.PharmacySearchCubit>(
        () => _i389.PharmacySearchCubit(gh<_i931.PharmacyProfileRepo>()));
    gh.factory<_i900.PharmacySettingsCubit>(() => _i900.PharmacySettingsCubit(
          gh<_i668.PharmacyProfileRepo>(),
          gh<_i902.PharmacySettingsRepo>(),
        ));
    gh.factory<_i111.DashboardCubit>(
        () => _i111.DashboardCubit(gh<_i84.DashboardRepository>()));
    gh.factory<_i817.DocChatbotCubit>(() =>
        _i817.DocChatbotCubit(docChatbotRepo: gh<_i858.DocChatbotRepo>()));
    gh.factory<_i216.LabSearchCubit>(
        () => _i216.LabSearchCubit(gh<_i817.LabSearchRepo>()));
    gh.factory<_i941.PharmacyChatbotCubit>(
        () => _i941.PharmacyChatbotCubit(gh<_i378.PharmacyChatbotRepo>()));
    gh.factory<_i608.MedicationCubit>(
        () => _i608.MedicationCubit(gh<_i157.MedicationRepo>()));
    gh.factory<_i793.FacilityProfileCubit>(
        () => _i793.FacilityProfileCubit(gh<_i481.ProfileRepository>()));
    gh.factory<_i1019.AuthCubit>(() => _i1019.AuthCubit(
          repo: gh<_i116.AuthRepo>(),
          usersCubit: gh<_i355.UsersCubit>(),
        ));
    gh.factory<_i676.AppointmentCubit>(
        () => _i676.AppointmentCubit(gh<_i1010.AppointmentRepo>()));
    gh.factory<_i411.DoctorProfileCubit>(() => _i411.DoctorProfileCubit(
          getDoctorDataUseCase: gh<_i291.GetDoctorDataUseCase>(),
          updateDoctorDataUseCase: gh<_i619.UpdateDoctorDataUseCase>(),
        ));
    return this;
  }
}
