import 'package:album_reviews_app/models/Model.dart';
import 'package:album_reviews_app/models/managers/RestManager.dart';
import 'package:album_reviews_app/models/objects/album.dart';
import 'package:album_reviews_app/models/objects/canzone.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';
import '../routes.dart';
import '../utils/slug.dart';

class AlbumDetailPage extends StatefulWidget {
  const AlbumDetailPage({Key? key}) : super(key: key);
  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late final int _albumId;
  late Future<Album?> _futureAlbum;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _albumId = ModalRoute.of(context)!.settings.arguments as int;
    _futureAlbum = Model().fetchAlbumDetail(_albumId);
  }

  Widget _buildDetailImage(Album album) {
    final slug = toSlug(album.nome);
    final jpg = 'assets/images/albums/$slug.jpg';
    final png = 'assets/images/albums/$slug.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        jpg,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          png,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 48),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: Routes.albums,
      body: FutureBuilder<Album?>(
        future: _futureAlbum,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Errore: ${snap.error}'));
          }
          final album = snap.data!;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailImage(album),
                const SizedBox(height: 16),
                Text(album.nome,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Artista: ${album.artista}'),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                Text('Tracce:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List<Widget>.from(
                  (album.canzoni).map(
                        (t) => ListTile(
                      title: Text(t.nome),
                      subtitle: Text('${t.durata}'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
