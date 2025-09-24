// ignore_for_file: deprecated_member_use

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';

class SubscriptionHomeRow extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const SubscriptionHomeRow({
    super.key, 
    required this.sObj,
    required this.onPressed});

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
                      onTap: onPressed,
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.all(10),
                        decoration:  BoxDecoration(
                          border: Border.all(
                            color: TColor.border.withOpacity(0.15)
                            ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Icon(
                              sObj["icon"],
                              size: 32,
                              color: TColor.white,
                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sObj["name"],
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                              ),
                            ),
      
                            const SizedBox(width: 8),
      
                            Text(
                                "\$${sObj["preis"]}",
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                              ),
                          ],
                        ),
                      ),
                    ),
    );
  } 
}