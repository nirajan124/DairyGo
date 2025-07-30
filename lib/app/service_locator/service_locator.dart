import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _initAuthModule();
  await _initHomeModule();
}

Future<void> _initAuthModule() async {
  // No local repository or Hive, only API-based logic now
}

Future<void> _initHomeModule() async {
  // Add any home module dependencies if needed
}
