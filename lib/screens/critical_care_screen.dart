import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'procedure_detail_screen.dart';

class CriticalCareScreen extends StatelessWidget {
  const CriticalCareScreen({super.key});

  final List<Map<String, dynamic>> _criticalProcedures = const [
    {
      'title': 'Manejo Avanzado de Vía Aérea (Intubación)',
      'description': 'Asistencia y preparación para la intubación endotraqueal en paciente crítico.',
      'icon': Icons.air,
      'materials': [
        'Laringoscopio comprobado (hojas curvas Mac/rectas Miller)',
        'Tubos endotraqueales (TOT) de distintos tamaños',
        'Guía o fiador (Mandril)',
        'Jeringa de 10cc para el Neumotaponador (Cuff)',
        'Dispositivo bolsa-válvula-mascarilla (Ambu) conectado a O2 al 100%',
        'Cánulas orofaríngeas (Guedel)',
        'Aspirador de secreciones funcionando y sondas de aspiración Yankauer/Flexibles',
        'Sedación/Analgesia/Relajador muscular indicado',
        'Fijador de tubo o esparadrapo'
      ],
      'steps': [
        'Preparación (Regla Nemotécnica SOAPME): Succión, Oxígeno, Vía Aérea (Airway), Fármacos (Pharmacy), Monitorización, Equipo.',
        'Preoxigenar al paciente al 100% durante 3-5 minutos con bolsa-mascarilla.',
        'Asegurar vía venosa permeable y monitorización continua (ECG, SpO2, PA).',
        'Administrar la secuencia de inducción rápida (Midazolam, Fentanilo, Propofol, Rocuronio/Succinilcolina) según indicación médica.',
        'Asistir al médico entregando el laringoscopio y posteriormente el tubo endotraqueal con la guía preparada.',
        'Una vez insertado, retirar la guía e inflar inmediatamente el Cuff (neumotaponador) con la jeringa (aprox 7-10cc para evitar fugas y aspiraciones).',
        'Conectar al ventilador mecánico o bolsear mientras se comprueba la ventilación bilateral auscultando ápices y bases pulmonares, y epigastrio.',
        'Asegurar el tubo endotraqueal en la comisura labial fijando la medida insertada (ej. 22 cm a nivel dentario).',
        'Aspirar secreciones de ser necesario.'
      ]
    },
    {
      'title': 'Catéter Venoso Central (CVC) - Asistencia',
      'description': 'Cuidados y asistencia durante la inserción de un acceso venoso central (Yugular, Subclavio, Femoral).',
      'icon': Icons.vaccines,
      'materials': [
        'Set de Catéter Venoso Central (1, 2 o 3 lúmenes)',
        'Equipo de Ropa Estéril (Batas, gorros, mascarillas, guantes, campos amplios)',
        'Solución de Clorhexidina al 2% con alcohol o Yodopovidona',
        'Lidocaína al 1% o 2% sin epinefrina para anestesia local',
        'Jeringas y agujas estériles',
        'Sutura de seda con aguja recta o curva para fijación',
        'Solución salina en jeringas para purgar lúmenes',
        'Apósito transparente estéril'
      ],
      'steps': [
        'Explicar procedimiento y obtener consentimiento informado.',
        'Monitorizar al paciente constantemente.',
        'Colocar al paciente en posición de Trendelenburg (si es yugular/subclavia) para ingurgitar la vena y reducir riesgo de embolia gaseosa.',
        'Material: Purgar previamente cada lumen del catéter con solución salina heparinizada o normal, y clampear.',
        'Asistir en la antisepsia quirúrgica del área y proporcionar técnica aséptica en la entrega del material.',
        'Monitorizar ECG estrictamente durante la inserción de la guía metálica para detectar arritmias (ej. extrasístoles).',
        'Una vez insertado el catéter, comprobar el retorno en todos los lúmenes y permeabilizar.',
        'Asistir en la fijación con sutura y colocar el apósito transparente.',
        'Solicitar RX de Tórax de control ANTES de instilar cualquier fármaco/fluido vesicante, para verificar posición de la punta (aurícula derecha/vena cava superior) y descartar neumotórax.'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cuidados Críticos (UCI/Urgencias)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.danger.withValues(alpha: 0.1),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.danger),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Atención en áreas críticas. Siga los protocolos hospitalarios estrictamente.',
                    style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _criticalProcedures.length,
              itemBuilder: (context, index) {
                final proc = _criticalProcedures[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.danger, width: 0.5),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                      radius: 24,
                      child: Icon(proc['icon'], color: AppColors.danger, size: 28),
                    ),
                    title: Text(
                      proc['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(proc['description'], style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.danger, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProcedureDetailScreen(procedure: proc),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
