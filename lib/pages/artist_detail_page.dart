import 'package:flutter/material.dart';
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
  late Future<Map<String, dynamic>> _futureArtist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _artistId = ModalRoute.of(context)!.settings.arguments as int;
    _futureArtist = ApiManager().fetchArtistDetail(_artistId);
  }

  Widget _buildDetailAvatar(Map<String, dynamic> artist) {
    final slug = toSlug(artist['name'] as String);
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
      body: FutureBuilder<Map<String, dynamic>>(
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
                Text(artist['name'], style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                if (artist.containsKey('genre'))
                  Text('Genere: ${artist['genre']}'),
                const SizedBox(height: 16),
                if (artist.containsKey('bio')) ...[
                  Text('Biografia:', style: Theme.of(context).textTheme.titleMedium),
                  Text(artist['bio'] ?? 'Nessuna descrizione disponibile.'),
                  const SizedBox(height: 16),
                ],
                Text('Album pubblicati:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List<Widget>.from(
                  (artist['albums'] as List<dynamic>).map(
                        (alb) => ListTile(
                      title: Text(alb['title']),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.albumDetail,
                          arguments: alb['id'],
                        );
                      },
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
