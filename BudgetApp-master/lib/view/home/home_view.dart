// lib/view/home/home_view.dart

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/bill.dart';
import 'package:budgetapp_fl/common_widget/custom_arch_painter.dart';
import 'package:budgetapp_fl/common_widget/status.dart';
import 'package:budgetapp_fl/api_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  const HomeView({super.key, required this.categories});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? apiData;
  bool isLoading = true;

  List<Map<String, dynamic>> _groupedExpenseCategories = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromBackend();
  }

  Future<void> _loadDataFromBackend() async {
    final now = DateTime.now();
    final data = await apiService.getBudgets(year: now.year, month: now.month);
    if (mounted) {
      setState(() {
        apiData = data;
        if (apiData != null && apiData!['success'] == true) {
          _groupExpensesByCategory();
        }
        isLoading = false;
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

  void _groupExpensesByCategory() {
    if (apiData == null) return;

    final List<dynamic> budgets = apiData!['data']['budgets'];
    final Map<int, Map<String, dynamic>> tempGroup = {};

    for (var budget in budgets) {
      if (budget['type'] == 'expense') {
        int categoryId = budget['category_id'];
        double amount = double.parse(budget['amount'].toString());

        if (tempGroup.containsKey(categoryId)) {

          tempGroup[categoryId]!['total_amount'] += amount;
        } else {

          tempGroup[categoryId] = {
            'category_name': _getCategoryNameById(categoryId),
            'total_amount': amount,
          };
        }
      }
    }
    setState(() {
      _groupedExpenseCategories = tempGroup.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: TColor.gray,
        body: Center(child: CircularProgressIndicator(color: TColor.white)),
      );
    }

    if (apiData == null || apiData!['success'] != true) {
      return Scaffold(
        backgroundColor: TColor.gray,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Erreur de chargement des données.",
                  style: TextStyle(color: TColor.white)),
              Text("Veuillez vous reconnecter.",
                  style: TextStyle(color: TColor.gray30)),
            ],
          ),
        ),
      );
    }

    final List<dynamic> backendBills = apiData!['data']['budgets'];
    final String saldo = apiData!['data']['saldo'];

    final List<Map<String, dynamic>> transformedBills = backendBills.map((bill) {
      return {
        "name": bill['name'],
        "date": DateTime.parse(bill['date']),
        "price": double.parse(bill['amount'].toString()),
        "type": bill['type'],
      };
    }).toList();

    final sortedBills = [...transformedBills]
      ..sort((a, b) => (b["date"] as DateTime).compareTo(a["date"] as DateTime));

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: media.width * 1.1,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColor.gray70.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: media.width * 0.05),
                    width: media.width * 0.72,
                    height: media.width * 0.72,
                    child: CustomPaint(
                      painter: CustomArchPainter(end: 220),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: media.width * 0.05),
                      Text(
                        "\$$saldo",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Text(
                        "Aktueller Saldo",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: TColor.border.withOpacity(0.15)),
                            color: TColor.gray70.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Dein Budget",
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Status(
                                title: "Belege",
                                value: "${sortedBills.length}",
                                statusColor: TColor.secondary,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Status(
                                title: "Höchster Betrag",
                                value: _formatCurrency(_max(sortedBills)),
                                statusColor: TColor.primary10,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Status(
                                title: "Niedrigster Betrag",
                                value: _formatCurrency(_min(sortedBills)),
                                statusColor: TColor.secondaryG,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "Zusammenfassung nach Kategorien",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _groupedExpenseCategories.length,
              itemBuilder: (context, index) {
                final categoryGroup = _groupedExpenseCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: TColor.gray60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryGroup['category_name'],
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatCurrency(categoryGroup['total_amount']),
                          style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "Rechnungsverlauf",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedBills.length,
              itemBuilder: (context, index) {
                final sObj = sortedBills[index];
                return Bill(
                  sObj: sObj,
                  onPressed: () {},
                );
              },
            ),

            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(double? v) {
    if (v == null) return "-";
    return "\$${v.toStringAsFixed(2)}";
  }

  static double? _max(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return null;
    return items
        .map((e) => (e["price"] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (p, c) => c > p ? c : p);
  }

  static double? _min(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return null;
    return items
        .map((e) => (e["price"] as num?)?.toDouble() ?? 0.0)
        .reduce((a, b) => a < b ? a : b);
  }
}