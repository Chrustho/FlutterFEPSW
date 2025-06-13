import 'artista.dart';
import 'genere.dart';

class Solista extends Artista {
  final String strumento;

  Solista({
    super.id,
    required super.nome,
    super.generi,
    required this.strumento,
  });

  factory Solista.fromJson(Map<String, dynamic> json) {
    return Solista(
      id: json['id'],
      nome: json['nome'] ?? '',
      generi: (json['generi'] as List?)?.map((g) => Genere.fromJson(g)).toList() ?? [],
      strumento: json['strumento'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'generi': generi.map((g) => g.toJson()).toList(),
      'strumento': strumento,
      'type': 'solista',
    };
  }
}
