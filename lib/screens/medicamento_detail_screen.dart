import 'package:flutter/material.dart';
import '../services/vademecum_service.dart';
import '../utils/app_colors.dart';

// Repetimos el mapeo de categorías para coherencia visual
const Map<String, _CategoriaInfo> _categoriaInfo = {
  'Analgésicos': _CategoriaInfo(
    color: Color(0xFFFF5252), 
    icon: Icons.personal_injury_rounded,
  ),
  'Antibióticos': _CategoriaInfo(
    color: Color(0xFF00C853), 
    icon: Icons.biotech_rounded,
  ),
  'Cardiovascular': _CategoriaInfo(
    color: Color(0xFFE91E63), 
    icon: Icons.favorite_rounded,
  ),
  'Respiratorio': _CategoriaInfo(
    color: Color(0xFF00B0FF), 
    icon: Icons.air_rounded,
  ),
  'Endocrinología (Hormonales)': _CategoriaInfo(
    color: Color(0xFFFFAB00), 
    icon: Icons.water_drop_rounded,
  ),
  'Gástrico (Poliácidos)': _CategoriaInfo(
    color: Color(0xFF795548), 
    icon: Icons.restaurant_rounded,
  ),
  'Psiquiátricos': _CategoriaInfo(
    color: Color(0xFF6200EA), 
    icon: Icons.psychology_rounded,
  ),
  'Digestivo y Metabólico': _CategoriaInfo(
      color: Color(0xFF4CAF50),
      icon: Icons.health_and_safety_rounded,
  ),
  'Antineoplásicos (Oncología)': _CategoriaInfo(
      color: Color(0xFF263238),
      icon: Icons.medical_services_rounded,
  ),
};

class _CategoriaInfo {
  final Color color;
  final IconData icon;
  final String? imagePath;
  const _CategoriaInfo({required this.color, required this.icon, this.imagePath});
}

_CategoriaInfo _infoForCategoria(String categoria) {
  if (categoria.contains('Analgésicos')) return _categoriaInfo['Analgésicos']!;
  if (categoria.contains('Antibióticos')) return _categoriaInfo['Antibióticos']!;
  if (categoria.contains('Cardio')) return _categoriaInfo['Cardiovascular']!;
  if (categoria.contains('Resp')) return _categoriaInfo['Respiratorio']!;
  if (categoria.contains('Endocrino')) return _categoriaInfo['Endocrinología (Hormonales)']!;
  if (categoria.contains('Gástrico')) return _categoriaInfo['Gástrico (Poliácidos)']!;
  if (categoria.contains('Psic')) return _categoriaInfo['Psiquiátricos']!;
  if (categoria.contains('Onco')) return _categoriaInfo['Antineoplásicos (Oncología)']!;
  if (categoria.contains('Digestivo')) return _categoriaInfo['Digestivo y Metabólico']!;

  return _categoriaInfo[categoria] ?? const _CategoriaInfo(color: Color(0xFF607D8B), icon: Icons.medication_rounded);
}

class MedicamentoDetailScreen extends StatelessWidget {
  final Medicamento medicamento;

  const MedicamentoDetailScreen({super.key, required this.medicamento});

  @override
  Widget build(BuildContext context) {
    final info = _infoForCategoria(medicamento.grupoFarmacologico);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar con diseño Hero ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: info.color,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                medicamento.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [info.color, info.color.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  if (info.imagePath != null)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          info.imagePath!,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        info.icon,
                        size: 160,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ── Contenido ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Card de Resumen ──────────────────────────────────────
                  _buildMainInfoCard(info),
                  
                  const SizedBox(height: 24),
                  
                  // ── Sección: ¿Para qué sirve? ─────────────────────────────
                  _buildSectionHeader('¿Para qué sirve?', Icons.help_outline_rounded, info.color),
                  _buildContentCard(
                    child: Text(
                      medicamento.sirvePara,
                      style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Sección: Administración ──────────────────────────────
                  _buildSectionHeader('Administración y Dósis', Icons.medication_rounded, info.color),
                  _buildContentCard(
                    child: Column(
                      children: [
                        _infoItem(Icons.inventory_2_outlined, 'Presentación', medicamento.presentacion),
                        const Divider(height: 24),
                        _infoItem(Icons.route_outlined, 'Vía de Administración', medicamento.viaAdministracion),
                        const Divider(height: 24),
                        _infoItem(Icons.person_outline_rounded, 'Dósis Adulto', medicamento.dosisAdulto),
                        const Divider(height: 24),
                        _infoItem(Icons.child_care_rounded, 'Dósis Pediátrica', medicamento.dosisPediatrica),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Sección: Contraindicaciones ───────────────────────────
                  _buildSectionHeader('Contraindicaciones', Icons.warning_amber_rounded, Colors.red.shade700),
                  _buildContentCard(
                    borderColor: Colors.red.shade100,
                    backgroundColor: Colors.red.shade50.withValues(alpha: 0.3),
                    child: Text(
                      medicamento.contraindicaciones,
                      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.red.shade900),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Sección: Seguridad ────────────────────────────────────
                  _buildSectionHeader('Seguridad Clínica', Icons.security_rounded, info.color),
                  _buildContentCard(
                    child: Column(
                      children: [
                        _infoItem(Icons.pregnant_woman_rounded, 'Categoría Embarazo', medicamento.categoriaEmbarazo),
                        const Divider(height: 24),
                        _infoItem(Icons.coronavirus_outlined, 'Efectos Adversos', medicamento.efectosAdversos),
                        const Divider(height: 24),
                        _infoItem(Icons.sync_problem_rounded, 'Interacciones', medicamento.interacciones),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(_CategoriaInfo info) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicamento.marcaComun == 'N/A' || medicamento.marcaComun == '' 
                    ? 'Medicamento Genérico' : medicamento.marcaComun,
                  style: TextStyle(
                    color: info.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  medicamento.grupoFarmacologico,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'ATC: ${medicamento.atc}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({required Widget child, Color? borderColor, Color? backgroundColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
