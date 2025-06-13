import 'album.dart';
import 'artista.dart';

class Users {
  final int? id;
  final String nome;
  final String cognome;
  final String email;
  final List<Album> albumDaAscoltare;
  final List<Album> albumPreferiti;
  final List<Artista> artistiSeguiti;

  Users({
    this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    this.albumDaAscoltare = const [],
    this.albumPreferiti = const [],
    this.artistiSeguiti = const [],
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      nome: json['nome'] ?? '',
      cognome: json['cognome'] ?? '',
      email: json['email'] ?? '',
      albumDaAscoltare: (json['albumDaAscoltare'] as List?)?.map((a) => Album.fromJson(a)).toList() ?? [],
      albumPreferiti: (json['albumPreferiti'] as List?)?.map((a) => Album.fromJson(a)).toList() ?? [],
      artistiSeguiti: (json['artistiSeguiti'] as List?)?.map((a) => Artista.fromJson(a)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cognome': cognome,
      'email': email,
      'albumDaAscoltare': albumDaAscoltare.map((a) => a.toJson()).toList(),
      'albumPreferiti': albumPreferiti.map((a) => a.toJson()).toList(),
      'artistiSeguiti': artistiSeguiti.map((a) => a.toJson()).toList(),
    };
  }

  String get nomeCompleto => '$nome $cognome';
}