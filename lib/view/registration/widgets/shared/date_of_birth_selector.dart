import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';

class DateOfBirthSelector extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  // Use const constructor for better performance
  const DateOfBirthSelector({
    super.key,
    required this.viewModel,
    required this.language,
  });

  // Move months to a static const for better memory management
  static const List<String> months = [
    'january', 'february', 'march', 'april', 'may', 'june',
    'july', 'august', 'september', 'october', 'november', 'december'
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDatePicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCalendarIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateDisplay(),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: viewModel.gradientColors[0].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.calendar_today,
        color: viewModel.gradientColors[0],
        size: 20,
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          viewModel.getLocalizedText('date_of_birth'),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          viewModel.state.selectedDateOfBirth == null
              ? viewModel.getLocalizedText('select_date')
              : _formatDate(viewModel.state.selectedDateOfBirth!),
          style: TextStyle(
            color: viewModel.state.selectedDateOfBirth == null
                ? Colors.grey[400]
                : Colors.black,
            fontSize: 16,
            fontWeight: viewModel.state.selectedDateOfBirth == null
                ? FontWeight.normal
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final initialDate = viewModel.state.selectedDateOfBirth ?? DateTime.now();

    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) => _DatePickerSheet(
        initialDate: initialDate,
        viewModel: viewModel,
        onDateSelected: (date) => Navigator.pop(context, date),
      ),
    );

    if (picked != null) {
      viewModel.setDateOfBirth(picked);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}

// Separate stateful widget for the date picker sheet
class _DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final RegistrationViewModel viewModel;
  final Function(DateTime) onDateSelected;

  const _DatePickerSheet({
    required this.initialDate,
    required this.viewModel,
    required this.onDateSelected,
  });

  @override
  _DatePickerSheetState createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildMonthYearSelector(),
          Expanded(
            child: _buildCalendarGrid(),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildMonthYearSelector() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          GestureDetector(
            onTap: () => _showYearPicker(),
            child: Column(
              children: [
                Text(
                  widget.viewModel.getLocalizedText(DateOfBirthSelector.months[selectedDate.month - 1]),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      selectedDate.year.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month - 1,
        selectedDate.day,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        selectedDate.day,
      );
    });
  }

  Widget _buildCalendarGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildWeekDayHeaders(),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42,
              itemBuilder: (context, index) => _buildDayCell(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeaders() {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) => SizedBox(
        width: 40,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }

  Widget _buildDayCell(int index) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final day = index - startingWeekday + 1;
    final currentDate = DateTime(selectedDate.year, selectedDate.month, day);

    if (day < 1 || day > DateTime(selectedDate.year, selectedDate.month + 1, 0).day) {
      return const SizedBox();
    }

    final isSelected = currentDate.year == selectedDate.year &&
        currentDate.month == selectedDate.month &&
        currentDate.day == selectedDate.day;

    final isToday = currentDate.year == DateTime.now().year &&
        currentDate.month == DateTime.now().month &&
        currentDate.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => setState(() => selectedDate = currentDate),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(
            colors: widget.viewModel.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          color: isToday && !isSelected ? widget.viewModel.gradientColors[0].withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white :
              isToday ? widget.viewModel.gradientColors[0] :
              Colors.black87,
              fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: widget.viewModel.gradientColors[0]),
                ),
              ),
              child: Text(
                widget.viewModel.getLocalizedText('back'),
                style: TextStyle(
                  color: widget.viewModel.gradientColors[0],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildConfirmButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.viewModel.gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.viewModel.gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => widget.onDateSelected(selectedDate),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          widget.viewModel.getLocalizedText('continue'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _showYearPicker() async {
    final int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.viewModel.getLocalizedText('select_year'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: DateTime.now().year - 1900 + 1,
                    itemBuilder: (context, index) {
                      final year = DateTime.now().year - index;
                      return ListTile(
                        selected: year == selectedDate.year,
                        selectedTileColor: widget.viewModel.gradientColors[0].withOpacity(0.1),
                        onTap: () => Navigator.pop(context, year),
                        title: Text(
                          year.toString(),
                          style: TextStyle(
                            color: year == selectedDate.year ?
                            widget.viewModel.gradientColors[0] : null,
                            fontWeight: year == selectedDate.year ?
                            FontWeight.bold : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      setState(() {
        selectedDate = DateTime(
          selectedYear,
          selectedDate.month,
          selectedDate.day,
        );
      });
    }
  }
}