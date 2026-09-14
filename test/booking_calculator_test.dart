import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_bokking_interview/utils/booking_calculator.dart';

void main() {
  group('BookingCalculator Unit Tests', () {
    test('Valid 2-night booking calculates correct nights and total price', () {
      final checkIn = DateTime.now();
      final checkOut = checkIn.add(const Duration(days: 2));
      const pricePerNight = 3500.0;

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: pricePerNight,
      );

      expect(result.isValid, isTrue);
      expect(result.nights, equals(2));
      expect(result.totalPrice, equals(7000.0));
      expect(result.errorMessage, isNull);
    });

    test('Check-out date before check-in returns validation error', () {
      final checkIn = DateTime.now().add(const Duration(days: 3));
      final checkOut = DateTime.now().add(const Duration(days: 1));

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: 3500.0,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Check-out date must be after Check-in date.'));
    });

    test('Same-day check-in and check-out returns validation error', () {
      final checkIn = DateTime.now();
      final checkOut = checkIn;

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: 3500.0,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Check-out date must be after Check-in date.'));
    });

    test('Check-in date in the past returns validation error', () {
      final checkIn = DateTime.now().subtract(const Duration(days: 5));
      final checkOut = DateTime.now().add(const Duration(days: 2));

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: 3500.0,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Check-in date cannot be in the past.'));
    });

    test('Missing room selection returns error', () {
      final checkIn = DateTime.now();
      final checkOut = checkIn.add(const Duration(days: 2));

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: null,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Please select a room.'));
    });

    test('Guest count exceeding max capacity returns error', () {
      final checkIn = DateTime.now();
      final checkOut = checkIn.add(const Duration(days: 2));

      final result = BookingCalculator.calculateBooking(
        checkInDate: checkIn,
        checkOutDate: checkOut,
        pricePerNight: 3500.0,
        maxGuests: 2,
        requestedGuests: 4,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Selected room capacity (2 guests) is less than required'));
    });
  });
}
