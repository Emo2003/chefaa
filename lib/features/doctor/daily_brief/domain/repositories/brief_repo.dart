import '../../data/models/brief.dart';
import '../../data/models/financials.dart';

abstract class BriefRepo {
  Future<Brief> getDailyBrief({required String language});

  Future<Financials> getFinancialsReport({required String language});
}
