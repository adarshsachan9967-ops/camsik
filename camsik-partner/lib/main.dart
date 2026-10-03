import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/session_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.init();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    runApp(const CamsikPartnerApp());
  }, (error, stack) {
    debugPrint('Global Camsik Partner Error: $error');
  });
}
