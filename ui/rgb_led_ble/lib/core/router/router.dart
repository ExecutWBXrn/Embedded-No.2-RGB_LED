import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgb_led_ble/features/bluetooth/presentation/screens/bluetooth_screen.dart';
import 'package:rgb_led_ble/features/home/presentation/screens/home_screen.dart';
import 'package:rgb_led_ble/features/main/presentation/screens/main_screen.dart';

final routerProvider = Provider(
  (_) => GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: '/bluetooth',
            builder: (_, _) => const BluetoothScreen(),
          ),
        ],
      ),
    ],
  ),
);
