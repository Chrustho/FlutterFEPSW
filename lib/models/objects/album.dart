import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'artista.dart';
import 'canzone.dart';
import 'genere.dart';

class Album {
  final int? id;
  final String nome;
  final int? annoRilascio;
  final Artista artista;
  final List<Canzone> canzoni;
  final List<Genere> generi;
  final double? prezzo;
  final int? quantity;

  Album({
    this.id,
    required this.nome,
    this.annoRilascio,
    required this.artista,
    this.canzoni = const [],
    this.generi = const [],
    this.prezzo,
    this.quantity,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      nome: json['nome'] ?? '',
      annoRilascio: json['annoRilascio'],
      artista: Artista.fromJson(json['artista'] ?? {}),
      canzoni: (json['canzoni'] as List?)?.map((c) => Canzone.fromJson(c)).toList() ?? [],
      generi: (json['generi'] as List?)?.map((g) => Genere.fromJson(g)).toList() ?? [],
      prezzo: json['prezzo']?.toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'annoRilascio': annoRilascio,
      'artista': artista.toJson(),
      'canzoni': canzoni.map((c) => c.toJson()).toList(),
      'generi': generi.map((g) => g.toJson()).toList(),
      'prezzo': prezzo,
      'quantity': quantity,
    };
  }

  // Genera URL copertina basato su nome album e artista
  String get coverUrl {
    final artistName = artista.nome.replaceAll(' ', '%20');
    final albumName = nome.replaceAll(' ', '%20');
    return 'https://api.deezer.com/search/album?q=artist:"$artistName"%20album:"$albumName"&limit=1';
  }

  // URL placeholder per copertina
  String get placeholderCover {
    return 'https://via.placeholder.com/300x300/6366f1/ffffff?text=${nome.substring(0, 1)}';
  }

  String? get imageUrl => null;

  getRating(String nome) {

  }

  static Widget fromJsonList(String response) {
    if (response.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<dynamic> jsonList = json.decode(response);
    final List<Album> albums =
        jsonList.map((json) => Album.fromJson(json)).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            title: Text(album.nome),
            subtitle: Text(album.artista.nome),
            trailing:
                album.annoRilascio != null
                    ? Text(album.annoRilascio.toString())
                    : null,
          ),
        );
      },
    );
  }
}