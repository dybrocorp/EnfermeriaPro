import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../widgets/bouncy_card.dart';

import 'vital_signs_screen.dart';
import 'medication_calculator_screen.dart';
import 'procedures_screen.dart';
import 'glossary_screen.dart';
import 'calendar_screen.dart';
import 'anatomy_screen.dart';
import 'pharmacology_screen.dart';
import 'critical_care_screen.dart';
import 'obstetrics_screen.dart';
import 'surgery_screen.dart';
import 'premium_screen.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/premium_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'imc_calculator_screen.dart';
import 'drip_rate_calculator_screen.dart';
import '../widgets/premium_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    _loadUpcomingEvents();
  }

  Future<void> _loadUpcomingEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString('calendar_events');
    
    if (eventsString != null) {
      final Map<String, dynamic> rawEvents = jsonDecode(eventsString);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      
      List<Map<String, dynamic>> allEvents = [];
      
      rawEvents.forEach((key, value) {
        final DateTime date = DateTime.parse(key);
        // Sólo eventos de hoy en adelante
        if (date.isAtSameMomentAs(today) || date.isAfter(today)) {
          final List<String> eventList = List<String>.from(value);
          for (var event in eventList) {
            allEvents.add({
              'date': date,
              'title': event,
            });
          }
        }
      });
      
      // Ordenar por fecha más próxima
      allEvents.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
      
      setState(() {
        // Tomar los 3 más próximos
        _upcomingEvents = allEvents.take(3).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final int gridCrossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 600 ? 3 : 2);
    final double gridAspectRatio = screenWidth < 350 ? 0.8 : (screenWidth > 600 ? 1.1 : 0.9);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enfermería Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.premiumGradient,
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUpcomingEvents,
            tooltip: 'Actualizar recordatorios',
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.background,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGradient,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null 
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) 
                    : null,
                child: FirebaseAuth.instance.currentUser?.photoURL == null 
                    ? const Icon(Icons.person, size: 40, color: AppColors.primary) 
                    : null,
              ),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario de Enfermería',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'invitado@pro.com'),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Mi Perfil',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                  ),
                  _buildDrawerItem(
                    icon: Icons.workspace_premium,
                    title: 'Suscripción Elite',
                    subtitle: PremiumService.isPremium ? 'Plan Pro Activo' : 'Ver beneficios',
                    iconColor: AppColors.premiumGold,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())).then((_) => setState(() {})),
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    iconColor: AppColors.danger,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Versión 1.3.1',
                style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenido, Futuro Enfermero(a)',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Panel de Recordatorios
                    if (_upcomingEvents.isNotEmpty) ...[
                      const Text(
                        'Recordatorios Próximos:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.danger,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _upcomingEvents.map((e) {
                            final date = e['date'] as DateTime;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.notification_important, size: 16, color: AppColors.warning),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${date.day}/${date.month}/${date.year} - ${e['title']}',
                                      style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const Text(
                        '¿Qué deseas repasar hoy?',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Categoría: Herramientas
                    const Text(
                      'Herramientas Prácticas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 155,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildModuleCard(
                            context,
                            title: 'Calculadora\nDosis',
                            icon: Icons.calculate,
                            color: AppColors.secondary,
                            destination: const MedicationCalculatorScreen(),
                            width: 130,
                          ),
                          _buildModuleCard(
                            context,
                            title: 'Calendario\nEstudiantil',
                            icon: Icons.calendar_month,
                            color: AppColors.primaryLight,
                            destination: const CalendarScreen(),
                            onReturn: _loadUpcomingEvents,
                            width: 130,
                          ),
                          _buildModuleCard(
                            context,
                            title: 'Glosario\nMédico',
                            icon: Icons.menu_book,
                            color: AppColors.warning,
                            destination: const GlossaryScreen(),
                            width: 130,
                          ),
                          _buildModuleCard(
                            context,
                            title: 'Calculadora\nIMC',
                            icon: Icons.monitor_weight_outlined,
                            color: const Color(0xFF16A085),
                            destination: const PremiumGate(featureName: 'Calculadora IMC', child: IMCCalculatorScreen()),
                            width: 130,
                          ),
                          _buildModuleCard(
                            context,
                            title: 'Control\nde Goteo',
                            icon: Icons.opacity,
                            color: const Color(0xFF27AE60),
                            destination: const PremiumGate(featureName: 'Control de Goteo', child: DripRateCalculatorScreen()),
                            width: 130,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categoría: Conocimiento
                    const Text(
                      'Base de Conocimiento Clínico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: gridCrossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: gridAspectRatio,
                      children: [
                        _buildModuleCard(
                          context,
                          title: 'Signos Vitales',
                          icon: Icons.favorite,
                          imagePath: 'assets/images/vitals.png',
                          color: AppColors.danger,
                          destination: const VitalSignsScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Anatomía',
                          icon: Icons.accessibility_new,
                          imagePath: 'assets/images/anatomy.png',
                          color: const Color(0xFF8E44AD),
                          destination: const AnatomyScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Farmacología',
                          icon: Icons.vaccines,
                          imagePath: 'assets/images/pharma.png',
                          color: const Color(0xFFF39C12),
                          destination: const PharmacologyScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Cuidados Críticos',
                          icon: Icons.monitor_heart,
                          imagePath: 'assets/images/critical.png',
                          color: const Color(0xFFC0392B),
                          destination: const CriticalCareScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Quirófanos y Curaciones',
                          icon: Icons.healing,
                          imagePath: 'assets/images/surgery.png',
                          color: const Color(0xFF2980B9),
                          destination: const SurgeryScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Procedimientos',
                          icon: Icons.medical_services,
                          color: AppColors.success,
                          destination: const ProceduresScreen(),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Obstetricia',
                          icon: Icons.pregnant_woman,
                          imagePath: 'assets/images/obstetrics.png',
                          color: const Color(0xFFE91E63),
                          destination: const ObstetricsScreen(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, {
    required String title, 
    required IconData icon, 
    required Color color, 
    required Widget destination,
    String? imagePath,
    VoidCallback? onReturn,
    double? width,
  }) {
    // Para la sombra solida inferior calculamos un color más oscuro
    final Color shadowColor = HSLColor.fromColor(color).withLightness((HSLColor.fromColor(color).lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return Container(
      width: width,
      margin: width != null ? const EdgeInsets.only(right: 12) : null,
      child: BouncyCard(
        baseColor: color,
        shadowColor: shadowColor,
        elevation: 6.0,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
          if (!context.mounted) return;
          if (onReturn != null) {
            onReturn();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(child: Icon(icon, color: Colors.white)),
                  ),
                ),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, String? subtitle, Color? iconColor, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      onTap: onTap,
    );
  }
}
