import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SwitchNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void changeState(bool value) {
    state = value;
  }
}
