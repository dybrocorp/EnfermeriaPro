import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/video_tutorial_card.dart';
import '../widgets/banner_ad_widget.dart';

class HandwashingTutorialsScreen extends StatelessWidget {
  const HandwashingTutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tutoriales de Lavado de Manos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Técnicas de Higiene',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aprende las técnicas correctas según los estándares de la OMS para prevenir infecciones.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  const VideoTutorialCard(
                    title: 'Lavado de Manos Clínico',
                    videoId: '9W6BOGFjnxs', // Nuevo video clínico
                    duration: '40-60 SEG',
                    description:
                        'Técnica obligatoria antes y después del contacto con cada paciente, después de quitarse los guantes o tener contacto con fluidos.',
                  ),

                  const VideoTutorialCard(
                    title: 'Lavado de Manos Quirúrgico',
                    videoId: '4STyxXHIAxU', // Nuevo video quirúrgico
                    duration: '3-5 MIN',
                    description:
                        'Procedimiento riguroso antes de cualquier intervención invasiva o ingreso a quirófano. Incluye manos y antebrazos.',
                  ),

                  const SizedBox(height: 16),
                  _buildTipsCard(),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      color: AppColors.info.withValues(alpha: 0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.info, width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.info),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Recuerda: El lavado de manos es la medida más importante para prevenir enfermedades.',
                style: TextStyle(
                  color: AppColors.info,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
