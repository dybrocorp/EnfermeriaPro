import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bouncy_card.dart';

class VitalsTutorialScreen extends StatefulWidget {
  const VitalsTutorialScreen({super.key});

  @override
  State<VitalsTutorialScreen> createState() => _VitalsTutorialScreenState();
}

class _VitalsTutorialScreenState extends State<VitalsTutorialScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Preparación del Paciente',
      'instruction': 'Asegúrate de que el paciente esté en reposo (mínimo 5 minutos). Explica el procedimiento para ganar su confianza y reducir la ansiedad.',
      'icon': Icons.accessibility_new,
      'color': AppColors.primary
    },
    {
      'title': 'Frecuencia Cardíaca (Pulso)',
      'instruction': '1. Usa los dedos índice y medio (NUNCA el pulgar).\n2. Localiza la arteria radial (en la muñeca, lado del pulgar).\n3. Cuenta las pulsaciones por 60 segundos.\n\nNormal: 60-100 lpm.',
      'icon': Icons.monitor_heart,
      'color': AppColors.danger
    },
    {
      'title': 'Presión Arterial',
      'instruction': '1. Coloca el brazalete 2 cm por encima del pliegue del codo.\n2. Encuentra el pulso braquial y ubica allí la campana del estetoscopio.\n3. Infla hasta que el pulso desaparezca + 30mmHg.\n4. Desinfla lentamente (2mmHg/seg).\n5. Primer sonido = Sistólica. Último sonido = Diastólica.',
      'icon': Icons.speed,
      'color': const Color(0xFF8E44AD)
    },
    {
      'title': 'Frecuencia Respiratoria',
      'instruction': '¡Secreto! No le digas al paciente que estás midiendo su respiración, ya que puede alterarla. Mírala mientras simulas seguir tomando el pulso. Cuenta cada elevación del pecho durante 1 minuto.\n\nNormal: 12-20 rpm.',
      'icon': Icons.air,
      'color': const Color(0xFF2980B9)
    },
    {
      'title': 'Temperatura Corporal',
      'instruction': '1. Asegúrate de que la axila esté seca.\n2. Coloca el termómetro y pide al paciente que cruce el brazo sobre el pecho.\n3. Espera el tiempo indicado (o el pitido).\n\nNormal: 36.5°C - 37.2°C.',
      'icon': Icons.thermostat,
      'color': AppColors.warning
    }
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      Navigator.pop(context); // Finalizar tutorial
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final isLast = _currentStep == _steps.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tutorial: Toma de Signos', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
           decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Indicador de progreso
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                color: step['color'],
                minHeight: 12,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 32),
              
              // Icono animado grande
              Hero(
                tag: 'tutorial_icon',
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: step['color'].withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(step['icon'], size: 80, color: step['color']),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              // Título y texto
              Text(
                step['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: step['color'],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  step['instruction'],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              
              // Botón siguiente "Bouncy"
              SizedBox(
                width: double.infinity,
                child: BouncyCard(
                  baseColor: isLast ? AppColors.success : step['color'],
                  shadowColor: HSLColor.fromColor(isLast ? AppColors.success : step['color']).withLightness((HSLColor.fromColor(isLast ? AppColors.success : step['color']).lightness - 0.15).clamp(0.0, 1.0)).toColor(),
                  onTap: _nextStep,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      isLast ? '¡TERMINAR Y APLICAR!' : 'CONTINUAR',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
