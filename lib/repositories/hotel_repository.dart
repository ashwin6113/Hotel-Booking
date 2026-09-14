import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/room_model.dart';

class HotelRepository {
  List<Room> _rooms = [];
  List<VacateRoom> _vacateRooms = [];
  List<CheckoutBill> _checkoutBills = [];
  OperationalMetrics? _metrics;
  bool _isLoaded = false;

  List<Room> get rooms => _rooms;
  List<VacateRoom> get vacateRooms => _vacateRooms;
  List<CheckoutBill> get checkoutBills => _checkoutBills;
  OperationalMetrics? get metrics => _metrics;
  bool get isLoaded => _isLoaded;

  Future<void> loadData() async {
    try {
      String jsonString;
      try {
        jsonString = await rootBundle.loadString('assets/data.json');
      } catch (_) {
        jsonString = await rootBundle.loadString('assets/dat.json');
      }
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _rooms = (data['rooms'] as List?)?.map((r) => Room.fromJson(r)).toList() ?? [];
      _vacateRooms = (data['vacateRooms'] as List?)?.map((v) => VacateRoom.fromJson(v)).toList() ?? [];
      _checkoutBills = (data['checkoutBills'] as List?)?.map((b) => CheckoutBill.fromJson(b)).toList() ?? [];
      if (data['metrics'] != null) {
        _metrics = OperationalMetrics.fromJson(data['metrics']);
      }
      _isLoaded = true;
    } catch (e) {
      // Fallback empty default list if error loading
      _rooms = [];
      _isLoaded = true;
    }
  }

  void updateRoomStatus(String roomNumber, String newStatus) {
    final index = _rooms.indexWhere((r) => r.roomNumber == roomNumber);
    if (index != -1) {
      _rooms[index].status = newStatus;
    }
  }

  void addCheckIn(Room room, String guestName, String phone, String checkInDate, String checkOutDate, int adults, int kids, String idProof) {
    final index = _rooms.indexWhere((r) => r.roomNumber == room.roomNumber);
    if (index != -1) {
      _rooms[index] = _rooms[index].copyWith(
        status: 'occupied',
        guestName: guestName,
        phone: phone,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        adults: adults,
        kids: kids,
        idProof: idProof,
      );
    }
  }

  void processCheckOut(String roomNumber) {
    final index = _rooms.indexWhere((r) => r.roomNumber == roomNumber);
    if (index != -1) {
      _rooms[index] = _rooms[index].copyWith(
        status: 'dirty',
        guestName: '',
        phone: '',
        checkInDate: '',
        checkOutDate: '',
        adults: 0,
        kids: 0,
        idProof: '',
      );
    }
    _checkoutBills.removeWhere((b) => b.roomNumber == roomNumber);
    _vacateRooms.removeWhere((v) => v.roomNumber == roomNumber);
  }
}
