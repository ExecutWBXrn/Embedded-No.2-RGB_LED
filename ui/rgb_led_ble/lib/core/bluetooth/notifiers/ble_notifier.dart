import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgb_led_ble/core/bluetooth/domain/states/ble_state_connection.dart';

import '../providers/providers.dart';
import '../services/ble_service.dart';

class BleNotifier extends Notifier<BleStateConnection> {
  BluetoothDevice? _currentDevice;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<BluetoothConnectionState>? _deviceConnectionSub;
  BluetoothCharacteristic? _rgbCharacteristic;
  BluetoothCharacteristic? _switchCharacteristic;

  @override
  BleStateConnection build() {
    ref.onDispose(() {
      _adapterSub?.cancel();
      _deviceConnectionSub?.cancel();
    });

    tryTurnOnBluetooth();

    _adapterSub = FlutterBluePlus.adapterState.listen((adapterState) {
      if (adapterState != BluetoothAdapterState.on) {
        _currentDevice = null;
        _deviceConnectionSub?.cancel();
        state = BleStateNoBluetooth();
      } else {
        _syncExistingConnection();
      }
    });

    if (FlutterBluePlus.connectedDevices.isNotEmpty) {
      final device = FlutterBluePlus.connectedDevices.last;
      _currentDevice = device;
      _listenToDeviceState(device);
      return BleStateConnected(device);
    }

    return BleStateDisconnected();
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      state = BleStateLoading();
      await device.connect(license: License.free);
      await _discoverAllCharacteristics(device);
      _currentDevice = device;
      state = BleStateConnected(device);
    } catch (e) {
      state = BleStateError();
    }
  }

  Future<void> disconnect() async {
    try {
      if (_currentDevice != null) {
        state = BleStateLoading();
        await _currentDevice!.disconnect();
        _resetCharacteristics();
        await FlutterBluePlus.stopScan();
        state = BleStateDisconnected();
      }
    } catch (e) {
      state = BleStateError();
    }
  }

  void _listenToDeviceState(BluetoothDevice device) {
    _deviceConnectionSub?.cancel();

    _deviceConnectionSub = device.connectionState.listen((connectionState) {
      if (connectionState == BluetoothConnectionState.disconnected) {
        _currentDevice = null;
        _deviceConnectionSub?.cancel();
        state = BleStateDisconnected();
      } else if (connectionState == BluetoothConnectionState.connected) {
        state = BleStateConnected(device);
      }
    });
  }

  void _syncExistingConnection() {
    if (FlutterBluePlus.connectedDevices.isNotEmpty) {
      final device = FlutterBluePlus.connectedDevices.last;
      _currentDevice = device;
      _listenToDeviceState(device);
    } else if (state is! BleStateDisconnected && state is! BleStateLoading) {
      state = BleStateDisconnected();
    }
  }

  Future<void> tryTurnOnBluetooth() async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        if (kDebugMode) {
          print("не вдалось увімкнути блютуз");
        }
      }
    }
  }

  Future<void> _discoverAllCharacteristics(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      for (BluetoothService service in services) {
        if (service.uuid.toString() == BleService.SERVICE_UUID) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid.toString() ==
                BleService.CHARACTERISTIC_RGB_LED_UUID) {
              _rgbCharacteristic = char;
            }
            if (char.uuid.toString() == BleService.CHARACTERISTIC_SWITCH_UUID) {
              _switchCharacteristic = char;
            }
          }
        }
      }
    } catch (e) {
      print("Помилка при пошуку характеристик: $e");
    }
  }

  void _resetCharacteristics() {
    _rgbCharacteristic = null;
    _switchCharacteristic = null;
  }

  Future<void> toggleESP32(bool value) async {
    if (state is BleStateConnected && _switchCharacteristic != null) {
      try {
        _switchCharacteristic!.write(
          [value ? 1 : 0],
          allowLongWrite: false,
          withoutResponse: true,
        );
      } catch (e) {
        print("Помилка включення/виключення esp32: $e");
      }
    }
  }

  Future<void> changeRGBESP32(Color color) async {
    if (state is BleStateConnected && _rgbCharacteristic != null) {
      try {
        _rgbCharacteristic!.write(
          [color.red, color.green, color.blue],
          allowLongWrite: false,
          withoutResponse: true,
        );
      } catch (e) {
        print("Помилка відправки кольору: $e");
      }
    }
  }
}
