import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/main_notifier.dart';

final currentIndexProvider = NotifierProvider<MainNotifier, int>(
  MainNotifier.new,
);
