import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Endpoint Keycloak
  static const _baseUrl =
      'http://localhost:8080/auth/realms/album-realm/protocol/openid-connect';
  static const _clientId = 'album-app';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Effettua il login con Resource Owner Password Credentials (ROP grant).
  /// Se va a buon fine salva access & refresh token in storage.
  Future<bool> login(String username, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': _clientId,
        'username': username,
        'password': password,
      },
    );

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      return true;
    }
    return false;
  }

  /// Restituisce l'access token corrente, o null se non loggato.
  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  /// Effettua il logout: chiama l’endpoint di revoca e poi cancella i token.
  Future<void> logout() async {
    final refresh = await _storage.read(key: 'refresh_token');
    if (refresh != null) {
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'refresh_token': refresh,
        },
      );
    }
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Controlla se l'utente è loggato (esiste un token salvato).
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
