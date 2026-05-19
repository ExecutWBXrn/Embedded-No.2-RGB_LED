import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../repositories/bluetooth_repo.dart';

class ScanDevicesUseCase {
  final BluetoothRepo _repo;
  ScanDevicesUseCase(this._repo);

  Stream<List<ScanResult>> call() {
    return _repo.scanBluetoothDevices();
  }
}
