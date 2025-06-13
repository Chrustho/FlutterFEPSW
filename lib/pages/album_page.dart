import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final ApiManager _api = ApiManager();
  List<dynamic> _allAlbums = [];
  List<dynamic> _filteredAlbums = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    final list = await _api.fetchAlbums();
    setState(() {
      _allAlbums = list;
      _filteredAlbums = list;
      _loading = false;
    });
  }

  void _onSearchChanged(String q) {
    setState(() {
      _query = q;
      _filteredAlbums = _allAlbums
          .where((a) => a['title'].toString().toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: '/albums',
      body: Column(
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cerca album...',
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAlbums.isEmpty
                ? const Center(child: Text('Nessun album trovato.'))
                : ListView.builder(
              itemCount: _filteredAlbums.length,
              itemBuilder: (ctx, i) {
                final alb = _filteredAlbums[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(alb['title']),
                    subtitle: Text('${alb['artistName']}'),
                    onTap: () {
                      // dettaglio album...
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
