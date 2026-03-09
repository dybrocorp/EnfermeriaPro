import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'procedure_detail_screen.dart';
import 'handwashing_tutorials_screen.dart';

class SurgeryScreen extends StatelessWidget {
  const SurgeryScreen({super.key});

  final List<Map<String, dynamic>> _surgeryProcedures = const [
    {
      'title': 'Lavado de Manos Quirúrgico',
      'description': 'Técnica rigurosa para eliminar flora transitoria y reducir la resistente antes de un procedimiento quirúrgico.',
      'icon': Icons.clean_hands,
      'materials': [
        'Lavabo quirúrgico con pedal o sensor',
        'Jabón antiséptico (Clorhexidina al 4% o Yodopovidona)',
        'Cepillo quirúrgico estéril',
        'Limpiauñas',
        'Toalla estéril'
      ],
      'steps': [
        'Retirar todas las joyas (anillos, relojes, pulseras) y ajustar ropa quirúrgica y mascarilla adecuadamente.',
        'Humedecer manos, muñecas y antebrazos bajo el agua.',
        'Primer Tiempo: Aplicar jabón y lavar friccionando las manos (palmas, dorsos, interdigitales).',
        'Usar el cepillo/esponja estéril para limpiar meticulosamente bajo las uñas.',
        'Cepillar cada dedo, espacios interdigitales, palma y dorso de la mano.',
        'Extender el lavado cepillando con movimientos circulares descendentes por los antebrazos hasta 5 cm POR ENCIMA del codo.',
        'Enjuagar manteniendo siempre las manos por encima del nivel de los codos para que el agua escurra hacia los codos.',
        'Segundo Tiempo: Repetir el proceso pero llegando SOLO hasta el tercio medio del antebrazo.',
        'Tercer Tiempo: Repetir proceso llegando SOLO hasta la muñeca.',
        'Enjuague final asegurando que no queden residuos.',
        'Ingresar a quirófano con las manos en alto y secar con toalla estéril mediante toques (sin frotar).'
      ]
    },
    {
      'title': 'Curación Avanzada de Heridas',
      'description': 'Manejo aséptico y técnica estéril para curar heridas postquirúrgicas, infectadas o complejas.',
      'icon': Icons.healing,
      'materials': [
        'Guantes limpios (para retirar apósito sucio)',
        'Guantes estériles (para la curación)',
        'Equipo de curación estéril (pinzas Kelly/mosquito, tijeras)',
        'Solución salina normal 0.9%',
        'Gasas estériles',
        'Apósitos primarios o secundarios (según indicación: alginatos, hidrogeles, etc.)',
        'Microporo o fixomull para fijar',
        'Recipiente o bolsa para desechos biológicos'
      ],
      'steps': [
        'Lavado de manos clínico y uso de EPP (mascarilla importante si hay riesgo de salpicaduras).',
        'Explicar al paciente, descubrir el área y colocar un protector de cama.',
        'Con guantes limpios, retirar el parche/apósito sucio valorando la cantidad y tipo de exudado. Desechar guantes y apósito.',
        'Lavado de manos o aplicación de alcohol gel.',
        'Abrir equipo estéril asépticamente y colocarse los guantes estériles.',
        'Irrigar la herida suavemente con Solución Salina para retirar detritos (evitar alta presión que dañe el tejido de granulación).',
        'Secar los bordes (piel perilesional) de la herida con gasa estéril a toques.',
        'Si es necesario desbridar tejido necrótico, usar bisturí o pinza y tijera (según protocolo o indicación médica).',
        'Aplicar el apósito primario indicado directamente sobre el lecho de la herida.',
        'Cubrir con apósito secundario estéril y fijarlo firmemente con la cinta adhesiva.',
        'Rotular con fecha y firma.',
        'Desechar materiales, retirarse guantes y lavado de manos clínico.'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quirófanos y Curaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildVideoHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _surgeryProcedures.length,
              itemBuilder: (context, index) {
          final proc = _surgeryProcedures[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.3), width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(proc['icon'], color: AppColors.primaryDark, size: 28),
              ),
              title: Text(
                proc['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(proc['description'], style: const TextStyle(color: AppColors.textSecondary)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primaryDark, size: 16),
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

  Widget _buildVideoHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HandwashingTutorialsScreen()),
          );
        },
        child: const Row(
          children: [
            Icon(Icons.video_library, color: AppColors.secondary, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video Tutoriales',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary),
                  ),
                  Text(
                    'Ver técnicas de lavado de manos',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.secondary, size: 16),
          ],
        ),
      ),
    );
  }
}
