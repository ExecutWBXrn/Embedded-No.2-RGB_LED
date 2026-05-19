import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import './bluetooth_ds.dart';

final class BluetoothDsImpl extends BluetoothDs {
  @override
  Stream<List<ScanResult>> scanDevice() {
    FlutterBluePlus.startScan(
      timeout: Duration(seconds: 15),
      androidUsesFineLocation: true,
    );

    return FlutterBluePlus.scanResults;
  }
}
