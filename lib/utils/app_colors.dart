import 'package:flutter/material.dart';

class AppColors {
  // Colores principales médicos (Premium Elite Palette)
  static const Color primary = Color(0xFF004D40); // Deep Emerald Teal
  static const Color primaryLight = Color(0xFF00796B);
  static const Color primaryDark = Color(0xFF00251A);
  
  static const Color accentGold = Color(0xFFFFD700); // Gold for Premium elements
  static const Color premiumGold = Color(0xFFD4AF37);
  
  static const Color secondary = Color(0xFF1565C0); // Rich Blue
  static const Color secondaryLight = Color(0xFF5E92F3);
  static const Color secondaryDark = Color(0xFF003C8F);

  static const Color background = Color(0xFFF4F7F6); 
  static const Color surface = Colors.white; 

  // Alertas y estados
  static const Color danger = Color(0xFFC62828); 
  static const Color warning = Color(0xFFF9A825);
  static const Color success = Color(0xFF2E7D32); 
  static const Color info = Color(0xFF0288D1); // Added back for compatibility

  // Texto
  static const Color textPrimary = Color(0xFF1A1A1A); 
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color textLight = Colors.white;

  // Gradientes Premium
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF004D40), Color(0xFF00796B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
