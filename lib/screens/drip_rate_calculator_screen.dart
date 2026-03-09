import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/banner_ad_widget.dart';

class DripRateCalculatorScreen extends StatefulWidget {
  const DripRateCalculatorScreen({super.key});

  @override
  State<DripRateCalculatorScreen> createState() => _DripRateCalculatorScreenState();
}

class _DripRateCalculatorScreenState extends State<DripRateCalculatorScreen> {
  final _volumeController = TextEditingController();
  final _timeController = TextEditingController();
  double? _dropsPerMinute;
  double? _microDropsPerMinute;

  void _calculate() {
    final volume = double.tryParse(_volumeController.text);
    final timeHours = double.tryParse(_timeController.text);

    if (volume == null || timeHours == null || timeHours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa valores válidos')),
      );
      return;
    }

    setState(() {
      // Formula: (Volume * DropFactor) / (Time in minutes)
      // Standard drop factor: 10, 15, or 20 drops/ml. Macro: 10 or 15. Micro: 60.
      // Usually Macro drops/min = Volume / (Time * 3)
      _dropsPerMinute = volume / (timeHours * 3);
      _microDropsPerMinute = volume / timeHours;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Control de Goteo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInputCard(),
                  if (_dropsPerMinute != null) _buildResultCard(),
                  const SizedBox(height: 20),
                  _buildInfoCard(),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _volumeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Volumen total (ml)',
                prefixIcon: Icon(Icons.water_drop),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tiempo (horas)',
                prefixIcon: Icon(Icons.timer),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('CALCULAR GOTEO', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Column(
      children: [
        _resultItem('Macro-goteo', _dropsPerMinute!, 'gotas/min'),
        const SizedBox(height: 10),
        _resultItem('Micro-goteo', _microDropsPerMinute!, 'microgotas/min'),
      ],
    );
  }

  Widget _resultItem(String title, double value, String unit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          Text(unit, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Fórmulas utilizadas:', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            Text('• Macro: Vol / (Tiempo hr x 3)'),
            Text('• Micro: Vol / Tiempo hr'),
            Text('\nNota: Basado en factor goteo estándar (20 gtt/ml macro, 60 gtt/ml micro).'),
          ],
        ),
      ),
    );
  }
}
