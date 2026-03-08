import 'dart:convert';
import 'package:flutter/services.dart';

enum Environment { development, staging, production }

class Env {
  Env._();
  static Env? _instance;
  static Env get instance {
    _instance ??= Env._();
    return _instance!;
  }

  static Map<String, dynamic> _variables = {};
  static dynamic get(String key) => _variables[key];

  static Environment environment = Environment.development;

  static Future<void> initialize() async {
    String fileName;
    switch (environment) {
      case Environment.development:
        fileName = 'lib/env/dev.json';
        break;
      case Environment.staging:
        fileName = 'lib/env/staging.json';
        break;
      case Environment.production:
        fileName = 'lib/env/prod.json';
        break;
    }
    _variables = await load(fileName);
  }

  static Future<Map<String, dynamic>> load(String fileName) async {
    final String response = await rootBundle.loadString(fileName);
    return json.decode(response);
  }
}
