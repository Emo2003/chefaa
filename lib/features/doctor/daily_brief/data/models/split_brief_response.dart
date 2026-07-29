class ParsedBrief {
  final String intro;
  final String schedule;

  final String appointments;
  final String completed;
  final String rate;

  final String clinicName;
  final String workingHours;

  final String revenue;
  final String expectedRevenue;
  final String fee;

  final String actionItem;
  final String motivation;

  ParsedBrief({
    required this.intro,
    required this.schedule,
    required this.appointments,
    required this.completed,
    required this.rate,
    required this.clinicName,
    required this.workingHours,
    required this.revenue,
    required this.expectedRevenue,
    required this.fee,
    required this.actionItem,
    required this.motivation,
  });

  factory ParsedBrief.fromText(String text) {
    String clean(String value) {
      return value
          .replaceAll('**', '')
          .replaceAll('"', '')
          .replaceAll('- ', '')
          .trim();
    }

    String extract(String start, String end) {
      final startIndex = text.indexOf(start);

      if (startIndex == -1) return '';

      final contentStart = startIndex + start.length;

      final endIndex = end.isEmpty
          ? text.length
          : text.indexOf(end, contentStart);

      return clean(
        text.substring(contentStart, endIndex == -1 ? text.length : endIndex),
      );
    }

    final intro = text.contains('📅')
        ? clean(text.substring(0, text.indexOf('📅')))
        : '';

    final schedule = extract(
      '📅 **Today\'s Schedule**',
      '📊 **This Week at a Glance**',
    );

    final week = extract(
      '📊 **This Week at a Glance**',
      '🏥 **Clinic Status**',
    );

    final clinic = extract('🏥 **Clinic Status**', '💰 **Financial Snapshot**');
    final financial = extract(
      '💰 **Financial Snapshot**',
      '⚠️ **Action Items**',
    );
    final revenueMatch = RegExp(
      r'Confirmed revenue this month:\s*([\d,.]+)',
    ).firstMatch(financial);

    final expectedRevenueMatch = RegExp(
      r'Expected revenue(?: from upcoming appointments)?\s*:\s*([\d,.]+)',
    ).firstMatch(financial);

    final feeMatch = RegExp(
      r'Platform fee owed:\s*([\d,.]+)',
    ).firstMatch(financial);

    final action = extract(
      '⚠️ **Action Items**',
      '🌟 **Motivational Closing Line**',
    );

    final motivation = extract('🌟 **Motivational Closing Line**', '');

    final appointmentsMatch = RegExp(
      r'Total appointments:\s*(\d+)',
    ).firstMatch(week);

    final completedMatch = RegExp(r'\((\d+)\s*completed').firstMatch(week);

    final rateMatch = RegExp(r'Completion rate:\s*(\d+)').firstMatch(week);

    final clinicLines = clinic
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return ParsedBrief(
      intro: intro,

      schedule: schedule,

      appointments: appointmentsMatch?.group(1) ?? '0',

      completed: completedMatch?.group(1) ?? '0',

      rate: rateMatch?.group(1) ?? '0',

      clinicName: clinicLines.isNotEmpty
          ? clean(clinicLines.first.replaceAll('- Active clinic:', ''))
          : '',

      workingHours: clinicLines.length > 1
          ? clean(clinicLines[1].replaceAll('- Working hours:', ''))
          : '',

      revenue: revenueMatch?.group(1)?.replaceAll(',', '') ?? '0',

      expectedRevenue:
          expectedRevenueMatch?.group(1)?.replaceAll(',', '') ?? '0',

      fee: feeMatch?.group(1)?.replaceAll(',', '') ?? '0',
      actionItem: clean(action),

      motivation: clean(motivation),
    );
  }
}
