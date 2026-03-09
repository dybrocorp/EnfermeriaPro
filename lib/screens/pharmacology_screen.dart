import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PharmacologyScreen extends StatelessWidget {
  const PharmacologyScreen({super.key});

  final List<Map<String, dynamic>> _drugData = const [
    {
      'group': 'Analgésicos y Antipiréticos',
      'icon': Icons.healing,
      'color': Colors.red,
      'drugs': [
        {
          'name': 'Paracetamol',
          'presentations': 'Tabletas (500mg, 1g), Jarabe (150mg/5ml), Gotas, Supositorios.',
          'labs': 'Cinfa, Normon, Kern Pharma, Tylenol, Sanofi.',
          'indications': 'Dolor leve a moderado y fiebre.',
          'contraindications': 'Insuficiencia hepática grave, hipersensibilidad.',
          'nursing_notes': 'Monitorizar función hepática. No exceder 4g/día en adultos.'
        },
        {
          'name': 'Ibuprofeno',
          'presentations': 'Tabletas (400mg, 600mg), Suspensión oral (2%), Gel tópico.',
          'labs': 'Cinfa, Advil (Pfizer), Actron (Bayer).',
          'indications': 'Inflamación, dolor y fiebre.',
          'contraindications': 'Úlcera péptica activa, insuficiencia renal grave.',
          'nursing_notes': 'Administrar con alimentos para reducir irritación gástrica.'
        }
      ]
    },
    {
      'group': 'Antibióticos',
      'icon': Icons.biotech,
      'color': Colors.blue,
      'drugs': [
        {
          'name': 'Amoxicilina',
          'presentations': 'Cápsulas (500mg), Suspensión (250mg/5ml).',
          'labs': 'GlaxoSmithKline (Amoxil), Normon, Sandoz.',
          'indications': 'Infecciones bacterianas respiratorias, urinarias y de piel.',
          'contraindications': 'Alergia a penicilinas o cefalosporinas.',
          'nursing_notes': 'Vigilar reacciones alérgicas (rash, anafilaxia).'
        }
      ]
    },
    {
      'group': 'Antihipertensivos',
      'icon': Icons.favorite,
      'color': Colors.orange,
      'drugs': [
        {
          'name': 'Enalapril',
          'presentations': 'Tabletas (5mg, 10mg, 20mg).',
          'labs': 'MSD (Renitec), Cinfa, Pfizer.',
          'indications': 'Hipertensión arterial e insuficiencia cardíaca.',
          'contraindications': 'Embarazo, antecedentes de angioedema.',
          'nursing_notes': 'Controlar PA y potasio. Puede causar tos seca.'
        }
      ]
    },
    {
      'group': 'Antidiabéticos Orales',
      'icon': Icons.bloodtype,
      'color': Colors.purple,
      'drugs': [
        {
          'name': 'Metformina',
          'presentations': 'Tabletas (500mg, 850mg, 1000mg).',
          'labs': 'Merck (Glucophage), Sandoz, Teva.',
          'indications': 'Diabetes Mellitus Tipo 2.',
          'contraindications': 'Insuficiencia renal moderada/grave, acidosis láctica.',
          'nursing_notes': 'Valorar función renal periódicamente. Administrar con comidas.'
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farmacología Clínica', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _drugData.length,
        itemBuilder: (context, index) {
          final group = _drugData[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: (group['color'] as Color).withValues(alpha: 0.1),
                  child: Icon(group['icon'] as IconData, color: group['color'] as Color),
                ),
                title: Text(
                  group['group']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                children: (group['drugs'] as List).map<Widget>((drug) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ExpansionTile(
                        title: Text(drug['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        subtitle: Text(drug['indications'], style: const TextStyle(fontSize: 12)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Presentaciones', drug['presentations']),
                                const SizedBox(height: 8),
                                _buildDetailRow('Laboratorios', drug['labs']),
                                const SizedBox(height: 8),
                                _buildDetailRow('Contraindicaciones', drug['contraindications']),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.info_outline, size: 18, color: AppColors.warning),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Nota: ${drug['nursing_notes']}',
                                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDark)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
