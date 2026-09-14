import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../providers/hotel_provider.dart';
import '../utils/booking_calculator.dart';
import '../widgets/responsive_scaffold.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  DateTime? _checkInDate = DateTime.now();
  DateTime? _checkOutDate = DateTime.now().add(const Duration(days: 2));
  Room? _selectedRoom;
  int? _maxGuestsFilter;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/reservations',
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          var availableRooms = provider.rooms;
          if (_maxGuestsFilter != null) {
            availableRooms = availableRooms.where((r) => r.maxGuests >= _maxGuestsFilter!).toList();
          }

          _selectedRoom ??= availableRooms.isNotEmpty ? availableRooms.first : null;

          final calculation = BookingCalculator.calculateBooking(
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            pricePerNight: _selectedRoom?.pricePerNight,
            maxGuests: _selectedRoom?.maxGuests,
            requestedGuests: _maxGuestsFilter,
          );

          final isDesktop = MediaQuery.of(context).size.width >= 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Room Booking & Reservations',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select check-in/out dates, pick a room, and review total reservation breakdown.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),

                // Error Message Banner (if date or room selection is invalid)
                if (!calculation.isValid && calculation.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEF4444)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            calculation.errorMessage!,
                            style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main Content Layout
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildDateAndFilterCard(context)),
                      const SizedBox(width: 16),
                      Expanded(flex: 4, child: _buildRoomListCard(availableRooms)),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _buildSummaryCard(context, calculation)),
                    ],
                  )
                else ...[
                  _buildDateAndFilterCard(context),
                  const SizedBox(height: 16),
                  _buildRoomListCard(availableRooms),
                  const SizedBox(height: 16),
                  _buildSummaryCard(context, calculation),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateAndFilterCard(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

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
          const Text('1. Stay Dates & Guest Filter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Check-in Date Picker
          const Text('Check-in Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _checkInDate ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _checkInDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_checkInDate != null ? dateFormat.format(_checkInDate!) : 'Select Date', style: const TextStyle(fontSize: 13)),
                  const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Check-out Date Picker
          const Text('Check-out Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _checkOutDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _checkOutDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_checkOutDate != null ? dateFormat.format(_checkOutDate!) : 'Select Date', style: const TextStyle(fontSize: 13)),
                  const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Filter by Max Guests
          const Text('Filter by Guests Capacity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: _maxGuestsFilter,
                isExpanded: true,
                hint: const Text('All Room Capacities', style: TextStyle(fontSize: 12)),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Capacities', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 2, child: Text('Min 2 Guests', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 3, child: Text('Min 3 Guests', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 4, child: Text('Min 4 Guests', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _maxGuestsFilter = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomListCard(List<Room> rooms) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('2. Select Room', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Text('${rooms.length} Rooms Available', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 14),

          if (rooms.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No rooms match your filter criteria.')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rooms.length,
              separatorBuilder: (c, i) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final room = rooms[index];
                final isSelected = _selectedRoom?.roomCode == room.roomCode;

                return InkWell(
                  onTap: () => setState(() => _selectedRoom = room),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? const Color(0xFF2563EB) : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${room.roomCode} - ${room.roomType}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDBEAFE),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Max ${room.maxGuests} Guests',
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF1E40AF), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('Floor: ${room.floor} | Status: ${room.status}', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                            ],
                          ),
                        ),
                        Text(
                          '₹${room.pricePerNight.toStringAsFixed(0)} / night',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D2B45)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, BookingValidationResult calculation) {
    final room = _selectedRoom;

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
          const Text('3. Booking Calculation Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 14),

          if (room != null) ...[
            _buildDetailRow('Selected Room:', '${room.roomCode} (${room.roomType})'),
            _buildDetailRow('Rate per Night:', '₹${room.pricePerNight.toStringAsFixed(2)}'),
            _buildDetailRow('Max Capacity:', '${room.maxGuests} Guests'),
          ],
          const Divider(height: 20),

          _buildDetailRow('Number of Nights:', calculation.isValid ? '${calculation.nights} Nights' : '-'),
          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Price:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                calculation.isValid ? '₹${calculation.totalPrice.toStringAsFixed(2)}' : '₹0.00',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: calculation.isValid ? const Color(0xFF059669) : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: calculation.isValid
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF059669),
                          content: Text(
                            'Reservation confirmed for ${room?.roomCode}! (${calculation.nights} nights, ₹${calculation.totalPrice.toStringAsFixed(2)})',
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2B45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Confirm Reservation', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }
}
