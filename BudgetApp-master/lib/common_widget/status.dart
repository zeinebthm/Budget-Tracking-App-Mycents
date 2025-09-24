// ignore_for_file: deprecated_member_use

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;

  final VoidCallback onPressed;
  
  const Status({
    super.key, 
    required this.title,
    required this.value,
    required this.statusColor,
    required this.onPressed});

  @override
  Widget build (BuildContext context) {
    return InkWell(
                    onTap: onPressed,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                        height: 68,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: TColor.border.withOpacity(0.15)
                            ),
                          color: TColor.gray70.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                              color: TColor.gray40,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                            ),
                            Text(
                              value,
                              style: TextStyle(
                              color: TColor.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    Container(
                        width: 60,
                        height: 1,
                        color: statusColor,
                     ),
                    ],
                  ),
                );
  } 
}