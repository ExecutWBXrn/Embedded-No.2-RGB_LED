import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class BleStateConnection {}

final class BleStateConnected extends BleStateConnection {
  BleStateConnected(this.device);
  final BluetoothDevice device;
}

final class BleStateDisconnected extends BleStateConnection {}

final class BleStateLoading extends BleStateConnection {}

final class BleStateError extends BleStateConnection {}

final class BleStateNoBluetooth extends BleStateConnection {}
