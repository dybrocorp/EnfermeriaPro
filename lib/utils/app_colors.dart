import 'package:flutter/material.dart';

class AppColors {
  // Colores principales médicos (Modificados para verse más premium)
  static const Color primary = Color(0xFF005C53); // Verde Teal oscuro profundo
  static const Color primaryLight = Color(0xFF048A81); // Teal vibrante
  static const Color primaryDark = Color(0xFF00433E);
  
  static const Color secondary = Color(0xFF1E88E5); // Azul médico claro y moderno
  static const Color secondaryLight = Color(0xFF6AB7FF);
  static const Color secondaryDark = Color(0xFF005CB2);

  static const Color background = Color(0xFFF0F4F8); // Fondo grisazulado suave
  static const Color surface = Colors.white; // Tarjetas blancas

  // Alertas y estados (más suaves e integrados)
  static const Color danger = Color(0xFFE53935); // Rojo material design
  static const Color warning = Color(0xFFFB8C00); // Naranja alerta
  static const Color success = Color(0xFF43A047); // Verde confirmación
  static const Color info = Color(0xFF0288D1); // Azul informativo

  // Texto
  static const Color textPrimary = Color(0xFF2C3E50); // Azul muy oscuro para contraste
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
