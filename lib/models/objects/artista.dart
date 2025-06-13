
import 'package:album_reviews_app/models/objects/solista.dart';

import 'band.dart';
import 'genere.dart';

abstract class Artista {
  final int? id;
  final String nome;
  final List<Genere> generi;

  Artista({
    this.id,
    required this.nome,
    this.generi = const [],
  });

  factory Artista.fromJson(Map<String, dynamic> json) {
    final type = json['type'] ?? (json['strumento'] != null ? 'solista' : 'band');

    if (type == 'solista' || json['strumento'] != null) {
      return Solista.fromJson(json);
    } else {
      return Band.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
