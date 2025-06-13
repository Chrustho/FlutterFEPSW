import 'package:album_reviews_app/models/objects/users.dart';

import 'album.dart';

class RecensioneAlbum {
  final int? id;
  final Users? user;
  final Album? album;
  final DateTime? dataRecensione;
  final double voto;
  final String testo;

  RecensioneAlbum({
    this.id,
    this.user,
    this.album,
    this.dataRecensione,
    required this.voto,
    required this.testo,
  });

  factory RecensioneAlbum.fromJson(Map<String, dynamic> json) {
    return RecensioneAlbum(
      id: json['id'],
      user: json['user'] != null ? Users.fromJson(json['user']) : null,
      album: json['album'] != null ? Album.fromJson(json['album']) : null,
      dataRecensione: json['dataRecensione'] != null ? DateTime.parse(json['dataRecensione']) : null,
      voto: json['voto']?.toDouble() ?? 0.0,
      testo: json['testo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'album': album?.toJson(),
      'dataRecensione': dataRecensione?.toIso8601String(),
      'voto': voto,
      'testo': testo,
    };
  }
}