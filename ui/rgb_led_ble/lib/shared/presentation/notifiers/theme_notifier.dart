import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ThemeNotifier extends Notifier<Color> {
  @override
  Color build() {
    return Colors.orange;
  }

  void changeColor(Color value) {
    state = value;
  }
}
