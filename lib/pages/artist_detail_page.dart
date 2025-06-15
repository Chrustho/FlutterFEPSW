import 'package:album_reviews_app/models/Model.dart';
import 'package:album_reviews_app/models/objects/album.dart';
import 'package:album_reviews_app/models/objects/artista.dart';
import 'package:flutter/material.dart';
import '../models/objects/band.dart';
import '../models/objects/solista.dart';
import '../utils/slug.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';
import '../routes.dart';

class ArtistDetailPage extends StatefulWidget {
  const ArtistDetailPage({Key? key}) : super(key: key);

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  late final int _artistId;
  late Future<Artista?> _futureArtist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artistId = ModalRoute.of(context)!.settings.arguments as int;
    _futureArtist = Model().fetchArtistDetail(_artistId);
  }

  Widget _buildDetailAvatar(Artista artist) {
    final slug = toSlug(artist.nome);
    final path = 'assets/images/artists/$slug.jpg';
    return Center(
      child: CircleAvatar(
        radius: 64,
        backgroundImage: AssetImage(path),
        onBackgroundImageError: (_, __) {},
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: Routes.artists,
      body: FutureBuilder<Artista?>(
        future: _futureArtist,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Errore: ${snap.error}'));
          }
          final artist = snap.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailAvatar(artist),
                const SizedBox(height: 16),
                Text(artist.nome, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Genere: ${artist.generi}'),
                if (artist is Solista) ...[
                  Text('Strumento: ${artist.strumento}'),
                ] else if (artist is Band) ...[
                  Text('Componenti: ${artist.membri.join(', ')}'),
                ],
                const SizedBox(height: 16),
                Text('Album pubblicati:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                FutureBuilder<List<Album>>(
                  future: Model().getAlbumsByArtistId(artist.id!),
                  builder: (ctx, snapAlbums) {
                    if (snapAlbums.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapAlbums.hasError) {
                      return Center(child: Text('Errore: ${snapAlbums.error}'));
                    }
                    final albums = snapAlbums.data!;
                    if (albums.isEmpty) {
                      return const Center(child: Text('Nessun album trovato per questo artista.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: albums.length,
                      itemBuilder: (ctx, index) {
                        final album = albums[index];
                        return ListTile(
                          title: Text(album.nome),
                          subtitle: Text('Anno: ${album.annoRilascio}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.albumDetail,
                              arguments: album.id,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
