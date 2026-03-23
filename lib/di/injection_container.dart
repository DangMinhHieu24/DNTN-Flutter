import 'package:get_it/get_it.dart';
import 'package:features/auth/di/auth_injection.dart';

/// App-level service locator.
final sl = GetIt.instance;

/// Wires all feature module dependencies.
Future<void> initializeDependencies() async {
  AuthInjection.init(sl);
}
