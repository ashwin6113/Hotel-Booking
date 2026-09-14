import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/check_in_screen.dart';
import '../screens/check_out_screen.dart';
import '../screens/reservations_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/check-out',
      builder: (context, state) => const CheckOutScreen(),
    ),
    GoRoute(
      path: '/reservations',
      builder: (context, state) => const ReservationsScreen(),
    ),
  ],
);
