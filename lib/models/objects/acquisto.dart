
import 'package:album_reviews_app/models/objects/users.dart';

import 'album.dart';

class Acquisto {
  final int? id;
  final Users buyer;
  final Album album;
  final int quantita;
  final DateTime? dataAcquisto;
  final double prezzoTotale;

  Acquisto({
    this.id,
    required this.buyer,
    required this.album,
    required this.quantita,
    this.dataAcquisto,
    required this.prezzoTotale,
  });

  factory Acquisto.fromJson(Map<String, dynamic> json) {
    return Acquisto(
      id: json['id'],
      buyer: Users.fromJson(json['buyer'] ?? {}),
      album: Album.fromJson(json['album'] ?? {}),
      quantita: json['quantita'] ?? 1,
      dataAcquisto: json['dataAcquisto'] != null ? DateTime.parse(json['dataAcquisto']) : null,
      prezzoTotale: json['prezzoTotale']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer': buyer.toJson(),
      'album': album.toJson(),
      'quantita': quantita,
      'dataAcquisto': dataAcquisto?.toIso8601String(),
      'prezzoTotale': prezzoTotale,
    };
  }
}