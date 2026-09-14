import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../repositories/hotel_repository.dart';

class HotelProvider extends ChangeNotifier {
  final HotelRepository _repository = HotelRepository();

  List<Room> get rooms => _repository.rooms;
  List<VacateRoom> get vacateRooms => _repository.vacateRooms;
  List<CheckoutBill> get checkoutBills => _repository.checkoutBills;
  OperationalMetrics? get metrics => _repository.metrics;
  bool get isLoaded => _repository.isLoaded;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  HotelProvider() {
    init();
  }

  Future<void> init() async {
    await _repository.loadData();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateRoomStatus(String roomNumber, String newStatus) {
    _repository.updateRoomStatus(roomNumber, newStatus);
    notifyListeners();
  }

  void setAllDirtyToCleaning() {
    for (var room in _repository.rooms) {
      if (room.status == 'dirty') {
        room.status = 'available';
      }
    }
    notifyListeners();
  }

  void addCheckIn({
    required Room room,
    required String guestName,
    required String phone,
    required String checkInDate,
    required String checkOutDate,
    required int adults,
    required int kids,
    required String idProof,
  }) {
    _repository.addCheckIn(room, guestName, phone, checkInDate, checkOutDate, adults, kids, idProof);
    notifyListeners();
  }

  void processCheckOut(String roomNumber) {
    _repository.processCheckOut(roomNumber);
    notifyListeners();
  }
}
