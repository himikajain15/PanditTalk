import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomBackButton({
    Key? key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: iconColor ?? AppTheme.black,
          size: 20,
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(),
      ),
    );
  }
}

