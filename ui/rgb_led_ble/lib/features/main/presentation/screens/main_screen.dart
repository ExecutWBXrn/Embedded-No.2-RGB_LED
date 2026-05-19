import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/states/ble_state_connection.dart';
import 'package:rgb_led_ble/core/bluetooth/providers/providers.dart';
import 'package:rgb_led_ble/shared/presentation/providers/providers.dart';
import '../providers/provider.dart';

final class MainScreen extends ConsumerWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndexValue = ref.watch(currentIndexProvider);
    final currentIndexNotifier = ref.read(currentIndexProvider.notifier);

    final colorSeed = ref.watch(themeNotifierProvider);

    final bleValue = ref.watch(bleDeviceNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (bleValue) {
          BleStateConnected() => bleValue.device.platformName,
          BleStateDisconnected() => "DEVICE NOT CONNECTED",
          BleStateLoading() => "LOADING...",
          BleStateError() => "Error",
          BleStateNoBluetooth() => "BLUETOOTH OFF",
        }, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorSeed.withAlpha(50),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndexValue,
        onTap: (index) {
          if (index == 0) {
            currentIndexNotifier.changeIndex(0);
            context.go('/');
          } else if (index == 1) {
            currentIndexNotifier.changeIndex(1);
            context.go('/bluetooth');
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: "Bluetooth",
          ),
        ],
      ),
    );
  }
}
