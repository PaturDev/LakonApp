import 'package:flutter/material.dart';

import '../kuis/kuis_screen.dart';
import '../ai/ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar tab: 0 home, 1 jelajah, 2 kuis, 3 AI
  static const _navIcons = [
    Icons.home_outlined,
    Icons.explore_outlined,
    Icons.emoji_events_outlined,
    Icons.auto_awesome,
  ];

  Widget _buildHomePage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB1B293), Color(0xFF273524)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4, 0.71],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/BgHome.jpeg',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LAKON',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'APP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF273524),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Sugeng Rawuh!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kenali Budaya Jawa dengan Cara Menyenangkan',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1EEE5),
                    foregroundColor: const Color(0xFF35563C),
                  ),
                  child: const Text(
                    'Mulai Jelajah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    const double sideMargin = 20;
    const double barHeight = 64;
    const double ringSize = 88;
    const double circleSize = 72;
    const double navHeight = 128;
    const double barBottom = 12;
    const double notchOffsetY = -6;
    const double barTop = navHeight - barBottom - barHeight;

    return Container(
      height: navHeight,
      width: double.infinity,
      color: const Color(0xFF273524),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth - sideMargin * 2;
          final itemWidth = barWidth / _navIcons.length;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              final notchX = itemWidth * (t + 0.5);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: sideMargin,
                    right: sideMargin,
                    bottom: barBottom,
                    height: barHeight,
                    child: CustomPaint(
                      painter: _NavBarPainter(
                        color: const Color(0xFF66705F),
                        notchX: notchX,
                        notchY: notchOffsetY,
                        notchRadius: ringSize / 2,
                      ),
                      child: Row(
                        children: List.generate(_navIcons.length, (i) {
                          final isSelected = _selectedIndex == i;
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() => _selectedIndex = i),
                              child: Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: isSelected ? 0 : 1,
                                  child: Icon(
                                    _navIcons[i],
                                    size: 32,
                                    color: const Color(0xFFF1EEE5),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  Positioned(
                    left: sideMargin + notchX - circleSize / 2,
                    top: barTop + notchOffsetY - circleSize / 2,
                    child: IgnorePointer(
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB1B293),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: Icon(
                            _navIcons[_selectedIndex],
                            key: ValueKey(_selectedIndex),
                            size: 34,
                            color: const Color(0xFF273524),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      const Center(child: Text('Halaman Jelajah')),
      const KuisScreen(),
      const AIScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: ColoredBox(
        color: const Color(0xFF273524),
        child: SafeArea(top: false, child: _buildBottomNav()),
      ),
    );
  }
}

class _NavBarPainter extends CustomPainter {
  final Color color;
  final double notchX;
  final double notchY;
  final double notchRadius;

  _NavBarPainter({
    required this.color,
    required this.notchX,
    required this.notchY,
    required this.notchRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bar = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.height / 2),
        ),
      );

    final hole = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(notchX, notchY), radius: notchRadius),
      );

    final path = Path.combine(PathOperation.difference, bar, hole);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_NavBarPainter old) =>
      old.notchX != notchX ||
      old.notchY != notchY ||
      old.notchRadius != notchRadius ||
      old.color != color;
}
