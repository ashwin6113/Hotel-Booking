import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../providers/hotel_provider.dart';
import '../widgets/responsive_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/',
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final screenWidth = MediaQuery.of(context).size.width;
          final isDesktop = screenWidth >= 1100;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Main Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Section: Quick Nav Grid & Operational Overview
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildQuickNavGrid(context)),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildOperationalOverviewCard(provider)),
                    ],
                  )
                else ...[
                  _buildQuickNavGrid(context),
                  const SizedBox(height: 16),
                  _buildOperationalOverviewCard(provider),
                ],

                const SizedBox(height: 24),

                // Middle Section: Interactive Floor View
                _buildInteractiveFloorView(context, provider),

                const SizedBox(height: 24),

                // Bottom Section: Going to Vacate & Quick Status Changer
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildVacateRoomsSection(provider)),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildQuickStatusChanger(context, provider)),
                    ],
                  )
                else ...[
                  _buildVacateRoomsSection(provider),
                  const SizedBox(height: 16),
                  _buildQuickStatusChanger(context, provider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickNavGrid(BuildContext context) {
    final navItems = [
      {'title': 'Guest Check-in', 'icon': Icons.login_outlined, 'color': const Color(0xFF14B8A6), 'route': '/check-in'},
      {'title': 'Guest Check-Out', 'icon': Icons.logout_outlined, 'color': const Color(0xFFF43F5E), 'route': '/check-out'},
      {'title': 'Reservations', 'icon': Icons.event_available_outlined, 'color': const Color(0xFF3B82F6), 'route': '/reservations'},
      {'title': 'Housekeeping', 'icon': Icons.cleaning_services_outlined, 'color': const Color(0xFF0EA5E9), 'route': null},
      {'title': 'Restaurant', 'icon': Icons.restaurant_outlined, 'color': const Color(0xFFF97316), 'route': null},
      {'title': 'WhatsApp', 'icon': Icons.chat_bubble_outline_rounded, 'color': const Color(0xFF22C55E), 'route': null},
      {'title': 'Rooms', 'icon': Icons.meeting_room_outlined, 'color': const Color(0xFFA855F7), 'route': null},
      {'title': 'Staff', 'icon': Icons.badge_outlined, 'color': const Color(0xFF6366F1), 'badge': '2 tasks', 'route': null},
      {'title': 'Floors', 'icon': Icons.layers_outlined, 'color': const Color(0xFF10B981), 'route': null},
      {'title': 'Reports', 'icon': Icons.bar_chart_outlined, 'color': const Color(0xFFEAB308), 'route': null},
      {'title': 'Settings', 'icon': Icons.tune_outlined, 'color': const Color(0xFF64748B), 'route': null},
      {'title': 'New: Group Booking', 'icon': Icons.group_add_outlined, 'color': const Color(0xFF8B5CF6), 'route': '/reservations'},
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 800 ? 6 : (constraints.maxWidth > 500 ? 4 : 2);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.45,
        ),
        itemCount: navItems.length,
        itemBuilder: (context, index) {
          final item = navItems[index];
          final route = item['route'] as String?;
          return InkWell(
            onTap: route != null ? () => context.go(route) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                        ),
                      ],
                    ),
                  ),
                  if (item.containsKey('badge'))
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: Text(
                          item['badge'] as String,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOperationalOverviewCard(HotelProvider provider) {
    final metrics = provider.metrics;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Operational Overview',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Occupancy',
                  value: '${metrics?.occupancyPercentage.toStringAsFixed(0) ?? 4}%',
                  bgColor: const Color(0xFFEFF6FF),
                  textColor: const Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Pending Check-ins',
                  value: '${metrics?.pendingCheckIns ?? 0}',
                  bgColor: const Color(0xFFF9FAFB),
                  textColor: const Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Pending Departures',
                  value: '${metrics?.pendingDepartures ?? 0}',
                  bgColor: const Color(0xFFF9FAFB),
                  textColor: const Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Revenue Today',
                  value: '₹${metrics?.revenueToday.toStringAsFixed(0) ?? 0}',
                  bgColor: const Color(0xFFECFDF5),
                  textColor: const Color(0xFF047857),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({required String label, required String value, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildInteractiveFloorView(BuildContext context, HotelProvider provider) {
    final floor1Rooms = provider.rooms.where((r) => r.floor == 'Floor 1').toList();
    final floor2Rooms = provider.rooms.where((r) => r.floor == 'Floor 2').toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room Status - Interactive Floor View',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  Text(
                    '50 rooms across your property',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Floor Grids
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Floor 1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    _buildFloorGrid(context, floor1Rooms, provider),
                    const SizedBox(height: 16),
                    const Text('Floor 2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    _buildFloorGrid(context, floor2Rooms, provider),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Right Summary Donut Card
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF10B981), width: 8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('200', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Rooms Total', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '4% Occupied',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Legend Bar
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendItem('Available', const Color(0xFF4ADE80)),
                  _buildLegendItem('Occupied', const Color(0xFF3B82F6)),
                  _buildLegendItem('Dirty', const Color(0xFFEF4444)),
                  _buildLegendItem('Maintenance', const Color(0xFFF97316)),
                  _buildLegendItem('Blocked', const Color(0xFF6B7280)),
                ],
              ),
              const Text(
                'Clicking a room tile opens its quick-edit menu',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorGrid(BuildContext context, List<Room> rooms, HotelProvider provider) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: rooms.map((room) {
        Color bgColor;
        switch (room.status) {
          case 'occupied':
            bgColor = const Color(0xFF3B82F6);
            break;
          case 'dirty':
            bgColor = const Color(0xFFEF4444);
            break;
          case 'maintenance':
            bgColor = const Color(0xFFF97316);
            break;
          case 'blocked':
            bgColor = const Color(0xFF6B7280);
            break;
          case 'available':
          default:
            bgColor = const Color(0xFF86EFAC);
            break;
        }

        return InkWell(
          onTap: () => _showRoomQuickEditDialog(context, room, provider),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 44,
            height: 34,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                room.roomNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563))),
        ],
      ),
    );
  }

  Widget _buildVacateRoomsSection(HotelProvider provider) {
    final vacateRooms = provider.vacateRooms;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.king_bed_outlined, color: Color(0xFF0D2B45)),
              SizedBox(width: 8),
              Text(
                'Going to Vacate Rooms',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vacateRooms.length,
              itemBuilder: (context, index) {
                final v = vacateRooms[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          v.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 70,
                            height: 70,
                            color: const Color(0xFFD1D5DB),
                            child: const Icon(Icons.hotel, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Room ${v.roomNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(v.statusText, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)), maxLines: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatusChanger(BuildContext context, HotelProvider provider) {
    String selectedRoom = provider.rooms.isNotEmpty ? provider.rooms.first.roomNumber : '101';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Room Status Changer & Actions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRoom,
                        isExpanded: true,
                        items: provider.rooms.map((r) {
                          return DropdownMenuItem(
                            value: r.roomNumber,
                            child: Text('Room ${r.roomNumber} (${r.status})', style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedRoom = val);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    provider.updateRoomStatus(selectedRoom, 'available');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Room $selectedRoom marked as Available & Ready')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBF7D0),
                    foregroundColor: const Color(0xFF166534),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.cleaning_services, size: 16),
                  label: const Text('Cleaning done, ready to serve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      provider.setAllDirtyToCleaning();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All Dirty rooms set to Available/Clean!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF991B1B),
                      backgroundColor: const Color(0xFFFEE2E2),
                    ),
                    child: const Text('Set all Dirty to Cleaning', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('View All Maintenance', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  void _showRoomQuickEditDialog(BuildContext context, Room room, HotelProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Room ${room.roomNumber} Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Code: ${room.roomCode}'),
              Text('Room Type: ${room.roomType}'),
              Text('Rent: ₹${room.pricePerNight} / night'),
              Text('Current Status: ${room.status.toUpperCase()}'),
              if (room.guestName.isNotEmpty) Text('Guest: ${room.guestName}'),
              const SizedBox(height: 16),
              const Text('Change Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['available', 'occupied', 'dirty', 'maintenance', 'blocked'].map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: room.status == status,
                    onSelected: (selected) {
                      if (selected) {
                        provider.updateRoomStatus(room.roomNumber, status);
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
