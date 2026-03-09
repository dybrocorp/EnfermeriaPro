import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnatomyScreen extends StatelessWidget {
  const AnatomyScreen({super.key});

  final List<Map<String, String>> _systems = const [
    {
      'title': 'Sistema Cardiovascular',
      'icon': 'favorite',
      'description': 'Corazón y red de vasos sanguíneos. El corazón es una bomba de 4 cavidades.',
      'details': '• El corazón es una bomba de 4 cavidades.\n• Circulación Mayor: Del ventrículo izquierdo a los tejidos.\n• Circulación Menor: Del ventrículo derecho a los pulmones.\n• Arterias (Eferentes) vs Venas (Aferentes).'
    },
    {
      'title': 'Sistema Respiratorio',
      'icon': 'air',
      'description': 'Vías aéreas y pulmones. Encargado del intercambio gaseoso (hematosis).',
      'details': '• Intercambio de O2 y CO2 en los alvéolos.\n• Controlado por el centro respiratorio en el bulbo raquídeo.\n• El diafragma es el principal músculo inspiratorio.'
    },
    {
      'title': 'Sistema Nervioso',
      'icon': 'psychology',
      'description': 'Red de control central y periférico de funciones corporales.',
      'details': '• SNC: Encéfalo y Médula Espinal.\n• SNP: Nervios y ganglios.\n• Somático (Voluntario) y Autonómico (Involuntario: Simpático/Parasimpático).'
    },
    {
      'title': 'Sistema Óseo (Esquelético)',
      'icon': 'accessibility',
      'description': 'Estructura soporte de 206 huesos. Protección y hematopoyesis.',
      'details': '• Huesos (206 adultos): Soporte, protección y hematopoyesis.\n• Compuesto por tejido óseo compacto y esponjoso.'
    },
    {
      'title': 'Sistema Muscular',
      'icon': 'fitness_center',
      'description': 'Más de 600 músculos que permiten el movimiento y estabilidad.',
      'details': '• Tipos: Esquelético (Estriado), Liso (Vísceras) y Cardíaco.\n• Propiedades: Excitabilidad, contractilidad, extensibilidad.'
    },
    {
      'title': 'Sistema Digestivo',
      'icon': 'restaurant',
      'description': 'Transformación de alimentos en energía y eliminación de desechos.',
      'details': '• Tubo: Boca, esófago, estómago, intestino delgado y grueso.\n• Glándulas anexas: Hígado (bilis), Páncreas (jugos digestivos e insulina).'
    },
    {
      'title': 'Sistema Urinario',
      'icon': 'water_drop',
      'description': 'Filtración de sangre y excreción de desechos a través de la orina.',
      'details': '• La nefrona es la unidad funcional del riñón.\n• Regulación del equilibrio ácido-base y electrolitos.'
    },
    {
      'title': 'Sistema Endocrino',
      'icon': 'science',
      'description': 'Regulación hormonal para el control homeostático a largo plazo.',
      'details': '• Glándulas: Hipófisis, Tiroides, Suprarrenales, Páncreas, Gónadas.\n• Control de crecimiento, metabolismo y reproducción.'
    }
  ];

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'favorite': return Icons.favorite;
      case 'air': return Icons.air;
      case 'psychology': return Icons.psychology;
      case 'accessibility': return Icons.accessibility;
      case 'fitness_center': return Icons.fitness_center;
      case 'restaurant': return Icons.restaurant;
      case 'water_drop': return Icons.water_drop;
      case 'science': return Icons.science;
      default: return Icons.accessibility_new;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Atlas de Anatomía', style: TextStyle(fontWeight: FontWeight.bold)),
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
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(_getIcon(sys['icon']), color: AppColors.primary),
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
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    sys['details']!,
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
