class BookingValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int nights;
  final double totalPrice;

  BookingValidationResult({
    required this.isValid,
    this.errorMessage,
    this.nights = 0,
    this.totalPrice = 0.0,
  });
}

class BookingCalculator {
  /// Calculates nights and total price with full date & guest validation.
  static BookingValidationResult calculateBooking({
    required DateTime? checkInDate,
    required DateTime? checkOutDate,
    required double? pricePerNight,
    int? maxGuests,
    int? requestedGuests,
  }) {
    if (checkInDate == null) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Please select a Check-in date.',
      );
    }

    if (checkOutDate == null) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Please select a Check-out date.',
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInNormalized = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
    final checkOutNormalized = DateTime(checkOutDate.year, checkOutDate.month, checkOutDate.day);

    if (checkInNormalized.isBefore(today)) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Check-in date cannot be in the past.',
      );
    }

    if (!checkOutNormalized.isAfter(checkInNormalized)) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Check-out date must be after Check-in date.',
      );
    }

    if (pricePerNight == null || pricePerNight <= 0) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Please select a room.',
      );
    }

    if (maxGuests != null && requestedGuests != null && requestedGuests > maxGuests) {
      return BookingValidationResult(
        isValid: false,
        errorMessage: 'Selected room capacity ($maxGuests guests) is less than required ($requestedGuests guests).',
      );
    }

    final nights = checkOutNormalized.difference(checkInNormalized).inDays;
    final totalPrice = nights * pricePerNight;

    return BookingValidationResult(
      isValid: true,
      nights: nights,
      totalPrice: totalPrice,
    );
  }
}
