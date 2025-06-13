import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({Key? key}) : super(key: key);

  @override
  _ArtistsPageState createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  final ApiManager _api = ApiManager();
  List<dynamic> _allArtists = [];
  List<dynamic> _filteredArtists = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    final list = await _api.fetchArtists();
    setState(() {
      _allArtists = list;
      _filteredArtists = list;
      _loading = false;
    });
  }

  void _onSearchChanged(String q) {
    setState(() {
      _query = q;
      _filteredArtists = _allArtists
          .where((a) => a['name'].toString().toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: '/artists',
      body: Column(
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cerca artisti...',
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredArtists.isEmpty
                ? const Center(child: Text('Nessun artista trovato.'))
                : ListView.builder(
              itemCount: _filteredArtists.length,
              itemBuilder: (ctx, i) {
                final art = _filteredArtists[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(art['name']),
                    subtitle: Text('${art['genre']}'),
                    onTap: () {
                      // dettaglio artista...
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
