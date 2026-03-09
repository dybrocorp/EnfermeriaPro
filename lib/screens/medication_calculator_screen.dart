import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/notification_helper.dart';
import '../widgets/banner_ad_widget.dart';

class MedicationCalculatorScreen extends StatefulWidget {
  const MedicationCalculatorScreen({super.key});

  @override
  State<MedicationCalculatorScreen> createState() => _MedicationCalculatorScreenState();
}

class _MedicationCalculatorScreenState extends State<MedicationCalculatorScreen> {
  final TextEditingController _presentacionCantController = TextEditingController(); // mg/g
  final TextEditingController _presentacionVolController = TextEditingController(); // ml
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _diluyenteController = TextEditingController();

  String _unidadPresentacion = 'mg';
  double? _resultado;

  void _calcular() async {
    FocusScope.of(context).unfocus();
    
    final cantPresentacion = double.tryParse(_presentacionCantController.text.replaceAll(',', '.'));
    final volPresentacion = double.tryParse(_presentacionVolController.text.replaceAll(',', '.'));
    final dosisRequerida = double.tryParse(_dosisController.text.replaceAll(',', '.'));
    final volADiluir = double.tryParse(_diluyenteController.text.replaceAll(',', '.'));

    if (cantPresentacion != null && volPresentacion != null && dosisRequerida != null && volADiluir != null) {
      if (cantPresentacion <= 0) return;

      // Unificar unidades a mg
      double cantMg = _unidadPresentacion == 'g' ? cantPresentacion * 1000 : cantPresentacion;
      
      setState(() {
        // Fórmula: (Dosis requerida * Volumen final dilución) / Cantidad en Presentación
        _resultado = (dosisRequerida * volADiluir) / cantMg;
      });

      // Notificación Pop Push
      await NotificationHelper.showNotification(
        id: 1,
        title: 'Cálculo Realizado',
        body: 'Volumen a administrar: ${_resultado!.toStringAsFixed(2)} ml',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos correctamente'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void _limpiar() {
    _presentacionCantController.clear();
    _presentacionVolController.clear();
    _dosisController.clear();
    _diluyenteController.clear();
    setState(() {
      _resultado = null;
    });
  }

  @override
  void dispose() {
    _presentacionCantController.dispose();
    _presentacionVolController.dispose();
    _dosisController.dispose();
    _diluyenteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cálculo de Dosis', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
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
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Parámetros del Cálculo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Presentación del medicamento:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildInputField('Cantidad', 'Ej. 500', _presentacionCantController),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _unidadPresentacion,
                        items: ['mg', 'g'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _unidadPresentacion = val!),
                      ),
                      const SizedBox(width: 8),
                      const Text('en'),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildInputField('Volumen (ml)', 'Ej. 5', _presentacionVolController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField('Dosis Indicada (mg)', 'Dosis que pide el médico', _dosisController, icon: Icons.medical_information),
                  const SizedBox(height: 16),
                  _buildInputField('Diluir en volumen final de (ml)', 'Volumen para diluir', _diluyenteController, icon: Icons.water_drop),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _limpiar,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: AppColors.warning,
                            side: const BorderSide(color: AppColors.warning),
                          ),
                          child: const Text('Limpiar', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _calcular,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Calcular', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_resultado != null) _buildResultCard(),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: AppColors.primaryLight.withValues(alpha: 0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb, color: AppColors.primary, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tip Educacional',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Recuerda siempre verificar los "10 correctos" de la administración de medicamentos antes de proceder. La fórmula usada aquí es: (Dosis * Diluyente) / Presentación.',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, {IconData icon = Icons.edit_note}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: AppColors.secondary),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Volumen a Administrar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_resultado!.toStringAsFixed(2)} ml',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
