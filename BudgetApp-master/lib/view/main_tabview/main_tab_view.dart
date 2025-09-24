import 'package:budgetapp_fl/api_service.dart';
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/view/calender/calender_view.dart';
import 'package:budgetapp_fl/view/home/home_view.dart';
import 'package:budgetapp_fl/view/spending_budget/spending_budget.dart';
import 'package:flutter/material.dart';

enum TxType { expense, income }

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectedTab = 0;
  final PageStorageBucket pageStorageBucket = PageStorageBucket();

  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> _apiCategories = [];
  bool _areCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (_apiCategories.isEmpty) {
      if (mounted) setState(() => _areCategoriesLoading = true);
    }
    
    final categories = await apiService.getCategories();
    if (mounted && categories != null) {
      setState(() {
        _apiCategories = List<Map<String, dynamic>>.from(categories);
        _areCategoriesLoading = false;
      });
    } else if (mounted) {
      setState(() => _areCategoriesLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentTabView;
    switch (selectedTab) {
      case 0:
        currentTabView = HomeView(categories: _apiCategories);
        break;
      case 1:
        currentTabView = const SpendingView();
        break;
      case 2:
        currentTabView = CalenderView(categories: _apiCategories);
        break;
      default:
        currentTabView = HomeView(categories: _apiCategories);
    }

    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(
        children: [
          PageStorage(bucket: pageStorageBucket, child: currentTabView),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                height: 56,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(95, 54, 51, 51),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {

                        _loadCategories(); 
                        setState(() => selectedTab = 0);
                      },
                      icon: Icon(
                        Icons.home,
                        color: selectedTab == 0 ? TColor.white : TColor.gray50,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => selectedTab = 1);
                      },
                      icon: Icon(
                        Icons.account_balance_wallet,
                        color: selectedTab == 1 ? TColor.white : TColor.gray50,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => selectedTab = 2);
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        color: selectedTab == 2 ? TColor.white : TColor.gray50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (selectedTab == 0)
            Positioned(
              bottom: 90,
              right: 30,
              child: InkWell(
                onTap: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => _buildAddTransactionDialog(context),
                  );
                  if (result == true) {

                    setState(() {}); 
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: TColor.gray5.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 8, 8, 8),
                    size: 32,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddTransactionDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    int? selectedCategoryId;
    TxType selectedType = TxType.expense;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        final isExpense = selectedType == TxType.expense;
        final titleText = isExpense ? "Neue Ausgabe" : "Neue Einnahme";
        final nameLabel = isExpense ? "Name der Ausgabe" : "Name der Einnahme";
        final amountLabel = isExpense ? "Betrag der Ausgabe" : "Betrag der Einnahme";

        return AlertDialog(
          backgroundColor: TColor.gray70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            titleText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(95, 54, 51, 51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setLocalState(() => selectedType = TxType.expense),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedType == TxType.expense
                                  ? TColor.white.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Ausgabe",
                              style: TextStyle(
                                color: selectedType == TxType.expense
                                    ? Colors.white
                                    : TColor.gray30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setLocalState(() => selectedType = TxType.income),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedType == TxType.income
                                  ? TColor.white.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Einnahme",
                              style: TextStyle(
                                color: selectedType == TxType.income
                                    ? Colors.white
                                    : TColor.gray30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: nameLabel,
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
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: amountLabel,
                    labelStyle: TextStyle(color: TColor.gray30),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.gray30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixText: "€ ",
                    prefixStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  dropdownColor: TColor.gray70,
                  value: selectedCategoryId,
                  items: _apiCategories
                      .map<DropdownMenuItem<int>>((Map<String, dynamic> c) {
                    return DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(c['name'],
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (val) => setLocalState(() => selectedCategoryId = val),
                  decoration: InputDecoration(
                    labelText: "Kategorie",
                    labelStyle: TextStyle(color: TColor.gray30),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColor.gray30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Abbrechen", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
                if (name.isEmpty || amount <= 0 || selectedCategoryId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(selectedCategoryId == null ? "Bitte eine Kategorie auswählen." : "Bitte gültige Eingaben machen."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                final typeStr = selectedType == TxType.expense ? "expense" : "income";
                bool success = await apiService.addBudget(
                  name: name,
                  categoryId: selectedCategoryId!,
                  amount: amount,
                  type: typeStr,
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transaktion erfolgreich hinzugefügt!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fehler beim Hinzufügen der Transaktion."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Speichern", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

}