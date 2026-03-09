import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/vademecum_service.dart';
import '../services/premium_service.dart';
import '../widgets/premium_gate.dart';
import 'medicamento_detail_screen.dart';
import '../widgets/banner_ad_widget.dart';

class PharmacologyScreen extends StatefulWidget {
  const PharmacologyScreen({super.key});

  @override
  State<PharmacologyScreen> createState() => _PharmacologyScreenState();
}

class _PharmacologyScreenState extends State<PharmacologyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Medicamento> _filteredMedicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final data = await VademecumService.getMedicamentos();
    setState(() {
      _filteredMedicines = data;
      _isLoading = false;
    });
  }

  void _onSearch(String query) async {
    final results = await VademecumService.search(query);
    setState(() {
      _filteredMedicines = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farmacología & Vademécum', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biblioteca de Medicamentos (INVIMA)',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.2),
                    hintText: 'Buscar por nombre o principio activo...',
                    hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: _filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final med = _filteredMedicines[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: med.isPremium ? AppColors.premiumGold.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              med.isPremium ? Icons.workspace_premium : Icons.vaccines,
                              color: med.isPremium ? AppColors.premiumGold : AppColors.primary,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            med.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            '${med.grupoFarmacologico} - ${med.marcaComun}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          trailing: med.isPremium && !PremiumService.isPremium
                              ? const Icon(Icons.lock_rounded, size: 20, color: Colors.grey)
                              : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                          onTap: () {
                            if (med.isPremium) {
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
                          },
                        ),
                      );
                    },
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
