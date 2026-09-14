import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueChanged<String>? onSearchChanged;

  const AppHeader({
    super.key,
    this.title = 'Main Dashboard',
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final nowFormatted = DateFormat('EEE, MMM d, yyyy | h:mm a').format(DateTime.now());

    return Container(
      height: 68.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          // Logo & Hotel Name
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B45),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'RH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Raintech',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    'HOTEL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 24),

          // Search Bar (Expanded if Desktop/Tablet)
          if (isDesktop)
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search guests, rooms, reservations, staff...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                      ),
                      child: const Text(
                        'Ctrl K',
                        style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          const SizedBox(width: 16),

          // Date / Time Badge
          if (isDesktop) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF4B5563)),
                  const SizedBox(width: 6),
                  Text(
                    nowFormatted,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Quick Actions Button
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E56A0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            icon: const Text('\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            label: Text(isDesktop ? 'Quick Actions' : 'Actions', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),

          // Notification Bell & Avatar
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF4B5563)),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF10B981),
            child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
