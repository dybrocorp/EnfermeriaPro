import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnatomySystemsScreen extends StatelessWidget {
  const AnatomySystemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final systems = [
      {
        'name': 'Sistema Cardiovascular', 
        'icon': Icons.favorite, 
        'desc': 'Corazón y red de vasos sanguíneos.',
        'details': '• El corazón es una bomba de 4 cavidades.\n• Circulación Mayor: Del ventrículo izquierdo a los tejidos.\n• Circulación Menor: Del ventrículo derecho a los pulmones.\n• Arterias (Eferentes) vs Venas (Aferentes).'
      },
      {
        'name': 'Sistema Respiratorio', 
        'icon': Icons.air, 
        'desc': 'Intercambio gaseoso y hematosis.',
        'details': '• Intercambio de O2 y CO2 en los alvéolos.\n• Controlado por el centro respiratorio en el bulbo raquídeo.\n• El diafragma es el principal músculo inspiratorio.'
      },
      {
        'name': 'Sistema Nervioso', 
        'icon': Icons.psychology, 
        'desc': 'Control central y periférico.',
        'details': '• SNC: Encéfalo y Médula Espinal.\n• SNP: Nervios y ganglios.\n• Somático (Voluntario) y Autonómico (Involuntario: Simpático/Parasimpático).'
      },
      {
        'name': 'Sistema Óseo', 
        'icon': Icons.accessibility, 
        'desc': 'Estructura ósea de 206 huesos.',
        'details': '• Funciones: Soporte, protección, movimiento y hematopoyesis.\n• Compuesto por tejido óseo compacto y esponjoso.'
      },
      {
        'name': 'Sistema Muscular', 
        'icon': Icons.fitness_center, 
        'desc': 'Más de 600 músculos para el movimiento.',
        'details': '• Tipos: Esquelético (Estriado), Liso (Vísceras) y Cardíaco.\n• Propiedades: Excitabilidad, contractilidad, extensibilidad.'
      },
      {
        'name': 'Sistema Digestivo', 
        'icon': Icons.restaurant, 
        'desc': 'Transformación de alimentos en energía.',
        'details': '• Digestión mecánica y química.\n• Hígado y Páncreas como glándulas anexas críticas.'
      },
      {
        'name': 'Sistema Urinario', 
        'icon': Icons.water_drop, 
        'desc': 'Filtración y excreción de desechos.',
        'details': '• La nefrona es la unidad funcional del riñón.\n• Regulación del equilibrio ácido-base y electrolitos.'
      },
      {
        'name': 'Sistema Endocrino', 
        'icon': Icons.science, 
        'desc': 'Regulación hormonal del cuerpo.',
        'details': '• Glándulas: Hipófisis, Tiroides, Suprarrenales, Páncreas, Gónadas.\n• Control homeostático a largo plazo.'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sistemas de Anatomía', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: systems.length,
        itemBuilder: (context, index) {
          final system = systems[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(system['icon'] as IconData, color: AppColors.primary, size: 30),
              ),
              title: Text(
                system['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
              ),
              subtitle: Text(system['desc'] as String, style: const TextStyle(color: AppColors.textSecondary)),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  color: AppColors.background,
                  child: Text(
                    system['details'] as String,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary),
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
