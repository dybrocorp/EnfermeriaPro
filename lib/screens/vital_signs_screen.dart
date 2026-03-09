import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bouncy_card.dart';
import 'vitals_tutorial_screen.dart';

class VitalSignsScreen extends StatelessWidget {
  const VitalSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Signos Vitales', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Valores Normales y Alertas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Botón del Tutorial Visual (Gamificado)
          BouncyCard(
            baseColor: AppColors.secondary,
            shadowColor: AppColors.secondaryDark,
            elevation: 8.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VitalsTutorialScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aprender Paso a Paso',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Guía interactiva para toma de signos vitales.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildVitalSignCard(
            title: 'Frecuencia Cardíaca (FC)',
            normalRange: '60 - 100 lpm',
            alerts: [
              {'text': 'Bradicardia: < 60 lpm', 'color': AppColors.warning},
              {'text': 'Taquicardia: > 100 lpm', 'color': AppColors.danger},
            ],
            icon: Icons.favorite,
            iconColor: AppColors.danger,
          ),
          _buildVitalSignCard(
            title: 'Presión Arterial (PA) y PAM',
            normalRange: 'Sist: 90-120 | Diast: 60-80 | PAM: 70-105 mmHg',
            alerts: [
              {'text': 'Hipotensión: < 90/60 mmHg', 'color': AppColors.warning},
              {'text': 'Hipertensión: ≥ 140/90 mmHg', 'color': AppColors.danger},
              {'text': 'PAM Crítica: < 65 mmHg', 'color': Colors.redAccent.shade700},
            ],
            icon: Icons.monitor_heart,
            iconColor: AppColors.secondary,
            description: 'Presión Arterial Media (PAM) = (Sist + 2*Diast) / 3',
          ),
          _buildVitalSignCard(
            title: 'Frecuencia Respiratoria (FR)',
            normalRange: '12 - 20 rpm',
            alerts: [
              {'text': 'Bradipnea: < 12 rpm', 'color': AppColors.warning},
              {'text': 'Taquipnea: > 20 rpm', 'color': AppColors.danger},
            ],
            icon: Icons.air,
            iconColor: Colors.lightBlue,
          ),
          _buildVitalSignCard(
            title: 'Temperatura (Temp)',
            normalRange: '36.5°C - 37.5°C',
            alerts: [
              {'text': 'Hipotermia: < 35.0°C', 'color': Colors.blueAccent},
              {'text': 'Febrícula: 37.6°C - 37.9°C', 'color': AppColors.warning},
              {'text': 'Hipertermia / Fiebre: ≥ 38.0°C', 'color': AppColors.danger},
            ],
            icon: Icons.thermostat,
            iconColor: Colors.orange,
          ),
          _buildVitalSignCard(
            title: 'Saturación de Oxígeno (SpO2)',
            normalRange: '95% - 100%',
            alerts: [
              {'text': 'Hipoxia leve: 91% - 94%', 'color': AppColors.warning},
              {'text': 'Hipoxia severa: ≤ 90%', 'color': AppColors.danger},
            ],
            icon: Icons.water_drop,
            iconColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignCard({
    required String title,
    required String normalRange,
    required List<Map<String, dynamic>> alerts,
    required IconData icon,
    required Color iconColor,
    String? description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
              ),
            ],
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Normal: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                      ...normalRange.split(' | ').asMap().entries.map((entry) {
                        final index = entry.key;
                        final part = entry.value;
                        final parts = normalRange.split(' | ');
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            index == parts.length - 1 ? part : '$part |',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...alerts.map((alert) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: alert['color'], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alert['text'],
                        style: TextStyle(
                          fontSize: 15,
                          color: alert['color'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
