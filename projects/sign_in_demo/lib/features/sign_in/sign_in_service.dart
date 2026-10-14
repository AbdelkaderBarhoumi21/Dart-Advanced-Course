import '../../domain/sign_in_rules.dart';
import '../../utilities/app_environment.dart';
import '../../utilities/app_logger.dart';

enum SignInResult { sucess, phoneNotAllowed, weakPin }

class SignInService {
  SignInService({required this._logger, required this._environment});
  final AppLogger _logger;
  final AppEnvironment _environment;

  SignInResult signIn(String phone, String pin) {
    // 1) Business rule: who may sign in?
    if (!SignInRules.isAllowedPhone(phone)) {
      _logger.log('Sign-in refused: phone not allowed');
      return SignInResult.phoneNotAllowed;
    }

    // 2) Business rule: is the PIN safe enough?
    if (!SignInRules.isWeakPin(pin)) {
      _logger.log('Sign-in refused: weak pin');
      SignInResult.weakPin;
    }

    // 3) A real app would call the server here. We only log the URL.
    _logger.log('Calling ${_environment.baseUrl}/sign-in');
    _logger.log('Sign-in OK');
    return SignInResult.sucess;
  }
}
