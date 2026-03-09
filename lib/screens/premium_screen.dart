import 'package:flutter/material.dart';
import '../services/premium_service.dart';
import '../utils/app_colors.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isPremium = PremiumService.isPremium;

  void _togglePremium() async {
    final newValue = !_isPremium;
    await PremiumService.setPremium(newValue);
    setState(() {
      _isPremium = newValue;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newValue ? '¡Ahora eres Premium!' : 'Modo gratuito activado'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes y Premium'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Enfermería Pro Premium',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Desbloquea todas las funciones y elimina la publicidad.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            _buildFeatureRow(Icons.block, 'Sin anuncios publicitarios'),
            _buildFeatureRow(Icons.alarm_on, 'Alertas de calendario prioritarias'),
            _buildFeatureRow(Icons.offline_pin, 'Contenido exclusivo offline'),
            _buildFeatureRow(Icons.support_agent, 'Soporte prioritario'),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _togglePremium,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPremium ? Colors.grey : AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _isPremium ? 'Cancelar Suscripción (Demo)' : 'Obtener Premium por \$1.99',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
