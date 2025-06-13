import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiManager {
  static const _baseUrl = 'http://localhost:8082';
  final AuthService _auth = AuthService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _auth.getAccessToken() ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> fetchAlbums() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/albums'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento album');
  }

  Future<List<dynamic>> fetchArtists() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/artists'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento artisti');
  }

  Future<void> createReview(int albumId, int rating, String comment) async {
    final body = json.encode({
      'albumId': albumId,
      'rating': rating,
      'comment': comment,
    });
    final resp = await http.post(
      Uri.parse('$_baseUrl/api/reviews'),
      headers: await _authHeaders(),
      body: body,
    );
    if (resp.statusCode != 201) {
      throw Exception('Impossibile creare recensione');
    }
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/users/me'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento profilo');
  }

  Future<List<dynamic>> fetchMyReviews() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/users/me/reviews'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento recensioni utente');
  }
}
