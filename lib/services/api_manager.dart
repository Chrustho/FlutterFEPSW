import 'dart:convert';
import 'package:album_reviews_app/models/objects/artista.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

/*
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

  /// Restituisce una pagina di album, applicando filtro e ricerca.
  Future<List<dynamic>> fetchAlbums({
    required String filter,    // "topRated", "recent", "mostPlayed"
    required int page,         // 0-based
    required int size,
    String? search,            // testo di ricerca (titolo)
  }) async {
    final params = {
      'page': page.toString(),
      'size': size.toString(),
      'filter': filter,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final uri = Uri.parse('$_baseUrl/api/albums').replace(queryParameters: params);
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento album (filtro=$filter, page=$page)');
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


  Future<Map<String, dynamic>> fetchAlbumDetail(int albumId)  async {
    final resp= await http.get(
      Uri.parse('$_baseUrl/api/albums/$albumId'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento dettaglio album (id=$albumId)');
  }





  Future<List<Artista>> fetchArtistsMostAlbums() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/artists/by_avg_vote'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(resp.body);
      return jsonList.map((json) => Artista.fromJson(json)).toList();
    }
    throw Exception('Errore caricamento artisti con i voti medi più alti');
  }



  Future<List<Artista>> fetchArtistsRecent() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/artists/recent_releases'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(resp.body);
      return jsonList.map((json) => Artista.fromJson(json)).toList();
    }
    throw Exception('Errore caricamento artisti recenti');

  }

  Future<List<Artista>> fetchArtistsMostPopular() async {
    final resp = await http.get(
        Uri.parse('$_baseUrl/artists/most_popular'),
        headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(resp.body);
    return jsonList.map((json) => Artista.fromJson(json)).toList();
    }
    throw Exception('Errore caricamento artisti popolari');
  }



  Future<Map<String, dynamic>> fetchArtistDetail(int artistId) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/api/artists/$artistId'),
      headers: await _authHeaders(),
    );
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    }
    throw Exception('Errore caricamento dettaglio artista (id=$artistId)');
  }


}
 */