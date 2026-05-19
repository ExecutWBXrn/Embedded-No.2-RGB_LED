import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/states/ble_state_connection.dart';
import 'package:rgb_led_ble/shared/presentation/providers/providers.dart';

import '../../../../core/bluetooth/providers/providers.dart';

final class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchProviderValue = ref.watch(switchNotifierProvider);
    final switchProviderNotifier = ref.read(switchNotifierProvider.notifier);

    final themeValue = ref.read(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    final bleValue = ref.watch(bleDeviceNotifierProvider);
    final bleValueNotifier = ref.read(bleDeviceNotifierProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Turn on/off",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: switchProviderValue,
                onChanged: bleValue is BleStateConnected
                    ? (value) {
                        switchProviderNotifier.changeState(value);
                        bleValueNotifier.toggleESP32(value);
                      }
                    : null,
              ),
            ],
          ),
          HueRingPicker(
            pickerColor: themeValue,
            onColorChanged: (color) {
              themeNotifier.changeColor(color);
              bleValueNotifier.changeRGBESP32(color);
            },
          ),
        ],
      ),
    );
  }
}
