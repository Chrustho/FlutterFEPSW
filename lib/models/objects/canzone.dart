class Canzone {
  final int? id;
  final String nome;
  final int durata;
  final int numeroAscolti;

  Canzone({
    this.id,
    required this.nome,
    required this.durata,
    this.numeroAscolti = 0,
  });

  factory Canzone.fromJson(Map<String, dynamic> json) {
    return Canzone(
      id: json['id'],
      nome: json['nome'] ?? '',
      durata: json['durata'] ?? 0,
      numeroAscolti: json['numeroAscolti'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'durata': durata,
      'numeroAscolti': numeroAscolti,
    };
  }

  String get durataFormatted {
    final minuti = durata ~/ 60;
    final secondi = durata % 60;
    return '$minuti:${secondi.toString().padLeft(2, '0')}';
  }
}
