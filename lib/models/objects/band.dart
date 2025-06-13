import 'package:album_reviews_app/models/objects/solista.dart';

import 'artista.dart';
import 'genere.dart';

class Band extends Artista {
  final List<Solista> membri;

  Band({
    super.id,
    required super.nome,
    super.generi,
    this.membri = const [],
  });

  factory Band.fromJson(Map<String, dynamic> json) {
    return Band(
      id: json['id'],
      nome: json['nome'] ?? '',
      generi: (json['generi'] as List?)?.map((g) => Genere.fromJson(g)).toList() ?? [],
      membri: (json['membri'] as List?)?.map((m) => Solista.fromJson(m)).toList() ?? [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'generi': generi.map((g) => g.toJson()).toList(),
      'membri': membri.map((m) => m.toJson()).toList(),
      'type': 'band',
    };
  }
}