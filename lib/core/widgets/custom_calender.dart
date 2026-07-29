import 'package:chefaa/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:go_router/go_router.dart';

class CustomCalendarField extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final bool isReadOnly;
  final String hintText;
  final bool isMedication;

  const CustomCalendarField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onDateSelected,
    this.isReadOnly = false,
    this.isMedication = false,
  });

  @override
  State<CustomCalendarField> createState() => _CustomCalendarFieldState();
}

class _CustomCalendarFieldState extends State<CustomCalendarField> {
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
      width: widget.isMedication ? 150 : double.infinity,
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
          isDense: widget.isMedication ? true : false,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.isMedication ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: ColorManager.darkGray,
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
    DateTime initialDate = DateTime.now();

    if (widget.controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
      } catch (_) {}
    }

    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.single,
      initialSelectedDate: initialDate,
      initialDisplayDate: initialDate,
      maxDate: DateTime.now(),
      selectionColor: ColorManager.primary,
      todayHighlightColor: Colors.transparent,
      showNavigationArrow: true,
      headerStyle: const DateRangePickerHeaderStyle(
        textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: ColorManager.primary,
        ),
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
        DateTime selectedDate = args.value;
        widget.controller.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        widget.onDateSelected(selectedDate);
        context.pop();
      },
    );
  }
}
