// lib/common_widget/budgets_row.dart

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';

class BudgetsRow extends StatelessWidget {
  final Map bObj;
  final VoidCallback onPressed;

  const BudgetsRow({
    super.key,
    required this.bObj,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {

    final double spent = double.tryParse(bObj["höhe"]?.toString() ?? "0") ?? 0.0;
    final double total = double.tryParse(bObj["gesamtbetrag"]?.toString() ?? "0") ?? 0.0;
    final double remaining = double.tryParse(bObj["übriger Betrag"]?.toString() ?? "0") ?? 0.0;


    double proVal;
    if (total > 0) {

      proVal = spent / total;
    } else {

      proVal = 0.0;
    }

    proVal = proVal.clamp(0.0, 1.0);


    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: TColor.border.withOpacity(0.05)),
            color: TColor.gray60.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(bObj["icon"], size: 32, color: TColor.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bObj["name"],
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(

                          "\$${remaining.abs().toStringAsFixed(2)} übrig",
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${spent.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "von \$${total.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: TColor.gray30,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                backgroundColor: TColor.gray60,
                valueColor: AlwaysStoppedAnimation(bObj["color"]),
                minHeight: 3,
                value: proVal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}