import 'package:every_door_plugin/helpers/auth/provider.dart';
import 'package:flutter/material.dart';

/// Authentication provider for services with OAuth2. Which are
/// basically the most of them, including OpenStreetMap.
abstract class OAuth2AuthProvider extends AuthProvider {
  OAuth2AuthProvider({
    required String authorizeUrl,
    required String tokenUrl,
    required String clientId,
    required String clientSecret,
    required List<String> scopes,
  });

  @override
  AuthToken tokenFromJson(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<AuthToken?> login(BuildContext context) async => null;

  @override
  Future<void> logout(AuthToken token) async {
  }

  @override
  Future<AuthToken> refreshToken(AuthToken token) async => token;

  @override
  Map<String, String> getHeaders(AuthToken token) => {};
}
