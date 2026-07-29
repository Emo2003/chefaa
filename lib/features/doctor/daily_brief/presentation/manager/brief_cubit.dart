import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/brief_repo.dart';
import 'brief_state.dart';

@injectable
class BriefCubit extends Cubit<BriefState> {
  final BriefRepo briefRepo;

  BriefCubit({required this.briefRepo}) : super(const BriefState());

  static BriefCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getDailyBrief({required String language}) async {
    if (!isClosed) {
      emit(state.copyWith(briefLoading: true, briefError: null));
    }

    try {
      final brief = await briefRepo.getDailyBrief(language: language);
      if (!isClosed) {
        emit(state.copyWith(briefLoading: false, brief: brief));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(briefLoading: false, briefError: e.toString()));
      }
    }
  }

  Future<void> getFinancialsReport({required String language}) async {
    if (!isClosed) {
      emit(state.copyWith(financialsLoading: true, financialsError: null));
    }

    try {
      final financials = await briefRepo.getFinancialsReport(
        language: language,
      );
      if (!isClosed) {
        emit(state.copyWith(financialsLoading: false, financials: financials));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            financialsLoading: false,
            financialsError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> loadAll({required String language}) async {
    await Future.wait([
      getDailyBrief(language: language),
      getFinancialsReport(language: language),
    ]);
  }
}
