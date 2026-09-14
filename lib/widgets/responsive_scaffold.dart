import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_header.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final String currentRoute;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2), // Warm soft background matching screenshots
      appBar: const AppHeader(),
      bottomNavigationBar: isMobile ? _buildBottomNavBar(context) : null,
      body: Column(
        children: [
          if (!isMobile) _buildTopNavTabBar(context),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildTopNavTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNavItem(context, label: 'Main Dashboard', icon: Icons.dashboard_outlined, route: '/'),
            const SizedBox(width: 8),
            _buildNavItem(context, label: 'Guest Check-in', icon: Icons.login_outlined, route: '/check-in'),
            const SizedBox(width: 8),
            _buildNavItem(context, label: 'Guest Check-out', icon: Icons.logout_outlined, route: '/check-out'),
            const SizedBox(width: 8),
            _buildNavItem(context, label: 'Reservations & Booking', icon: Icons.hotel_outlined, route: '/reservations'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
  }) {
    final isSelected = currentRoute == route;
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B45) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    int currentIndex = 0;
    if (currentRoute == '/check-in') currentIndex = 1;
    if (currentRoute == '/check-out') currentIndex = 2;
    if (currentRoute == '/reservations') currentIndex = 3;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/check-in');
            break;
          case 2:
            context.go('/check-out');
            break;
          case 3:
            context.go('/reservations');
            break;
        }
      },
      selectedItemColor: const Color(0xFF0D2B45),
      unselectedItemColor: const Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.login_outlined), label: 'Check-in'),
        BottomNavigationBarItem(icon: Icon(Icons.logout_outlined), label: 'Check-out'),
        BottomNavigationBarItem(icon: Icon(Icons.hotel_outlined), label: 'Booking'),
      ],
    );
  }
}
