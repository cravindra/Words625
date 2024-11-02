// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Project imports:
import 'package:words625/di/injection.dart';
import 'package:words625/firebase_options.dart';
import 'package:words625/service/locator.dart';
import 'package:words625/views/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await setupLocator();

  getIt<AppPrefs>().preferences.clear();

  if (!kIsWeb) {
    final result = await getIt<FlutterTts>().isLanguageAvailable("kn-IN");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const Words625App());
}
