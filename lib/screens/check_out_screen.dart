import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../providers/hotel_provider.dart';
import '../widgets/responsive_scaffold.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final List<String> _selectedRoomsForCheckout = ['101', '103'];
  String _selectedPaymentMethod = 'Credit Card';
  final TextEditingController _paymentAmountController = TextEditingController(text: '8200.00');

  @override
  void dispose() {
    _paymentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/check-out',
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final isDesktop = MediaQuery.of(context).size.width >= 1100;
          final bills = provider.checkoutBills;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title & Search
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Guest Check-out',
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

                // 3 Step Process Panels Layout
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStep1IdentifyGuestCard(provider)),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: _buildStep2ReviewFinalizeBillCard(provider, bills)),
                      const SizedBox(width: 14),
                      Expanded(flex: 3, child: _buildStep3PaymentCheckoutCard(context, provider)),
                    ],
                  )
                else ...[
                  _buildStep1IdentifyGuestCard(provider),
                  const SizedBox(height: 14),
                  _buildStep2ReviewFinalizeBillCard(provider, bills),
                  const SizedBox(height: 14),
                  _buildStep3PaymentCheckoutCard(context, provider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep1IdentifyGuestCard(HotelProvider provider) {
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
          _buildPanelHeader('1. Identify Departing Guest'),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Guest',
                    hintStyle: const TextStyle(fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'By Room',
                    hintText: '101',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
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
                      value: 'Mathew Hyden',
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Mathew Hyden', child: Text('Mathew Hyden', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Sarah Thompson', child: Text('Sarah Thompson', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2B45),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Find Room/Guest', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Guest & Room Badge Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Guest Name', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  Text('Mathew Hyden', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD97706)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.hotel, size: 16, color: Color(0xFF92400E)),
                    SizedBox(width: 4),
                    Text('101', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF78350F))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Rooms table list
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: const Color(0xFFF9FAFB),
                  child: Row(
                    children: const [
                      Expanded(flex: 1, child: Text('Room', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                      Expanded(flex: 3, child: Text('Stay Dates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                      Expanded(flex: 3, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    ],
                  ),
                ),
                _buildCheckoutRoomRow('101', '02/04/2026-04/04/2026'),
                const Divider(height: 1),
                _buildCheckoutRoomRow('103', '02/04/2026-04/04/2026'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Add/Change Selected Rooms', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutRoomRow(String roomNo, String stayDates) {
    final isSelected = _selectedRoomsForCheckout.contains(roomNo);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(roomNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 3, child: Text(stayDates, style: const TextStyle(fontSize: 11))),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedRoomsForCheckout.add(roomNo);
                      } else {
                        _selectedRoomsForCheckout.remove(roomNo);
                      }
                    });
                  },
                ),
                const Text('Select for Check-out', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2ReviewFinalizeBillCard(HotelProvider provider, List<CheckoutBill> bills) {
    double totalCombined = bills.fold(0.0, (sum, bill) => sum + bill.totalBill);

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
          _buildPanelHeader('2. Review & Finalize Bill'),
          const SizedBox(height: 14),

          // Render itemized bill sections for each room
          for (var bill in bills) ...[
            _buildRoomBillSection(bill),
            const SizedBox(height: 16),
          ],

          // Combined total footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              'Selected Rooms Combined Total: ₹${totalCombined.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomBillSection(CheckoutBill bill) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '[Room ${bill.roomNumber}]',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Nights: ${bill.nights}, Rate: ₹${bill.rate.toStringAsFixed(2)}, Total: ₹${bill.totalRoomCharge.toStringAsFixed(2)})',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Add additional charges search bar
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 32,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search/Add Additional Charges',
                    hintStyle: const TextStyle(fontSize: 11),
                    prefixIcon: const Icon(Icons.search, size: 14),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: const Text('Mini-bar', style: TextStyle(fontSize: 11))),
            const SizedBox(width: 4),
            OutlinedButton(onPressed: () {}, child: const Text('Laundry', style: TextStyle(fontSize: 11))),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D2B45), foregroundColor: Colors.white, minimumSize: const Size(32, 32)),
              child: const Icon(Icons.add, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Charges table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                color: const Color(0xFFF9FAFB),
                child: Row(
                  children: const [
                    Expanded(flex: 3, child: Text('Room Charges & External Bills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    Expanded(flex: 2, child: Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  ],
                ),
              ),
              for (var charge in bill.additionalCharges)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(charge.name, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 2, child: Text(charge.date, style: const TextStyle(fontSize: 11, color: Colors.grey))),
                      Expanded(flex: 2, child: Text('₹${charge.amount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Room Total & Action Buttons
        Row(
          children: [
            Text('Room ${bill.roomNumber} Total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            Text('₹${bill.totalBill.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, size: 14),
                label: Text('Print Room ${bill.roomNumber} Invoice', style: const TextStyle(fontSize: 11)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D2B45), foregroundColor: Colors.white),
                icon: const Icon(Icons.swap_horiz, size: 14),
                label: Text('Adjust Charges (Room ${bill.roomNumber})', style: const TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3PaymentCheckoutCard(BuildContext context, HotelProvider provider) {
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
          _buildPanelHeader('3. Payment & Check-out'),
          const SizedBox(height: 14),

          _buildChargeRow('Total Amount Due', '₹8200.00', isBold: true, fontSize: 16),
          _buildChargeRow('(Selected Rooms)', '₹0.00', fontSize: 13),
          const SizedBox(height: 12),

          const Text('Payment Method', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPaymentMethod,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'M-Pay', child: Text('M-Pay', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPaymentMethod = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text('Payment Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextField(
            controller: _paymentAmountController,
            decoration: InputDecoration(
              prefixText: '₹ ',
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                for (var r in _selectedRoomsForCheckout) {
                  provider.processCheckOut(r);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment Processed & Rooms Checked-Out!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2B45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                children: const [
                  Text('Process Payment & Check-out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Proceed with Room 101 Check-out', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  Text('Complete Check-out', style: TextStyle(fontSize: 10, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                for (var r in _selectedRoomsForCheckout) {
                  provider.processCheckOut(r);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Combined Check-out Processed!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E56A0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                children: const [
                  Text('Payment & Check-out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Combine and Proceed with Selected Rooms Check-out', style: TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print, size: 14),
                  label: const Text('Print Final Invoice', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined, size: 14),
                  label: const Text('Email Final Invoice', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, String amount, {bool isBold = false, double fontSize = 13}) {
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
              color: isBold ? const Color(0xFF111827) : const Color(0xFF4B5563),
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
}
