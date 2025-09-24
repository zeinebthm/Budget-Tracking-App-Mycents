// lib/view/calender/calender_view.dart

import 'package:budgetapp_fl/api_service.dart';
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderView extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  const CalenderView({super.key, required this.categories});

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  final ApiService apiService = ApiService();
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isLoading = true;
  List<Map<String, dynamic>> _transactionsForMonth = [];
  List<Map<String, dynamic>> _transactionsForSelectedDay = [];
  double _monthlyTotal = 0.0;

  final Map<int, String> germanMonths = {
    1: 'Januar', 2: 'Februar', 3: 'März', 4: 'April', 5: 'Mai', 6: 'Juni',
    7: 'Juli', 8: 'August', 9: 'September', 10: 'Oktober', 11: 'November', 12: 'Dezember'
  };
  final List<String> germanDays = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchTransactionsForMonth(_focusedDay);
  }

  Future<void> _fetchTransactionsForMonth(DateTime month) async {
    setState(() => _isLoading = true);
    final data = await apiService.getBudgets(year: month.year, month: month.month);
    if (mounted && data != null && data['success'] == true) {
      setState(() {
        _transactionsForMonth = List<Map<String, dynamic>>.from(data['data']['budgets']);
        _updateSelectedDayData(_selectedDay!);
        _calculateMonthlyTotal();
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _updateSelectedDayData(DateTime day) {
    _transactionsForSelectedDay = _transactionsForMonth.where((tx) {
      final txDate = DateTime.parse(tx['date']);
      return isSameDay(txDate, day);
    }).toList();
  }
  
  void _calculateMonthlyTotal() {
    double total = 0.0;
    for (var tx in _transactionsForMonth) {
      final amount = double.parse(tx['amount'].toString());
      total += (tx['type'] == 'expense' ? -amount : amount);
    }
    _monthlyTotal = total;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _updateSelectedDayData(selectedDay);
      });
    }
  }
  
  String _getCategoryNameById(int id) {
    try {
      final category = widget.categories.firstWhere((cat) => cat['id'] == id);
      return category['name'] as String;
    } catch (e) {
      return 'Kategorie $id';
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = germanMonths[_focusedDay.month]!;
    
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Column(
          children: [

            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                _fetchTransactionsForMonth(focusedDay);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: TColor.primary.withOpacity(0.5), shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: TColor.primary, shape: BoxShape.circle),
                defaultTextStyle: TextStyle(color: TColor.white),
                weekendTextStyle: TextStyle(color: TColor.white.withOpacity(0.7)),
                outsideTextStyle: TextStyle(color: TColor.gray50),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: TColor.white, fontSize: 18, fontWeight: FontWeight.bold),
                leftChevronIcon: Icon(Icons.chevron_left, color: TColor.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: TColor.white),
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(germanDays[day.weekday % 7], style: TextStyle(color: TColor.gray30)),
                  );
                },
              ),
              eventLoader: (day) => _transactionsForMonth.where((tx) => isSameDay(DateTime.parse(tx['date']), day)).toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$monthName ${_focusedDay.year}", style: TextStyle(color: TColor.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(DateFormat('dd.MM.yyyy').format(_selectedDay!), style: TextStyle(color: TColor.gray30)),
                    ],
                  ),
                  Text(
                    "${_monthlyTotal.toStringAsFixed(2).replaceAll('.', ',')} €",
                    style: TextStyle(color: TColor.white, fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _transactionsForSelectedDay.isEmpty
                  ? Center(child: Text("Keine Transaktionen an diesem Tag.", style: TextStyle(color: TColor.gray30)))
                  : ListView.builder(
                      itemCount: _transactionsForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final tx = _transactionsForSelectedDay[index];
                        final isExpense = tx['type'] == 'expense';
                        final amount = double.parse(tx['amount']);
                        final categoryName = _getCategoryNameById(tx['category_id']);

                        return ListTile(
                          title: Text(categoryName, style: TextStyle(color: TColor.white)),
                          trailing: Text(
                            "${isExpense ? '-' : '+'} ${amount.toStringAsFixed(2).replaceAll('.', ',')} €",
                            style: TextStyle(color: isExpense ? Colors.redAccent : Colors.greenAccent, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}