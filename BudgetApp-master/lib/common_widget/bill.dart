// lib/common_widget/bill.dart

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bill extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const Bill({
    super.key,
    required this.sObj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = sObj["date"] is DateTime ? sObj["date"] : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(

                width: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date != null ? DateFormat('MMM', 'de_DE').format(date) : "???",
                      style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      date != null ? DateFormat('dd').format(date) : "!",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  sObj["name"].toString(),
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "\$${(sObj["price"] as double).toStringAsFixed(2)}",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}