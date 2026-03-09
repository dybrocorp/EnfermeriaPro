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
          'name': 'Acetaminofén (Paracetamol)',
          'presentations': 'Tabletas (500mg, 1g), Jarabe (150mg/5ml), Gotas, Supositorios.',
          'labs': 'Genfar, Tecnoquímicas (MK), La Santé, Sanofi (Winadol).',
          'indications': 'Dolor leve a moderado y fiebre.',
          'contraindications': 'Insuficiencia hepática grave.',
          'nursing_notes': 'Dosis máx: 4g/día. Antídoto: N-acetilcisteína.'
        },
        {
          'name': 'Dipirona (Metamizol)',
          'presentations': 'Ampollas (1g/2ml, 2.5g/5ml), Tabletas (500mg).',
          'labs': 'Genfar, Tecnoquímicas (MK), Vitalis, Eurofarma.',
          'indications': 'Dolor severo postoperatorio o traumático, fiebre refractaria.',
          'contraindications': 'Hipersensibilidad, agranulocitosis, hipotensión.',
          'nursing_notes': 'Administrar lento por IV (riesgo de hipotensión severa).'
        },
        {
          'name': 'Tramadol',
          'presentations': 'Gotas (100mg/ml), Ampollas (50mg, 100mg), Cápsulas.',
          'labs': 'Grünenthal (Tramal), Genfar, Tecnoquímicas.',
          'indications': 'Dolor moderado a severo.',
          'contraindications': 'Intoxicación aguda con alcohol/hipnóticos.',
          'nursing_notes': 'Vigilar náuseas, mareo y depresión respiratoria.'
        },
        {
          'name': 'Morfina',
          'presentations': 'Ampollas (10mg/1ml), Tabletas de liberación prolongada.',
          'labs': 'FNE (Fondo Nacional de Estupefacientes), Hospira.',
          'indications': 'Dolor agudo severo, edema agudo de pulmón.',
          'contraindications': 'Depresión respiratoria severa, asma bronquial aguda.',
          'nursing_notes': 'Control estricto de constantes vitales y escala de dolor.'
        }
      ]
    },
    {
      'group': 'Antibióticos',
      'icon': Icons.biotech,
      'color': Colors.blue,
      'drugs': [
        {
          'name': 'Ceftriaxona',
          'presentations': 'Vial liofilizado (1g, 500mg).',
          'labs': 'Genfar, Tecnoquímicas, Vitalis, Roche (Rocephin).',
          'indications': 'Infecciones graves (Meningitis, Neumonía, Sepsis).',
          'contraindications': 'Hipersensibilidad a cefalosporinas.',
          'nursing_notes': 'Reconstituir con lidocaína para IM o solución para IV.'
        },
        {
          'name': 'Vancomicina',
          'presentations': 'Vial (500mg, 1g).',
          'labs': 'Abbott, Pfizer, Vitalis, Genfar.',
          'indications': 'Infecciones por MRSA, colitis por C. difficile (vía oral).',
          'contraindications': 'Hipersensibilidad.',
          'nursing_notes': 'Diluir en 100-250ml e infundir en min 60m (Síndrome Hombre Rojo).'
        },
        {
          'name': 'Meropenem',
          'presentations': 'Vial (500mg, 1g).',
          'labs': 'AstraZeneca, Tecnoquímicas, Genfar.',
          'indications': 'Infecciones intra-abdominales complicadas, meningitis.',
          'contraindications': 'Hipersensibilidad a carbapenémicos.',
          'nursing_notes': 'Vigilar función renal y posible aparición de convulsiones.'
        },
        {
          'name': 'Clindamicina',
          'presentations': 'Ampollas (600mg/4ml), Cápsulas (300mg).',
          'labs': 'Genfar, La Santé, Pfizer (Dalacin).',
          'indications': 'Infecciones por anaerobios, acné severo.',
          'contraindications': 'Colitis pseudomembranosa.',
          'nursing_notes': 'Diluir bien para IV, riesgo de flebitis.'
        }
      ]
    },
    {
      'group': 'Anestésicos y Sedantes',
      'icon': Icons.airline_seat_flat,
      'color': Colors.teal,
      'drugs': [
        {
          'name': 'Lidocaína',
          'presentations': 'Frascos 1% y 2% (con y sin epinefrina), Spray, Gel.',
          'labs': 'Vitalis, Ropsohn, Zeyco.',
          'indications': 'Anestesia local, antiarrítmico (Clase Ib).',
          'contraindications': 'Bloqueo cardíaco severo, shock cardiogénico.',
          'nursing_notes': 'Vigilar signos de toxicidad del SNC (convulsiones).'
        },
        {
          'name': 'Propofol',
          'presentations': 'Ampollas/Frascos emulsión (10mg/ml).',
          'labs': 'B. Braun, Fresenius Kabi, AstraZeneca (Diprivan).',
          'indications': 'Inducción y mantenimiento de anestesia, sedación en UCI.',
          'contraindications': 'Alergia al huevo/soja.',
          'nursing_notes': 'Técnica aséptica rigurosa (emulsión lipídica favorece bacterias).'
        },
        {
          'name': 'Bupivacaína',
          'presentations': 'Frascos 0.5% (Isobárica e Hiperbárica).',
          'labs': 'Vitalis, Ropsohn, AstraZeneca (Marcaine).',
          'indications': 'Anestesia regional, epidural y espinal.',
          'contraindications': 'Infección en sitio de punción, coagulopatía.',
          'nursing_notes': 'Vigilar nivel de bloqueo sensorial y motor.'
        },
        {
          'name': 'Fentanilo',
          'presentations': 'Ampollas (0.5mg/10ml - 50mcg/ml).',
          'labs': 'FNE, Vitalis, Janssen (Sublimaze).',
          'indications': 'Analgesia quirúrgica, sedación en ventilación mecánica.',
          'contraindications': 'Depresión respiratoria aguda.',
          'nursing_notes': 'Potente opioide. Vigilar rigidez torácica y oximetría.'
        }
      ]
    },
    {
      'group': 'Antihipertensivos y Cardiovascular',
      'icon': Icons.favorite,
      'color': Colors.orange,
      'drugs': [
        {
          'name': 'Losartán',
          'presentations': 'Tabletas (50mg, 100mg).',
          'labs': 'Genfar, Tecnoquímicas, La Santé, MSD (Cozaar).',
          'indications': 'Hipertensión arterial, nefropatía diabética.',
          'contraindications': 'Embarazo, estenosis bilateral de arteria renal.',
          'nursing_notes': 'Vigilar niveles de potasio sérico.'
        },
        {
          'name': 'Amlodipino',
          'presentations': 'Tabletas (5mg, 10mg).',
          'labs': 'Genfar, Procaps, Pfizer (Norvasc).',
          'indications': 'Hipertensión, angina de pecho.',
          'contraindications': 'Hipotensión severa, shock.',
          'nursing_notes': 'Vigilar edema en miembros inferiores.'
        }
      ]
    },
    {
      'group': 'Gastrointestinales',
      'icon': Icons.restaurant,
      'color': Colors.green,
      'drugs': [
        {
          'name': 'Omeprazol',
          'presentations': 'Cápsulas (20mg), Vial (40mg).',
          'labs': 'Genfar, Tecnoquímicas, AstraZeneca (Losec).',
          'indications': 'Gastritis, úlcera péptica, reflujo gastroesofágico.',
          'contraindications': 'Hipersensibilidad.',
          'nursing_notes': 'Administrar 30-60 min antes de la comida. IV pasar lento.'
        },
        {
          'name': 'Metoclopramida',
          'presentations': 'Ampollas (10mg/2ml), Gotas, Tabletas (10mg).',
          'labs': 'Vitalis, Genfar, Procaps.',
          'indications': 'Náuseas y vómitos, gastroparesia.',
          'contraindications': 'Obstrucción intestinal, hemorragia digestiva.',
          'nursing_notes': 'Vigilar efectos extrapiramidales (distonía).'
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
