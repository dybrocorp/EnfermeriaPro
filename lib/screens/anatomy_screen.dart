import 'package:flutter/material.dart';
import '../data/anatomy_data.dart';
import '../widgets/body_painter.dart';

class AnatomyScreen extends StatefulWidget {
  const AnatomyScreen({super.key});
  @override
  State<AnatomyScreen> createState() => _AnatomyScreenState();
}

class _AnatomyScreenState extends State<AnatomyScreen>
    with TickerProviderStateMixin {
  String? _selectedSystem;
  bool _nursingMode = false;
  bool _isFrontView = true;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;
  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _glowAnim =
        Tween<double>(begin: 0.4, end: 1.0).animate(_glowCtrl);

    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _panelAnim =
        CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _panelCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  void _selectSystem(String? key) {
    if (key == null) {
      _panelCtrl.reverse().then((_) {
        if (mounted) setState(() => _selectedSystem = null);
      });
      return;
    }
    setState(() => _selectedSystem = key);
    _panelCtrl.forward(from: 0);
  }

  void _onTap(Offset localPos, Size canvasSize) {
    final norm = Offset(
      localPos.dx / canvasSize.width,
      localPos.dy / canvasSize.height,
    );
    // If panel is open, close it
    if (_panelCtrl.isCompleted) {
      _selectSystem(null);
      return;
    }
    final key = systemFromNormalizedTap(norm, _isFrontView);
    _selectSystem(key);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: _buildAppBar(),
      body: LayoutBuilder(builder: (ctx, constraints) {
        final sz = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(children: [
          // --- Body diagram ---
          GestureDetector(
            onTapDown: (d) => _onTap(d.localPosition, sz),
            child: AnimatedBuilder(
              animation: Listenable.merge([_glowAnim]),
              builder: (_, __) => CustomPaint(
                painter: BodyPainter(
                  selectedSystem: _selectedSystem,
                  glowValue: _glowAnim.value,
                  isFrontView: _isFrontView,
                  nursingMode: _nursingMode,
                ),
                size: sz,
              ),
            ),
          ),

          // --- Scan animation (startup) ---
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) {
              if (_scanCtrl.isCompleted) return const SizedBox();
              return CustomPaint(
                painter: ScanLinePainter(progress: _scanAnim.value),
                size: sz,
              );
            },
          ),

          // --- System legend chips (bottom) ---
          if (_selectedSystem == null) _buildLegend(sz),

          // --- Nursing mode badge ---
          if (_nursingMode)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FBE), Color(0xFF4A1480)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF7B2FBE).withValues(alpha: 0.5),
                        blurRadius: 12)
                  ],
                ),
                child: const Text(
                  'ðŸ”¬ MODO ENFERMERÃA',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
              ),
            ),

          // --- Info panel (slide-up) ---
          if (_selectedSystem != null)
            AnimatedBuilder(
              animation: _panelAnim,
              builder: (_, __) {
                final data = anatomySystems[_selectedSystem];
                if (data == null) return const SizedBox();
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(
                        0,
                        (1 - _panelAnim.value) *
                            (constraints.maxHeight * 0.65)),
                    child: _buildInfoPanel(data, constraints, bottomPad),
                  ),
                );
              },
            ),

          // --- FAB nursing mode ---
          Positioned(
            right: 16,
            bottom: bottomPad + 16,
            child: _buildNursingFAB(),
          ),

          // --- View toggle ---
          Positioned(
            left: 16,
            bottom: bottomPad + 16,
            child: _buildViewToggle(),
          ),
        ]);
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _nursingMode
          ? const Color(0xFF110020)
          : const Color(0xFF0D1117),
      foregroundColor: Colors.white,
      title: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _nursingMode
                ? const Text(
                    'ðŸ”¬ Atlas ClÃ­nico',
                    key: ValueKey('nursing'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFFCE93D8)),
                  )
                : const Text(
                    'ðŸ«€ Atlas AnatÃ³mico 3D',
                    key: ValueKey('anatomy'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
          ),
        ],
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: (_nursingMode
              ? const Color(0xFF7B2FBE)
              : const Color(0xFF00BFA5)).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildLegend(Size sz) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 70,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 38,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: bodyRegions.map((r) {
            return GestureDetector(
              onTap: () => _selectSystem(r.key),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: r.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: r.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(r.emoji, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      r.label,
                      style: TextStyle(
                        color: r.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNursingFAB() {
    return GestureDetector(
      onTap: () {
        setState(() => _nursingMode = !_nursingMode);
        // Reopen panel if system selected
        if (_selectedSystem != null) _panelCtrl.forward(from: 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: _nursingMode
              ? const LinearGradient(
                  colors: [Color(0xFF7B2FBE), Color(0xFF4A1480)])
              : const LinearGradient(
                  colors: [Color(0xFF00796B), Color(0xFF004D40)]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: (_nursingMode
                      ? const Color(0xFF7B2FBE)
                      : const Color(0xFF00BFA5))
                  .withValues(alpha: 0.5),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_nursingMode ? 'ðŸ”¬' : 'ðŸ©º',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              _nursingMode ? 'Modo ON' : 'EnfermerÃ­a',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return GestureDetector(
      onTap: () => setState(() {
        _isFrontView = !_isFrontView;
        if (_selectedSystem != null) {
          final region =
              bodyRegions.firstWhere((r) => r.key == _selectedSystem);
          final hasView = _isFrontView
              ? region.frontRects.isNotEmpty
              : region.backRects.isNotEmpty;
          if (!hasView) _selectSystem(null);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isFrontView ? Icons.face : Icons.face_retouching_natural,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              _isFrontView ? 'Anterior' : 'Posterior',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel(
      AnatomySystem data, BoxConstraints constraints, double bottomPad) {
    final maxH = constraints.maxHeight * 0.68;
    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: (_nursingMode
                  ? const Color(0xFF7B2FBE)
                  : const Color(0xFF00BFA5))
              .withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            child: Row(
              children: [
                Text(data.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_nursingMode)
                        const Text(
                          'ðŸ”¬ Modo EnfermerÃ­a',
                          style: TextStyle(
                              color: Color(0xFFCE93D8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectSystem(null),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white54, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 70),
              child: _nursingMode
                  ? _buildNursingContent(data)
                  : _buildAnatomyContent(data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomyContent(AnatomySystem data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          icon: Icons.info_outline,
          title: 'FunciÃ³n',
          color: const Color(0xFF00BFA5),
          child: Text(data.funcion,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.biotech,
          title: 'AnatomÃ­a',
          color: const Color(0xFF42A5F5),
          child: Text(data.anatomia,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.warning_amber_rounded,
          title: 'PatologÃ­as comunes',
          color: const Color(0xFFEF5350),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.patologias
                .map((p) => _bulletItem(p, const Color(0xFFEF5350)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNursingContent(AnatomySystem data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          icon: Icons.favorite,
          title: 'FunciÃ³n fisiolÃ³gica',
          color: const Color(0xFF00BFA5),
          child: Text(data.funcion,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.warning_amber_rounded,
          title: 'PatologÃ­as',
          color: const Color(0xFFEF5350),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.patologias
                .map((p) => _bulletItem(p, const Color(0xFFEF5350)))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.medication,
          title: 'Medicamentos relacionados',
          color: const Color(0xFF42A5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.medicamentos
                .map((m) => _bulletItem(m, const Color(0xFF42A5F5)))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.medical_services,
          title: 'Cuidados de EnfermerÃ­a',
          color: const Color(0xFFCE93D8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.cuidados
                .map((c) => _bulletItem(c, const Color(0xFFCE93D8)))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.build_circle,
          title: 'Procedimientos',
          color: const Color(0xFFFFB74D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.procedimientos
                .map((p) => _bulletItem(p, const Color(0xFFFFB74D)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _bulletItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12.5, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

