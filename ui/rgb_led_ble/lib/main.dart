import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rgb_led_ble/core/router/router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:rgb_led_ble/shared/presentation/providers/providers.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = TalkerFlutter.init();

  if (await FlutterBluePlus.isSupported == false) {
    print("Bluetooth not supported by this device");
    return;
  }

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talker,
          settings: TalkerRiverpodLoggerSettings(printProviderUpdated: false),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSeedValue = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: colorSeedValue),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
