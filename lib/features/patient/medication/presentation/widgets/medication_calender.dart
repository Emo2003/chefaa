import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:go_router/go_router.dart';

class MedicationCalender extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final bool isReadOnly;
  final String hintText;
  final bool isMedication;

  const MedicationCalender({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onDateSelected,
    this.isReadOnly = false,
    this.isMedication = false,
  });

  @override
  State<MedicationCalender> createState() => _CustomCalendarFieldState();
}

class _CustomCalendarFieldState extends State<MedicationCalender> {
  void _showCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(width: 300, height: 230, child: _buildCalendar()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isMedication ? 125 : double.infinity,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        onTap: widget.isReadOnly ? null : _showCalendar,
        style: const TextStyle(
          color: ColorManager.darkGray,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(AppPadding.p12),
          isDense: widget.isMedication ? true : false,
          hintText: widget.hintText,
          hintStyle: getBoldStyle(
            color: ColorManager.darkGray,
            fontSize: widget.isMedication ? 12 : 16,
          ),
          suffixIcon: widget.isMedication
              ? null
              : const Icon(Icons.calendar_month, color: ColorManager.gray),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final today = DateTime.now();

    DateTime initialDate = today;
    if (widget.controller.text.isNotEmpty) {
      try {
        final parsed = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
        if (!parsed.isBefore(today)) initialDate = parsed;
      } catch (_) {}
    }

    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.single,
      initialSelectedDate: initialDate,
      initialDisplayDate: initialDate,
      minDate: DateTime(today.year, today.month, today.day),
      maxDate: DateTime(today.year + 10, today.month, today.day),
      selectionColor: ColorManager.primary,
      todayHighlightColor: Colors.transparent,
      showNavigationArrow: true,
      headerStyle: DateRangePickerHeaderStyle(
        textStyle: getBoldStyle(color: ColorManager.primary, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      monthViewSettings: const DateRangePickerMonthViewSettings(
        firstDayOfWeek: 6,
        showTrailingAndLeadingDates: true,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            color: Color(0xFF5768BE),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      selectionTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      monthCellStyle: const DateRangePickerMonthCellStyle(
        todayTextStyle: TextStyle(
          color: Color(0xFF5768BE),
          fontWeight: FontWeight.bold,
        ),
        todayCellDecoration: BoxDecoration(),
        textStyle: TextStyle(
          color: ColorManager.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      yearCellStyle: const DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(
          color: ColorManager.black,
          fontWeight: FontWeight.bold,
        ),
        todayCellDecoration: BoxDecoration(),
        textStyle: TextStyle(
          color: ColorManager.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        final DateTime selectedDate = args.value;
        widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        widget.onDateSelected(selectedDate);
        context.pop();
      },
    );
  }
}
