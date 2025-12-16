import 'package:every_door_plugin/helpers/auth/provider.dart';
import 'package:flutter/material.dart';

/// This controller manages an [AuthProvider], saving a token to the
/// local storage and keeping user details in [value] ready to display.
class AuthController extends ValueNotifier<UserDetails?> {
  /// Controller name. Should be overridden, and unique, otherwise
  /// tokens would get mixed up.
  final String name;

  final AuthProvider provider;

  AuthController(this.name, this.provider): super(null);

  bool get authorized => value != null;

  String get endpoint => provider.endpoint;

  Future<void> loadData() async {
  }

  Future<void> login(BuildContext context) async {
  }

  Future<void> logout() async {
  }

  Future<AuthToken> fetchToken(BuildContext? context) async {
    throw AuthException("User is not logged in");
  }

  Future<Map<String, String>> getAuthHeaders(BuildContext? context) async {
    throw AuthException('Could not use the saved token, please re-login.');
  }

  Future<String?> getApiKey(BuildContext? context) async {
    throw AuthException('Could not use the saved token, please re-login.');
  }

  String get tokenKey => 'authToken_$name';

  Future<AuthToken?> loadToken() async {
    return null;
  }

  Future<void> saveToken(AuthToken? token) async {
  }
}