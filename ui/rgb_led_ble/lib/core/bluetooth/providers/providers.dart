import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgb_led_ble/core/bluetooth/data/datasource/local/bluetooth_ds.dart';
import 'package:rgb_led_ble/core/bluetooth/data/datasource/local/bluetooth_ds_impl.dart';
import 'package:rgb_led_ble/core/bluetooth/data/repositories_impl/bluetooth_repo_impl.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/repositories/bluetooth_repo.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/states/ble_state_connection.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/usecase/scan_devices_use_case.dart';
import '../notifiers/ble_notifier.dart';

final bleConnectionStateProvider = StreamProvider.autoDispose
    .family<BluetoothConnectionState, BluetoothDevice>((ref, device) {
      return device.connectionState;
    });

final bleDeviceNotifierProvider =
    NotifierProvider<BleNotifier, BleStateConnection>(BleNotifier.new);

final bleDsProvider = Provider<BluetoothDs>((_) => BluetoothDsImpl());

final bleRepoProvider = Provider<BluetoothRepo>(
  (ref) => BluetoothRepoImpl(ref.read(bleDsProvider)),
);

final bleDeviceScanUseCaseProvider = Provider.autoDispose<ScanDevicesUseCase>((
  ref,
) {
  return ScanDevicesUseCase(ref.read(bleRepoProvider));
});
