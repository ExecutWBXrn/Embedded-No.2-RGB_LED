import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgb_led_ble/shared/presentation/notifiers/theme_notifier.dart';
import '../notifiers/switch_notifier.dart';

final switchNotifierProvider = NotifierProvider<SwitchNotifier, bool>(
  SwitchNotifier.new,
);

final themeNotifierProvider = NotifierProvider<ThemeNotifier, Color>(
  ThemeNotifier.new,
);
