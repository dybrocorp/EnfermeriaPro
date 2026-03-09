import 'package:flutter/material.dart';
import '../services/vademecum_service.dart';
import '../utils/app_colors.dart';

class MedicamentoDetailScreen extends StatelessWidget {
  final Medicamento medicamento;

  const MedicamentoDetailScreen({super.key, required this.medicamento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(medicamento.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: 'Información General',
              icon: Icons.info,
              children: [
                _buildInfoRow('Nombre Genérico', medicamento.nombre),
                _buildInfoRow('Marca Común', medicamento.marcaComun),
                _buildInfoRow('Grupo Farmacológico', medicamento.grupoFarmacologico),
                _buildInfoRow('Subgrupo', medicamento.subgrupo),
                _buildInfoRow('ATC Aproximado', medicamento.atc),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Presentación y Administración',
              icon: Icons.medication,
              children: [
                _buildInfoRow('Presentación', medicamento.presentacion),
                _buildInfoRow('Vía de Administración', medicamento.viaAdministracion),
                _buildInfoRow('Laboratorios en Colombia', medicamento.laboratorios),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Uso Clínico',
              icon: Icons.medical_services,
              children: [
                _buildInfoRow('Indicaciones Principales', medicamento.indicaciones),
                const Divider(),
                _buildInfoRow('Dosis Adulto Referencial', medicamento.dosisAdulto),
                _buildInfoRow('Dosis Pediátrica Referencial', medicamento.dosisPediatrica),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Seguridad y Precauciones',
              icon: Icons.warning_amber_rounded,
              children: [
                _buildInfoRow('Categoría Embarazo', medicamento.categoriaEmbarazo),
                _buildInfoRow('Contraindicaciones', medicamento.contraindicaciones),
                _buildInfoRow('Efectos Adversos Comunes', medicamento.efectosAdversos),
                _buildInfoRow('Interacciones Importantes', medicamento.interacciones),
              ],
            ),
            const SizedBox(height: 80), // Espacio para el anuncio
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
