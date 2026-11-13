import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'core/widgets.dart';
import 'firebase_options.dart';
import 'router/router.dart';
import 'services/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final options = DefaultFirebaseOptions.currentPlatform;
  if (options.apiKey == 'REPLACE_ME') {
    runApp(const SetupRequiredApp());
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: options);
  runApp(ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    child: const MoqMateApp(),
  ));
}

class MoqMateApp extends ConsumerWidget {
  const MoqMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MOQMate',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
