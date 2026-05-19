import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/states/ble_state_connection.dart';
import 'package:rgb_led_ble/core/bluetooth/providers/providers.dart';

import '../../../../shared/presentation/providers/providers.dart';

final class BluetoothScreen extends HookConsumerWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSeed = ref.watch(themeNotifierProvider);

    final bleValue = ref.watch(bleDeviceNotifierProvider);
    final bleValueNotifier = ref.read(bleDeviceNotifierProvider.notifier);

    final scanRes = ref.watch(bleDeviceScanUseCaseProvider)();

    return switch (bleValue) {
      BleStateConnected() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            Text("Connected: ${bleValue.device.platformName}"),
            SizedBox(
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  bleValueNotifier.disconnect();
                  ref.refresh(bleDeviceScanUseCaseProvider);
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(CircleBorder()),
                ),
                child: Center(child: Text("Disconnect")),
              ),
            ),
          ],
        ),
      ),
      BleStateDisconnected() => SingleChildScrollView(
        child: StreamBuilder(
          stream: scanRes,
          initialData: [],
          builder: (BuildContext context, snapshot) {
            return Column(
              children:
                  snapshot.data
                      ?.map(
                        (res) => Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colorSeed.withAlpha(30),
                            border: BoxBorder.all(),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            onTap: () {
                              bleValueNotifier.connect(res.device);
                            },
                            leading: Icon(Icons.bluetooth),
                            title: Text(
                              res.device.platformName == ''
                                  ? 'Unknown device'
                                  : res.device.platformName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text("${res.rssi} dm"),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            );
          },
        ),
      ),
      BleStateLoading() => Center(child: Text("Loading")),
      BleStateError() => Center(child: Text("Error")),
      BleStateNoBluetooth() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            Text(
              "Try turn on bluetooth",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  bleValueNotifier.tryTurnOnBluetooth();
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(CircleBorder()),
                ),
                child: Center(child: Text("Turn on")),
              ),
            ),
          ],
        ),
      ),
    };
  }
}
