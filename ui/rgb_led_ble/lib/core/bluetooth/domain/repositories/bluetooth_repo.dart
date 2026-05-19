import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothRepo {
  Stream<List<ScanResult>> scanBluetoothDevices();
}
