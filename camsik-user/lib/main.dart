import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/session_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.init();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikUser Error: ${details.exception}');
    };
    runApp(const CamsikUserApp());
  }, (error, stack) {
    debugPrint('CamsikUser Uncaught: $error\n$stack');
  });
}
