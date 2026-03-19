import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/vademecum_service.dart';
import '../services/premium_service.dart';
import '../widgets/premium_gate.dart';
import 'medicamento_detail_screen.dart';
import '../widgets/banner_ad_widget.dart';

// ── Mapa de categorías clínicas → color e ícono ──────────────────────────
const Map<String, _CategoriaInfo> _categoriaInfo = {
  'Analgésicos': _CategoriaInfo(
    color: Color(0xFFFF5252), 
    icon: Icons.personal_injury_rounded,
    nombreCorto: 'Analgésicos'
  ),
  'Antibióticos': _CategoriaInfo(
    color: Color(0xFF00C853), 
    icon: Icons.biotech_rounded,
    nombreCorto: 'Antibióticos'
  ),
  'Cardiovascular': _CategoriaInfo(
    color: Color(0xFFE91E63), 
    icon: Icons.favorite_rounded,
    nombreCorto: 'Cardio'
  ),
  'Respiratorio': _CategoriaInfo(
    color: Color(0xFF00B0FF), 
    icon: Icons.air_rounded,
    nombreCorto: 'Resp'
  ),
  'Endocrinología (Hormonales)': _CategoriaInfo(
    color: Color(0xFFFFAB00), 
    icon: Icons.water_drop_rounded,
    nombreCorto: 'Endocrino'
  ),
  'Gástrico (Poliácidos)': _CategoriaInfo(
    color: Color(0xFF795548), 
    icon: Icons.restaurant_rounded,
    nombreCorto: 'Gástrico'
  ),
  'Psiquiátricos': _CategoriaInfo(
    color: Color(0xFF6200EA), 
    icon: Icons.psychology_rounded,
    nombreCorto: 'Psiquiatría'
  ),
  'Digestivo y Metabólico': _CategoriaInfo(
      color: Color(0xFF4CAF50),
      icon: Icons.health_and_safety_rounded,
      nombreCorto: 'Digestivo'
  ),
  'Antineoplásicos (Oncología)': _CategoriaInfo(
      color: Color(0xFF263238),
      icon: Icons.medical_services_rounded,
      nombreCorto: 'Onco'
  ),
};

class _CategoriaInfo {
  final Color color;
  final IconData icon;
  final String nombreCorto;
  const _CategoriaInfo({required this.color, required this.icon, required this.nombreCorto});
}

_CategoriaInfo _infoForCategoria(String categoria) {
  // Búsqueda flexible por palabra clave si no hay match exacto
  if (categoria.contains('Analgésicos')) return _categoriaInfo['Analgésicos']!;
  if (categoria.contains('Antibióticos')) return _categoriaInfo['Antibióticos']!;
  if (categoria.contains('Cardio')) return _categoriaInfo['Cardiovascular']!;
  if (categoria.contains('Resp')) return _categoriaInfo['Respiratorio']!;
  if (categoria.contains('Endocrino')) return _categoriaInfo['Endocrinología (Hormonales)']!;
  if (categoria.contains('Gástrico')) return _categoriaInfo['Gástrico (Poliácidos)']!;
  if (categoria.contains('Psic')) return _categoriaInfo['Psiquiátricos']!;
  if (categoria.contains('Onco')) return _categoriaInfo['Antineoplásicos (Oncología)']!;
  if (categoria.contains('Digestivo')) return _categoriaInfo['Digestivo y Metabólico']!;

  return _categoriaInfo[categoria] ?? const _CategoriaInfo(
    color: Color(0xFF607D8B), 
    icon: Icons.medication_rounded,
    nombreCorto: 'Otros'
  );
}

const List<String> _categories = [
  'Todos',
  'Analgésicos',
  'Antibióticos',
  'Cardiovascular',
  'Gástrico (Poliácidos)',
  'Psiquiátricos',
  'Respiratorio',
  'Endocrinología (Hormonales)',
  'Antineoplásicos (Oncología)',
];

class PharmacologyScreen extends StatefulWidget {
  const PharmacologyScreen({super.key});

  @override
  State<PharmacologyScreen> createState() => _PharmacologyScreenState();
}

class _PharmacologyScreenState extends State<PharmacologyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Medicamento> _allMedicines = [];
  List<Medicamento> _filteredMedicines = [];
  bool _isLoading = true;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final data = await VademecumService.getMedicamentos();
    setState(() {
      _allMedicines = data;
      _filteredMedicines = data;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((m) {
        final matchesSearch = query.isEmpty ||
            m.nombre.toLowerCase().contains(query) ||
            m.grupoFarmacologico.toLowerCase().contains(query) ||
            m.marcaComun.toLowerCase().contains(query);

        final matchesCategory = _selectedCategory == 'Todos' ||
            m.grupoFarmacologico.contains(_selectedCategory);

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Vademécum Profesional',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              // Info modal about sources
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Header con búsqueda Premium ───────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buscador Médico Especializado',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    hintText: 'Nombre, marca o grupo...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),

          // ── Chips de categoría Modernos ────────────────────────────────────
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat;
                final info = cat == 'Todos' ? null : _infoForCategoria(cat);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(
                      cat == 'Todos' ? 'Todos' : info!.nombreCorto,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textPrimary,
                        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) => _onCategorySelected(cat),
                    backgroundColor: Colors.white,
                    selectedColor: info?.color ?? AppColors.primary,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: selected ? (info?.color ?? AppColors.primary) : Colors.grey.shade300,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: selected ? 2 : 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              },
            ),
          ),

          // ── Lista de medicamentos ─────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMedicines.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _filteredMedicines.length,
                        itemBuilder: (context, index) {
                          return _MedicamentoItem(
                            med: _filteredMedicines[index],
                          );
                        },
                      ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay resultados',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba con otros términos o categorías',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _onSearch('');
              _onCategorySelected('Todos');
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Restablecer filtros'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicamentoItem extends StatelessWidget {
  final Medicamento med;
  const _MedicamentoItem({required this.med});

  @override
  Widget build(BuildContext context) {
    final info = _infoForCategoria(med.grupoFarmacologico);
    final isLocked = med.isPremium && !PremiumService.isPremium;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: info.color.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTap(context, isLocked),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ── Icono de Categoría Dinámico ─────────────────────────────
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [info.color.withValues(alpha: 0.2), info.color.withValues(alpha: 0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(info.icon, color: info.color, size: 28),
                ),
                const SizedBox(width: 16),
                
                // ── Info del Medicamento ───────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              med.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLocked)
                            const Icon(Icons.lock_rounded, size: 16, color: AppColors.premiumGold),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        med.laboratorios == 'N/A' || med.laboratorios == 'Genérico'
                          ? 'Générico' : med.laboratorios,
                        style: TextStyle(
                          color: info.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Chips de info rápida
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _miniChip(Icons.medication_rounded, med.presentacion),
                            const SizedBox(width: 8),
                            _miniChip(Icons.route_rounded, med.viaAdministracion),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text.length > 15 ? '${text.substring(0, 15)}...' : text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, bool isLocked) {
    if (isLocked) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumGate(
            featureName: 'Ficha de ${med.nombre}',
            child: MedicamentoDetailScreen(medicamento: med),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicamentoDetailScreen(medicamento: med),
        ),
      );
    }
  }
}
