import '../../data/models/brief.dart';
import '../../data/models/financials.dart';

class BriefState {
  final bool briefLoading;
  final bool financialsLoading;

  final Brief? brief;
  final Financials? financials;

  final String? briefError;
  final String? financialsError;

  const BriefState({
    this.briefLoading = false,
    this.financialsLoading = false,
    this.brief,
    this.financials,
    this.briefError,
    this.financialsError,
  });

  BriefState copyWith({
    bool? briefLoading,
    bool? financialsLoading,
    Brief? brief,
    Financials? financials,
    String? briefError,
    String? financialsError,
  }) {
    return BriefState(
      briefLoading: briefLoading ?? this.briefLoading,
      financialsLoading: financialsLoading ?? this.financialsLoading,
      brief: brief ?? this.brief,
      financials: financials ?? this.financials,
      briefError: briefError ?? this.briefError,
      financialsError: financialsError ?? this.financialsError,
    );
  }
}
