import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/anatomy_data.dart';

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

  late WebViewController _webController;
  bool _isWebLoaded = false;

  late AnimationController _panelCtrl;
  late Animation<double> _panelAnim;
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();

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

    // Initialize WebViewController
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0D1117))
      ..addJavaScriptChannel(
        'AnatomyChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final sys = message.message;
          if (sys == 'null') {
            _selectSystem(null);
          } else {
            _selectSystem(sys);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() => _isWebLoaded = true);
          },
        ),
      )
      // Load local HTML asset
      ..loadFlutterAsset('assets/web/anatomy3d.html');
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  void _selectSystem(String? key) {
    if (!mounted) return;
    if (key == null) {
      _panelCtrl.reverse().then((_) {
        if (mounted) setState(() => _selectedSystem = null);
      });
      // Deselect in web
      _webController.runJavaScript('window.selectOrganFromFlutter(null);');
      return;
    }
    setState(() => _selectedSystem = key);
    _panelCtrl.forward(from: 0);
    // Highlight in web
    _webController.runJavaScript('window.selectOrganFromFlutter("$key");');
  }

  void _toggleView() {
    setState(() => _isFrontView = !_isFrontView);
    final viewName = _isFrontView ? 'front' : 'back';
    _webController.runJavaScript('window.setCameraView("$viewName");');
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: _buildAppBar(),
      body: LayoutBuilder(builder: (ctx, constraints) {
        return Stack(children: [
          // --- WebGL 3D Viewer ---
          Positioned.fill(
            child: WebViewWidget(controller: _webController),
          ),

          // --- Loading effect ---
          if (!_isWebLoaded)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
            ),

          // --- Scan animation (startup) ---
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) {
              if (_scanCtrl.isCompleted) return const SizedBox();
              return CustomPaint(
                painter: ScanLinePainter(progress: _scanAnim.value),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              );
            },
          ),

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
                  '🔬 MODO ENFERMERÍA',
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
                    '🔬 3D Clínico',
                    key: ValueKey('nursing'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFFCE93D8)),
                  )
                : const Text(
                    '🫀 Motor webGL 3D',
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
            Text(_nursingMode ? '🔬' : '🩺',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              _nursingMode ? 'Modo ON' : 'Enfermería',
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
      onTap: _toggleView,
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
                          '🔬 Modo Enfermería',
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
          title: 'Función',
          color: const Color(0xFF00BFA5),
          child: Text(data.funcion,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.biotech,
          title: 'Anatomía',
          color: const Color(0xFF42A5F5),
          child: Text(data.anatomia,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.warning_amber_rounded,
          title: 'Patologías comunes',
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
          title: 'Función fisiológica',
          color: const Color(0xFF00BFA5),
          child: Text(data.funcion,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.55)),
        ),
        const SizedBox(height: 10),
        _sectionCard(
          icon: Icons.warning_amber_rounded,
          title: 'Patologías',
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
          title: 'Cuidados de Enfermería',
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

// Minimal scan line painter still used
class ScanLinePainter extends CustomPainter {
  final double progress;
  const ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;
    final y = size.height * progress;
    final scanPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Color(0x9900BFA5),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));
    canvas.drawRect(Rect.fromLTWH(0, y - 20, size.width, 40), scanPaint);
  }

  @override
  bool shouldRepaint(ScanLinePainter old) => old.progress != progress;
}
