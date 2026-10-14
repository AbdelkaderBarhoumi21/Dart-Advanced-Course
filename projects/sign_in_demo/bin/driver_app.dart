import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../lib/features/sign_in/sign_in_service.dart';
import '../lib/utilities/app_environment.dart';
import '../lib/utilities/app_logger.dart';
import '../lib/utilities/debouncer.dart';

const apiDomain = String.fromEnvironment(
  'API_DOMAIN',
  defaultValue: 'test.com',
);

Future<void> main() async {
  // ---- WIRING: this app's choices ------------------------------------
  final AppLogger logger = TimestampLogger(ConsoleLogger()); // console + time
  const env = AppEnvironment(
    name: 'dev',
    apiDomain: apiDomain,
    isProduction: false,
  );

  final service = SignInService(logger: logger, environment: env);

  // Demo of the debouncer: pretend the user types the phone quickly.
  final debouncer = Debouncer(const Duration(milliseconds: 300));
  for (final typed in ['+2', '+216', '+21620', '+21620889', '+21620889999']) {
    debouncer.run(() => logger.log('Checking phone : $typed'));
    await Future<void>.delayed(const Duration(milliseconds: 100)); // fast typing    debouncer.dispose(); // Only "+21620889999" is printed: the earlier calls were cancelled.
  }

  await Future<void>.delayed(const Duration(milliseconds: 400)); // user stops
  debouncer.dispose();

  // Real input from the terminal.
  stdout.write('Phone: ');
  final String phone = stdin.readLineSync() ?? '';
  stdout.write('Pin: ');
  final String pin = stdin.readLineSync() ?? '';
  final result = service.signIn(phone, pin);

  // The app decides what to SHOW. Showing text is the app's job.
  switch (result) {
    case SignInResult.phoneNotAllowed:
      print('Sorry, only +216 numbers are supported.');
    case SignInResult.weakPin:
      print('Please choose a stronger PIN.');
    case SignInResult.sucess:
      print('Success!');
  }
}
