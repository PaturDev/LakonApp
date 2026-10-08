import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E4638),
              Color(0xFF8C7366),
              Color(0xFFB9A294),
              Color(0xFF8A6048),
              Color(0xFF7A5238),
            ],
            stops: [0.0, 0.35, 0.42, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'LAKON',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'APP',
                        style: TextStyle(color: Color(0xFFE8A22B)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomNav()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD9BC98), Color(0xFF9B6E4B)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: _NavIcon(
                      icon: Icons.local_fire_department_outlined,
                      active: selectedNav == 1,
                      onTap: () => setState(() => selectedNav = 1),
                    ),
                  ),
                  Expanded(
                    child: _NavIcon(
                      icon: Icons.settings_outlined,
                      active: selectedNav == 2,
                      onTap: () => setState(() => selectedNav = 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 60,
            bottom: 38,
            child: GestureDetector(
              onTap: () => setState(() => selectedNav = 0),
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE6CDA9), Color(0xFF9A6C49)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFB88C65), Color(0xFFD9BC98)],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      color: selectedNav == 0
                          ? const Color(0xFF2E2019)
                          : const Color(0xFF5A4030),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Icon(
          icon,
          size: 24,
          color: active ? const Color(0xFF2E2019) : const Color(0xFF3B2A20),
        ),
      ),
    );
  }
}
