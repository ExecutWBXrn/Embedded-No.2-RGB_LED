import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int index) {
    if (state == index) return;
    state = index;
  }
}
