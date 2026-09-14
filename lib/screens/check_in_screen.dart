import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../providers/hotel_provider.dart';
import '../widgets/responsive_scaffold.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  Room? _selectedRoom;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _checkoutDateController = TextEditingController(text: '02/04/2026');
  int _adultsCount = 2;
  final int _kidsCount = 0;

  @override
  void dispose() {
    _guestNameController.dispose();
    _phoneController.dispose();
    _checkoutDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/check-in',
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          _selectedRoom ??= provider.rooms.firstWhere(
            (r) => r.status == 'available',
            orElse: () => provider.rooms.first,
          );

          final isDesktop = MediaQuery.of(context).size.width >= 1100;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title & Top Search
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Guest Check-in',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    SizedBox(
                      width: 320,
                      height: 38,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Booking ID / Guest Name',
                          hintStyle: const TextStyle(fontSize: 12),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3 Step Process Grid
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStep1SelectBookingCard(provider)),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: _buildStep2ReviewUpdateCard(provider)),
                      const SizedBox(width: 14),
                      Expanded(flex: 3, child: _buildStep3PaymentCard(context, provider)),
                    ],
                  )
                else ...[
                  _buildStep1SelectBookingCard(provider),
                  const SizedBox(height: 14),
                  _buildStep2ReviewUpdateCard(provider),
                  const SizedBox(height: 14),
                  _buildStep3PaymentCard(context, provider),
                ],

                const SizedBox(height: 24),

                // Check-in Records Table
                _buildCheckInDataTable(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep1SelectBookingCard(HotelProvider provider) {
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
          _buildPanelHeader('1. Select Booking & Guest'),
          const SizedBox(height: 14),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Booking ID / Guest Name',
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: const Icon(Icons.search, size: 16),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),

          const Text('Select Customer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
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
                      value: _selectedRoom?.roomNumber,
                      isExpanded: true,
                      hint: const Text('Name/Phone number', style: TextStyle(fontSize: 12)),
                      items: provider.rooms.map((r) {
                        return DropdownMenuItem(
                          value: r.roomNumber,
                          child: Text('Room ${r.roomNumber} - ${r.guestName.isNotEmpty ? r.guestName : "Vacant"}', style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedRoom = provider.rooms.firstWhere((r) => r.roomNumber == val);
                            _guestNameController.text = _selectedRoom?.guestName ?? '';
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E56A0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Guest', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Booking Info Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking Date', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    Text('02/04/2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking Time', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    Row(
                      children: [
                        Text('07:00 PM ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2ReviewUpdateCard(HotelProvider provider) {
    final room = _selectedRoom;
    final rent = room?.pricePerNight ?? 1200.0;
    final gst = room?.gstPercent ?? 9.33;

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
          _buildPanelHeader('2. Review & Update Details'),
          const SizedBox(height: 14),

          // Room Details Header Fields
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD97706)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hotel, size: 16, color: Color(0xFF92400E)),
                    const SizedBox(width: 4),
                    Text(
                      room?.roomNumber ?? '101',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF78350F)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: rent.toStringAsFixed(2)),
                  decoration: const InputDecoration(labelText: 'Rent', isDense: true, border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: '${gst.toStringAsFixed(2)} %'),
                  decoration: const InputDecoration(labelText: 'GST', isDense: true, border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _guestNameController,
                  decoration: const InputDecoration(labelText: 'Tenant Name', isDense: true, border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _checkoutDateController,
                  decoration: const InputDecoration(
                    labelText: 'Checkout Date',
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_today, size: 16),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: room?.idProof ?? 'mathewhyden.pdf'),
                  decoration: const InputDecoration(
                    labelText: 'ID Proof',
                    isDense: true,
                    suffixIcon: Icon(Icons.insert_drive_file_outlined, size: 16),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_adultsCount > 1) setState(() => _adultsCount--);
                      },
                    ),
                    Text('Adults: $_adultsCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _adultsCount++),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Additional Charges box & Actions
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file, size: 16),
                label: const Text('Upload ID', style: TextStyle(fontSize: 11)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Room Charge: 2 beds', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('Extra Charges: ₹200', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('Tax: ₹2500.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Update'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Guest Details Confirmed!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2B45),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Guest Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3PaymentCard(BuildContext context, HotelProvider provider) {
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
          _buildPanelHeader('3. Finalize Check-in & Payment'),
          const SizedBox(height: 14),

          _buildChargeRow('Room Charge', '₹2500.00'),
          _buildChargeRow('Extra Charges', '₹2500.00'),
          _buildChargeRow('Tax', '₹0.00'),
          const Divider(),
          _buildChargeRow('Total Amount:', '₹2500.00', isBold: true, fontSize: 16),
          _buildChargeRow('Total Paid:', '₹2500.00', isBold: true, fontSize: 16, color: const Color(0xFF10B981)),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedRoom != null) {
                  provider.addCheckIn(
                    room: _selectedRoom!,
                    guestName: _guestNameController.text.isNotEmpty ? _guestNameController.text : 'Mathew Hyden',
                    phone: '+91 9876543210',
                    checkInDate: '02/04/2026',
                    checkOutDate: _checkoutDateController.text,
                    adults: _adultsCount,
                    kids: _kidsCount,
                    idProof: 'mathewhyden.pdf',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Check-in Complete for Room ${_selectedRoom!.roomNumber}!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2B45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Complete Check-in', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Get Data', style: TextStyle(fontSize: 11))),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.payment, size: 14), label: const Text('M-Pay', style: TextStyle(fontSize: 11))),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.print, size: 14), label: const Text('Print', style: TextStyle(fontSize: 11))),
            ],
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Print Registration Card', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Download Folio', style: TextStyle(fontSize: 11)))),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D2B45), foregroundColor: Colors.white),
                  child: const Text('Complete Check-in', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, String amount, {bool isBold = false, double fontSize = 13, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF374151),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isBold ? const Color(0xFF111827) : const Color(0xFF4B5563)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2B45),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildCheckInDataTable(HotelProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          columns: const [
            DataColumn(label: Text('ROOM NO.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('RENT (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('GST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('NO:OF ADULTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('NO:OF KIDS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('SENIOR CITIZEN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('CHECKOUT DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('ID PROOF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          ],
          rows: provider.rooms.map((room) {
            return DataRow(
              cells: [
                DataCell(Text(room.roomNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text('₹${room.pricePerNight.toStringAsFixed(2)}')),
                DataCell(Text('₹${(room.pricePerNight * room.gstPercent / 100).toStringAsFixed(2)}')),
                DataCell(Text(room.guestName.isNotEmpty ? room.guestName : 'Vacant')),
                DataCell(Text(room.adults.toString().padLeft(2, '0'))),
                DataCell(Text(room.kids.toString().padLeft(2, '0'))),
                DataCell(Text(room.seniorCitizens.toString().padLeft(2, '0'))),
                DataCell(Text(room.checkOutDate.isNotEmpty ? room.checkOutDate : '-')),
                DataCell(
                  Row(
                    children: [
                      Text(room.idProof.isNotEmpty ? room.idProof : 'No document'),
                      if (room.idProof.isNotEmpty) const Icon(Icons.insert_drive_file, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
