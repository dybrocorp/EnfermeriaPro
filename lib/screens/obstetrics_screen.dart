import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ObstetricsScreen extends StatelessWidget {
  const ObstetricsScreen({super.key});

  final List<Map<String, String>> _topics = const [
    {
      'title': 'Control Prenatal',
      'description': 'Valoración periódica de la embarazada.',
      'details': '• Objetivo: Identificar factores de riesgo y prevenir complicaciones.\n• Frecuencia ideal: Mensual hasta semana 28, quincenal hasta 36, semanal hasta el parto.\n• Control Básico: Peso, Presión Arterial, Altura Uterina, Frecuencia Cardíaca Fetal (FCF), laboratorios (VDRL, VIH, BH, EGO).'
    },
    {
      'title': 'Signos de Alarma en el Embarazo',
      'description': 'Síntomas que requieren atención médica urgente.',
      'details': '• Sangrado transvaginal.\n• Salida de líquido amniótico (ruptura de membranas).\n• Cefalea intensa, acúfenos (zumbidos), fosfenos (visión borrosa o luces) -> Riesgo Preeclampsia.\n• Dolor abdominal intenso o contracciones uterinas antes de término.\n• Ausencia de movimientos fetales.'
    },
    {
      'title': 'Etapas del Trabajo de Parto',
      'description': 'Fases clínicas del nacimiento.',
      'details': '1. Primer Periodo (Dilatación y Borramiento): Desde el inicio de contracciones verdaderas hasta dilatación completa (10 cm).\n2. Segundo Periodo (Expulsivo): Desde dilatación completa hasta el nacimiento del bebé.\n3. Tercer Periodo (Alumbramiento): Expulsión de la placenta y membranas.'
    },
    {
      'title': 'Puerperio',
      'description': 'Periodo posparto y recuperación.',
      'details': '• Inmediato: Primeras 24 horas (Vigilancia estricta de hemorragia posparto, Tono uterino "Globo de seguridad de Pinard").\n• Mediato: Días 2 a 7.\n• Tardío: Del día 8 hasta los 42 días (6 semanas).\n• Cuidados: Fomentar lactancia materna exclusiva, vigilar características de los loquios (sangrado vaginal).'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Obstetricia y Materno-Fetal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFCE4EC), // Rosa claro materno
                child: Icon(Icons.pregnant_woman, color: Color(0xFFC2185B)),
              ),
              title: Text(
                topic['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  topic['description']!,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC).withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    topic['details']!,
                    style: const TextStyle(height: 1.5, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
