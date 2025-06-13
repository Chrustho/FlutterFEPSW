import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../objects/album.dart';
import '../support/app_constants.dart';



enum TypeHeader {
  json,
  urlencoded
}


class RestManager {
  String? token;


  Future<List<Album>> getAlbumByArtistaAndNome(String artista, String nome) async {
    String url = '${AppConstants.baseURl}${AppConstants.albumsCercaArtistaNome}?artista=$artista&nome=$nome';
    final response= await http.get(Uri.parse(url));

    var responseData= json.decode(response.body);
    List<Album> albums = [];
    for(var albumData in responseData) {
      albums.add(Album.fromJson(albumData));
    }
    return albums;
  }

  Future<Album> getAlbumById(int? id) async {
    String url = '${AppConstants.baseURl}${AppConstants.albumsGetByID}?id=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return Album.fromJson(responseData);
    } else {
      throw Exception('Failed to load album');
    }
  }


}