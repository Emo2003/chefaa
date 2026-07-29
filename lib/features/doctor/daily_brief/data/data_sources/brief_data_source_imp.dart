import 'package:chefaa/core/services/network_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'brief_data_source.dart';

@Injectable(as: BriefDataSource)
class BriefDataSourceImp implements BriefDataSource {
  NetworkService networkService;

  BriefDataSourceImp({required this.networkService});

  @override
  Future<Response<dynamic>> getDailyBrief({required String language}) {
    return networkService.dio.get(
      '/doctor/ai/brief',
      queryParameters: {'lang': language},
    );
  }

  @override
  Future<Response<dynamic>> getFinancialsReport({required String language}) {
    return networkService.dio.get(
      '/doctor/ai/financials',
      queryParameters: {'lang': language},
    );
  }
}
