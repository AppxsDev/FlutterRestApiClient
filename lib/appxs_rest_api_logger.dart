// ignore_for_file: avoid_print

import 'package:logger/logger.dart';

import 'appxs_rest_api_config.dart';

class AppxsRestApiLogger {
  static late Logger logger;
  final AppxsRestApiConfig config;

  AppxsRestApiLogger.init({required this.config}) {
    logger = Logger(
        level: Level.debug,
        printer: PrettyPrinter(
            noBoxingByDefault: true,
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 50,
            colors: true,
            printEmojis: false,
            printTime: false));
  }

  void log(Level level, String message) {
    if (config.allowLog) {
      logger.log(level, "│ " + message);
    }
  }

  void openBox() {
    if (config.allowLog) {
      print("┌─────────────────────────────────────────────────");
    }
  }

  void closeBox() {
    if (config.allowLog) {
      print("└─────────────────────────────────────────────────");
    }
  }
}
