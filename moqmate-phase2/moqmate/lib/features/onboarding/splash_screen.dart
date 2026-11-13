import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.wine,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_rounded, size: 72, color: AppColors.mist),
            SizedBox(height: 16),
            Text('MOQMate',
                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            SizedBox(height: 8),
            Text('Buy Together. Pay Less. Grow Together.', style: TextStyle(color: AppColors.petal, fontSize: 14)),
            SizedBox(height: 32),
            SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.blush)),
          ],
        ),
      ),
    );
  }
}
