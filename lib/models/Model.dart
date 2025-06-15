import 'dart:async';
import 'dart:convert';

import 'package:album_reviews_app/models/objects/album.dart';
import 'package:album_reviews_app/models/objects/artista.dart';
import 'package:album_reviews_app/models/objects/recensione_album.dart';
import 'package:album_reviews_app/models/support/LogInResult.dart';
import 'package:album_reviews_app/models/support/app_constants.dart';
import 'package:album_reviews_app/models/support/user_registration.dart';

import 'managers/RestManager.dart';
import 'objects/AuthenticationData.dart';
import 'objects/users.dart';





class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();

  AuthenticationData? _authenticationData;


  Future<LogInResult> logIn(String email, String password) async {
    try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = AppConstants.CLIENT_ID;
      params["client_secret"] = AppConstants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(AppConstants.ADDRESS_AUTHENTICATION_SERVER, AppConstants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        if ( _authenticationData!.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData!.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData!.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData!.expiresIn - 50)), (Timer t) {
        _refreshToken();
      });
      return LogInResult.logged;
    }
    catch (e) {
      return LogInResult.error_unknown;
    }

  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = AppConstants.CLIENT_ID;
      params["client_secret"] = AppConstants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      String result = await _restManager.makePostRequest(AppConstants.ADDRESS_AUTHENTICATION_SERVER, AppConstants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData!.accessToken;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = AppConstants.CLIENT_ID;
      params["client_secret"] = AppConstants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      await _restManager.makePostRequest(AppConstants.ADDRESS_AUTHENTICATION_SERVER, AppConstants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }


  Future<Users?>? addUser(Users user, String password) async {
    UserRegistrationRequest s=new UserRegistrationRequest(user: user,password: password);
    try {
      String rawResult = await _restManager.makePostRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.REQUEST_ADD_USER, s);
      if ( rawResult.contains(AppConstants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        return null; // not the best solution
      }
      else {
        return Users.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<Album>> getAllAlbums(Map<String,String> params) async{
    List<dynamic> rawResult= jsonDecode(await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.albumsGetAll, params)) as List;
    List<Album> albums = rawResult.map((e) => Album.fromJson(e)).toList();
    if (albums.isEmpty) {
      return [];
    }
    return albums;
  }

  Future<List<Artista>> getMostPopularArtists() async {
    List<dynamic> rawResult = jsonDecode(await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.artistsMostPopular)) as List;
    List<Artista> artists = rawResult.map((e) => Artista.fromJson(e)).toList();
    if (artists.isEmpty) {
      return [];
    }
    return artists;
  }

  Future<List<Artista>> getArtistsByAvgVote() async {
    List<dynamic> rawResult = jsonDecode(await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.artistsSearchByAvgVote)) as List;
    List<Artista> artists = rawResult.map((e) => Artista.fromJson(e)).toList();
    if (artists.isEmpty) {
      return [];
    }
    return artists;
  }

  Future<List<Artista>> getArtistsRecentReleases() async {
    List<dynamic> rawResult = jsonDecode(await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.artistsRecentRelease)) as List;
    List<Artista> artists = rawResult.map((e) => Artista.fromJson(e)).toList();
    if (artists.isEmpty) {
      return [];
    }
    return artists;
  }

  Future<Artista?> fetchArtistDetail(int artistId) async {
    final resp = await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, "${AppConstants.artistsEndpoint}/$artistId");
    if (resp.isNotEmpty) {
      return Artista.fromJson(jsonDecode(resp));
    }
    return null;
  }

  Future<Album?> fetchAlbumDetail(int albumId) async {
    Map<String,String> paarams = Map();
    paarams["id"] = albumId.toString();
    final resp = await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.albumsGetByID);
    if (resp.isNotEmpty) {
      return Album.fromJson(jsonDecode(resp));
    }
    return null;
  }

  Future<Users> getUserById(int userId) async {
    final resp = await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, "${AppConstants.usersEndpoint}/$userId");
    if (resp.isNotEmpty) {
      return Users.fromJson(jsonDecode(resp));
    }
    throw Exception("User not found");
  }

  Future<List<Album>> getAlbumsByArtistId(int artistId) async {
    Map<String, String> params = Map();
    params["idArtista"] = artistId.toString();
    final resp = await _restManager.makeGetRequest(AppConstants.ADDRESS_STORE_SERVER, AppConstants.albumsGetByArtista,params) as List;
    List<Album> albums = resp.map((e) => Album.fromJson(e)).toList();
    if (albums.isEmpty) {
      return [];
    }
    return albums;
  }

  getRecensioniByUserId(int? id) {}

  creaRecensione({required int albumId, required int rating, required String comment}) {}




}
