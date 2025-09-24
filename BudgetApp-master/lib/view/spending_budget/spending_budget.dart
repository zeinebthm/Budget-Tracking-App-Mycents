import 'package:budgetapp_fl/api_service.dart';
import 'package:budgetapp_fl/common_widget/custom_arch_180_painter.dart';
import 'package:flutter/material.dart';
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/budgets_row.dart';

class SpendingView extends StatefulWidget {
  const SpendingView({super.key});

  @override
  State<SpendingView> createState() => _SpendingState();
}

class _SpendingState extends State<SpendingView> {
  final ApiService apiService = ApiService();

  List<Map<String, dynamic>> budgetArr = [];
  bool isLoading = true;
  double totalSpentThisMonth = 0.0;
  double totalBudgetThisMonth = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSpendingData();
  }

  Future<void> _loadSpendingData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    final categoriesFuture = apiService.getCategories();
    final budgetsFuture =
        apiService.getBudgets(year: DateTime.now().year, month: DateTime.now().month);

    final results = await Future.wait([categoriesFuture, budgetsFuture]);

    final categories = results[0] as List<dynamic>?;
    final budgetData = results[1] as Map<String, dynamic>?;

    if (mounted && categories != null && budgetData != null && budgetData['success'] == true) {
      final transactions =
          List<Map<String, dynamic>>.from(budgetData['data']['budgets']);

      final Map<int, double> spentByCategory = {};
      double currentTotalSpent = 0;
      for (var tx in transactions) {
        if (tx['type'] == 'expense') {
          final categoryId = tx['category_id'] as int;
          final amount = double.parse(tx['amount'].toString());
          spentByCategory[categoryId] =
              (spentByCategory[categoryId] ?? 0.0) + amount;
          currentTotalSpent += amount;
        }
      }

      double currentTotalBudget = 0;
      final List<Map<String, dynamic>> newBudgetArr = [];
      for (var cat in categories) {
        final categoryId = cat['id'] as int;
        final totalBudget =
            double.tryParse(cat['budget']?.toString() ?? "0") ?? 0.0;
        final spentAmount = spentByCategory[categoryId] ?? 0.0;
        final remainingAmount = (totalBudget - spentAmount);

        currentTotalBudget += totalBudget;

        if (totalBudget > 0) {
          newBudgetArr.add({
            "name": cat['name'],
            "icon": _getIconForCategory(cat['name']),
            "höhe": spentAmount.toStringAsFixed(2),
            "gesamtbetrag": totalBudget.toStringAsFixed(2),
            "übriger Betrag": remainingAmount.toStringAsFixed(2),
            "color": _getColorForCategory(cat['name']),
          });
        }
      }

      setState(() {
        budgetArr = newBudgetArr;
        totalSpentThisMonth = currentTotalSpent;
        totalBudgetThisMonth = currentTotalBudget;
        isLoading = false;
      });
    } else if (mounted) {
      setState(() => isLoading = false);
    }
  }

  IconData _getIconForCategory(String name) {
    if (name.toLowerCase().contains('transport')) return Icons.directions_car;
    if (name.toLowerCase().contains('entertainment')) return Icons.movie;
    if (name.toLowerCase().contains('sicherheit')) return Icons.security;
    if (name.toLowerCase().contains('lebensmittel')) return Icons.shopping_cart;
    if (name.toLowerCase().contains('gehalt')) return Icons.account_balance;
    return Icons.category;
  }

  Color _getColorForCategory(String name) {
    if (name.toLowerCase().contains('transport')) return TColor.secondaryG;
    if (name.toLowerCase().contains('entertainment')) return TColor.secondary50;
    if (name.toLowerCase().contains('sicherheit')) return TColor.primary10;
    if (name.toLowerCase().contains('lebensmittel')) return TColor.secondary;
    if (name.toLowerCase().contains('gehalt')) return Colors.blue;
    return TColor.gray30;
  }

  void _showAddCategoryDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final TextEditingController nameCtrl = TextEditingController();
        final TextEditingController budgetCtrl = TextEditingController();

        return AlertDialog(
          backgroundColor: TColor.gray70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Neue Kategorie",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Name der Kategorie",
                    labelStyle: TextStyle(color: TColor.gray30),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.gray30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: budgetCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Vorgesehenes Budget",
                    labelStyle: TextStyle(color: TColor.gray30),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.gray30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixText: "\$ ",
                    prefixStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Abbrechen",
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final budget =
                    double.tryParse(budgetCtrl.text.replaceAll(',', '.'));

                if (name.isEmpty || budget == null || budget <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Bitte gültigen Namen und Budget angeben."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                bool success =
                    await apiService.addCategory(name: name, budget: budget);

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Kategorie erfolgreich hinzugefügt!"),
                        backgroundColor: Colors.green),
                  );
                  Navigator.of(context).pop(true);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Fehler beim Hinzufügen der Kategorie."),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text("Speichern",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _loadSpendingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: TColor.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        width: media.width * 0.5,
                        height: media.width * 0.30,
                        child: CustomPaint(
                          painter: CustomArch180Painter(
                            drwArcs: [
                              ArcValueModel(color: TColor.secondaryG, value: 20),
                              ArcValueModel(color: TColor.secondary, value: 45),
                              ArcValueModel(color: TColor.primary10, value: 70)
                            ],
                            end: totalBudgetThisMonth > 0
                                ? (totalSpentThisMonth / totalBudgetThisMonth) * 100
                                : 0,
                            width: 12,
                            bgwidth: 8,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "\$${totalSpentThisMonth.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "von \$${totalBudgetThisMonth.toStringAsFixed(2)} Budget",
                            style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: TColor.border.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Deine Finanzen",
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: budgetArr.length,
                    itemBuilder: (context, index) {
                      var bObj = budgetArr[index];
                      return BudgetsRow(
                        bObj: bObj,
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
}