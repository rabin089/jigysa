import 'package:flutter/material.dart';

import '../../constant/style/app.style.constant.dart';

class CustomAlertBox extends StatelessWidget {
  final String title;
  final String? message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final Color primaryButtonColor;

  const CustomAlertBox({
    super.key,
    required this.title,
    this.message,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.primaryButtonColor = AppTheme.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                title,
                style:  Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),),
            const SizedBox(height: 8),
            Text(
              message??'',
              textAlign: TextAlign.center,
              style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onPrimaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButtonColor, // dark navy color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: Text(primaryButtonText),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onSecondaryPressed,
              child: Text(
                secondaryButtonText,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
