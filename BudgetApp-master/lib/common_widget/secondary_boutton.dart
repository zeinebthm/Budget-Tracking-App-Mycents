import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;

  const SecondaryButton({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, 
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: TColor.gray70,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          title, 
          style: TextStyle(
            color: TColor.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
