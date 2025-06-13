class Genere {
  final int? id;
  final String nome;

  Genere({
    this.id,
    required this.nome,
  });

  factory Genere.fromJson(Map<String, dynamic> json) {
    return Genere(
      id: json['id'],
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}