import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract base class BluetoothDs {
  Stream<List<ScanResult>> scanDevice();
}
