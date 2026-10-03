import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikAdmin Error: ${details.exception}');
    };
    runApp(const CamsikAdminApp());
  }, (error, stack) {
    debugPrint('CamsikAdmin Uncaught: $error\n$stack');
  });
}
