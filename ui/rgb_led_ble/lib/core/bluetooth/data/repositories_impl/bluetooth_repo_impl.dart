import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rgb_led_ble/core/bluetooth/data/datasource/local/bluetooth_ds.dart';
import '../../domain/repositories/bluetooth_repo.dart';

final class BluetoothRepoImpl extends BluetoothRepo {
  final BluetoothDs _bluetoothDs;
  BluetoothRepoImpl(this._bluetoothDs);

  @override
  Stream<List<ScanResult>> scanBluetoothDevices() {
    return _bluetoothDs.scanDevice();
  }
}
