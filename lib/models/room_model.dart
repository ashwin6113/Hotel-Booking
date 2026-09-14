class Room {
  final String roomCode;
  final String roomNumber;
  final String roomType;
  final double pricePerNight;
  final double gstPercent;
  final int maxGuests;
  String status; // 'available', 'occupied', 'dirty', 'maintenance', 'blocked'
  final String floor;
  String guestName;
  String phone;
  String checkInDate;
  String checkOutDate;
  int adults;
  int kids;
  int seniorCitizens;
  String idProof;

  Room({
    required this.roomCode,
    required this.roomNumber,
    required this.roomType,
    required this.pricePerNight,
    required this.gstPercent,
    required this.maxGuests,
    required this.status,
    required this.floor,
    this.guestName = '',
    this.phone = '',
    this.checkInDate = '',
    this.checkOutDate = '',
    this.adults = 0,
    this.kids = 0,
    this.seniorCitizens = 0,
    this.idProof = '',
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomCode: json['roomCode'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? 'Deluxe Room',
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      gstPercent: (json['gstPercent'] as num?)?.toDouble() ?? 0.0,
      maxGuests: json['maxGuests'] ?? 2,
      status: json['status'] ?? 'available',
      floor: json['floor'] ?? 'Floor 1',
      guestName: json['guestName'] ?? '',
      phone: json['phone'] ?? '',
      checkInDate: json['checkInDate'] ?? '',
      checkOutDate: json['checkOutDate'] ?? '',
      adults: json['adults'] ?? 0,
      kids: json['kids'] ?? 0,
      seniorCitizens: json['seniorCitizens'] ?? 0,
      idProof: json['idProof'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'roomNumber': roomNumber,
      'roomType': roomType,
      'pricePerNight': pricePerNight,
      'gstPercent': gstPercent,
      'maxGuests': maxGuests,
      'status': status,
      'floor': floor,
      'guestName': guestName,
      'phone': phone,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'adults': adults,
      'kids': kids,
      'seniorCitizens': seniorCitizens,
      'idProof': idProof,
    };
  }

  Room copyWith({
    String? roomCode,
    String? roomNumber,
    String? roomType,
    double? pricePerNight,
    double? gstPercent,
    int? maxGuests,
    String? status,
    String? floor,
    String? guestName,
    String? phone,
    String? checkInDate,
    String? checkOutDate,
    int? adults,
    int? kids,
    int? seniorCitizens,
    String? idProof,
  }) {
    return Room(
      roomCode: roomCode ?? this.roomCode,
      roomNumber: roomNumber ?? this.roomNumber,
      roomType: roomType ?? this.roomType,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      gstPercent: gstPercent ?? this.gstPercent,
      maxGuests: maxGuests ?? this.maxGuests,
      status: status ?? this.status,
      floor: floor ?? this.floor,
      guestName: guestName ?? this.guestName,
      phone: phone ?? this.phone,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      adults: adults ?? this.adults,
      kids: kids ?? this.kids,
      seniorCitizens: seniorCitizens ?? this.seniorCitizens,
      idProof: idProof ?? this.idProof,
    );
  }
}

class VacateRoom {
  final String roomNumber;
  final String guestName;
  final String statusText;
  final String checkoutTime;
  final String imageUrl;

  VacateRoom({
    required this.roomNumber,
    required this.guestName,
    required this.statusText,
    required this.checkoutTime,
    required this.imageUrl,
  });

  factory VacateRoom.fromJson(Map<String, dynamic> json) {
    return VacateRoom(
      roomNumber: json['roomNumber'] ?? '',
      guestName: json['guestName'] ?? '',
      statusText: json['statusText'] ?? '',
      checkoutTime: json['checkoutTime'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class AdditionalCharge {
  final String name;
  final String date;
  final double amount;

  AdditionalCharge({
    required this.name,
    required this.date,
    required this.amount,
  });

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) {
    return AdditionalCharge(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CheckoutBill {
  final String roomNumber;
  final String guestName;
  final int nights;
  final double rate;
  final double totalRoomCharge;
  final String stayDates;
  final List<AdditionalCharge> additionalCharges;

  CheckoutBill({
    required this.roomNumber,
    required this.guestName,
    required this.nights,
    required this.rate,
    required this.totalRoomCharge,
    required this.stayDates,
    required this.additionalCharges,
  });

  factory CheckoutBill.fromJson(Map<String, dynamic> json) {
    return CheckoutBill(
      roomNumber: json['roomNumber'] ?? '',
      guestName: json['guestName'] ?? '',
      nights: json['nights'] ?? 1,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      totalRoomCharge: (json['totalRoomCharge'] as num?)?.toDouble() ?? 0.0,
      stayDates: json['stayDates'] ?? '',
      additionalCharges: (json['additionalCharges'] as List?)
              ?.map((e) => AdditionalCharge.fromJson(e))
              .toList() ??
          [],
    );
  }

  double get totalBill {
    final extraTotal = additionalCharges.fold(0.0, (sum, item) => sum + item.amount);
    return totalRoomCharge + extraTotal;
  }
}

class OperationalMetrics {
  final double occupancyPercentage;
  final int pendingCheckIns;
  final int pendingDepartures;
  final double revenueToday;
  final int totalRooms;

  OperationalMetrics({
    required this.occupancyPercentage,
    required this.pendingCheckIns,
    required this.pendingDepartures,
    required this.revenueToday,
    required this.totalRooms,
  });

  factory OperationalMetrics.fromJson(Map<String, dynamic> json) {
    return OperationalMetrics(
      occupancyPercentage: (json['occupancyPercentage'] as num?)?.toDouble() ?? 0.0,
      pendingCheckIns: json['pendingCheckIns'] ?? 0,
      pendingDepartures: json['pendingDepartures'] ?? 0,
      revenueToday: (json['revenueToday'] as num?)?.toDouble() ?? 0.0,
      totalRooms: json['totalRooms'] ?? 200,
    );
  }
}
