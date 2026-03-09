import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnatomyScreen extends StatelessWidget {
  const AnatomyScreen({super.key});

  final List<Map<String, String>> _systems = const [
    {
      'title': 'Sistema Cardiovascular',
      'description': 'Corazón, vasos sanguíneos y sangre. Encargado del transporte de oxígeno, nutrientes y desechos.',
      'key_points': '• Corazón: Bomba muscular de 4 cavidades.\n• Arterias: Sangre oxigenada (excepto pulmonar).\n• Venas: Sangre desoxigenada (excepto pulmonar).\n• Sangre: Plasma, glóbulos rojos, glóbulos blancos y plaquetas.'
    },
    {
      'title': 'Sistema Respiratorio',
      'description': 'Vías aéreas y pulmones. Encargado del intercambio gaseoso (O2 y CO2).',
      'key_points': '• Vía aérea superior: Fosas nasales, faringe, laringe.\n• Vía aérea inferior: Tráquea, bronquios, bronquiolos.\n• Zona de intercambio: Alvéolos pulmonares.\n• Músculo principal: Diafragma.'
    },
    {
      'title': 'Sistema Digestivo',
      'description': 'Tubo digestivo y glándulas anexas. Ingestión, digestión, absorción y excreción.',
      'key_points': '• Tubo: Boca, esófago, estómago, intestino delgado y grueso.\n• Glándulas anexas: Hígado (bilis), Páncreas (jugos digestivos e insulina).\n• Absorción principal: Intestino delgado (duodeno, yeyuno, íleon).'
    },
    {
      'title': 'Sistema Nervioso',
      'description': 'Red de control e integración de funciones corporales.',
      'key_points': '• SNC (Central): Encéfalo y médula espinal.\n• SNP (Periférico): Nervios craneales y espinales.\n• SNA (Autónomo): Simpático (lucha/huida) y Parasimpático (reposo/digestión).'
    },
    {
      'title': 'Sistema Musculoesquelético',
      'description': 'Huesos, músculos, articulaciones, ligamentos y tendones. Da soporte y movimiento funcional al cuerpo.',
      'key_points': '• Huesos (206 adultos): Soporte, protección y hematopoyesis.\n• Músculos: Cardíaco, liso (órganos) y esquelético (movimiento voluntario).\n• Articulaciones: Conexión entre huesos.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Anatomía Fundamental', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _systems.length,
        itemBuilder: (context, index) {
          final sys = _systems[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.accessibility_new, color: Colors.white),
              ),
              title: Text(
                sys['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  sys['description']!,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    sys['key_points']!,
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
