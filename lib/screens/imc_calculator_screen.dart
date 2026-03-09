import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/banner_ad_widget.dart';

class IMCCalculatorScreen extends StatefulWidget {
  const IMCCalculatorScreen({super.key});

  @override
  State<IMCCalculatorScreen> createState() => _IMCCalculatorScreenState();
}

class _IMCCalculatorScreenState extends State<IMCCalculatorScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double? _result;
  String _message = '';
  Color _messageColor = AppColors.textPrimary;

  void _calculate() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa valores válidos')),
      );
      return;
    }

    setState(() {
      // height is expected in meters if it's < 3, else converted from cm
      final heightInMeters = height > 3 ? height / 100 : height;
      _result = weight / (heightInMeters * heightInMeters);
      
      if (_result! < 18.5) {
        _message = 'Bajo peso';
        _messageColor = Colors.orange;
      } else if (_result! < 25) {
        _message = 'Peso normal';
        _messageColor = AppColors.success;
      } else if (_result! < 30) {
        _message = 'Sobrepeso';
        _messageColor = Colors.orange;
      } else {
        _message = 'Obesidad';
        _messageColor = AppColors.danger;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calculadora de IMC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  if (_result != null) _buildResultCard(),
                  const SizedBox(height: 20),
                  _buildExplanationCard(),
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
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                prefixIcon: Icon(Icons.fitness_center),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura (cm o m)',
                prefixIcon: Icon(Icons.height),
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
              child: const Text('CALCULAR', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _messageColor, width: 2),
      ),
      child: Column(
        children: [
          const Text('Tu IMC es:', style: TextStyle(fontSize: 16)),
          Text(
            _result!.toStringAsFixed(1),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _messageColor),
          ),
          Text(
            _message,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _messageColor),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rangos OMS:', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            Text('• < 18.5: Bajo peso'),
            Text('• 18.5 - 24.9: Normal'),
            Text('• 25.0 - 29.9: Sobrepeso'),
            Text('• > 30.0: Obesidad'),
          ],
        ),
      ),
    );
  }
}
