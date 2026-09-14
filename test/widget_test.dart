import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_bokking_interview/main.dart';

void main() {
  testWidgets('HotelBookingApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HotelBookingApp());
    await tester.pumpAndSettle();

    // Verify main app title exists
    expect(find.text('Main Dashboard'), findsAtLeastNWidgets(1));
  });
}
