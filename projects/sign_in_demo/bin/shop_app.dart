// bin/field_app.dart
import 'dart:io';

import '../lib/features/sign_in/sign_in_service.dart';
import '../lib/utilities/app_environment.dart';
import '../lib/utilities/app_logger.dart';

void main() {
  // ---- WIRING: different choices, same building blocks ---------------
  final AppLogger logger = FileLogger('driver_app.log'); // logs go to a file

  const environment = AppEnvironment(
    name: 'prod',
    apiDomain: 'field.hsaapp.com', // a different domain
    isProduction: true,
  );

  final signIn = SignInService(logger: logger, environment: environment);
  // --------------------------------------------------------------------

  stdout.write('Phone: ');
  final phone = stdin.readLineSync() ?? '';
  stdout.write('PIN: ');
  final pin = stdin.readLineSync() ?? '';

  final result = signIn.signIn(phone.trim(), pin.trim());
  print('Result: ${result.name}  (see order_app.log)');
}
