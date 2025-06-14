import 'package:flutter/material.dart';
import '../utils/slug.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';
import '../routes.dart';

enum ArtistFilter { mostPopular, recent, mostAlbums }

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({Key? key}) : super(key: key);

  @override
  _ArtistsPageState createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  final ApiManager _api = ApiManager();
  ArtistFilter _filter = ArtistFilter.mostPopular;
  late Future<List<dynamic>> _futureArtists;

  @override
  void initState() {
    super.initState();
    _loadByFilter();
  }

  void _loadByFilter() {
    switch (_filter) {
      case ArtistFilter.mostPopular:
        _futureArtists = _api.fetchArtistsMostPopular();
        break;
      case ArtistFilter.recent:
        _futureArtists = _api.fetchArtistsRecent();
        break;
      case ArtistFilter.mostAlbums:
        _futureArtists = _api.fetchArtistsMostAlbums();
        break;
    }
    setState(() {});
  }

  void _selectFilter(ArtistFilter f) {
    if (f == _filter) return;
    _filter = f;
    _loadByFilter();
  }

  Widget _buildFilterButton(String label, ArtistFilter f) {
    final selected = _filter == f;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.teal.shade100 : null,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => _selectFilter(f),
      child: Text(label),
    );
  }

  Widget _buildArtistImage(Map<String, dynamic> a) {
    final slug = toSlug(a['name'] as String);
    final path = 'assets/images/artists/$slug.jpg';
    return CircleAvatar(
      radius: 28,
      backgroundImage: AssetImage(path),
      onBackgroundImageError: (_, __) {},
      backgroundColor: Colors.grey.shade200,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: Routes.artists,
      body: Row(
        children: [
          // Sidebar filtri
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Filtri',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                _buildFilterButton('Più popolari', ArtistFilter.mostPopular),
                _buildFilterButton('Più recenti', ArtistFilter.recent),
                _buildFilterButton('Più album', ArtistFilter.mostAlbums),
              ],
            ),
          ),

          const VerticalDivider(width: 1),

          // Lista filtrata
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureArtists,
              builder: (ctx, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Errore: ${snap.error}'));
                }
                final artists = snap.data!;
                if (artists.isEmpty) {
                  return const Center(child: Text('Nessun artista trovato.'));
                }
                return ListView.builder(
                  itemCount: artists.length,
                  itemBuilder: (ctx, i) {
                    final a = artists[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: _buildArtistImage(a),
                        title: Text(a['name']),
                        subtitle: Text(a['genre'] ?? ''),
                        onTap: () => Navigator.pushNamed(
                          context, Routes.artistDetail,
                          arguments: a['id'],
                        ),
                      ),
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
