import 'package:album_reviews_app/models/Model.dart';
import 'package:flutter/material.dart';
import '../models/objects/album.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';
import '../routes.dart';
import '../utils/slug.dart';

enum AlbumFilter { topRated, recent, mostPlayed }

extension _AlbumFilterExt on AlbumFilter {
  String get apiValue {
    switch (this) {
      case AlbumFilter.topRated:   return 'topRated';
      case AlbumFilter.recent:     return 'recent';
      case AlbumFilter.mostPlayed: return 'mostPlayed';
    }
  }
  String get label {
    switch (this) {
      case AlbumFilter.topRated:   return 'I più votati';
      case AlbumFilter.recent:     return 'I più recenti';
      case AlbumFilter.mostPlayed: return 'I più ascoltati';
    }
  }
}

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key}) : super(key: key);
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final Model _api = Model();
  final ScrollController _scrollCtrl = ScrollController();

  AlbumFilter _filter = AlbumFilter.topRated;
  String _search = '';

  List<Album> _albums = [];
  bool _loadingPage = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _resetAndLoad();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >
        _scrollCtrl.position.maxScrollExtent - 200 &&
        !_loadingPage &&
        _hasMore) {
      _loadNextPage();
    }
  }

  void _resetAndLoad() {
    _albums.clear();
    _hasMore = true;
    _currentPage = 0;
    _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    setState(() => _loadingPage = true);
    try {
      Map<String, String> params = {
        'pageNumber': _currentPage.toString(),
        'pageSize': _pageSize.toString(),
        'sortBy': "id",
      };
      final pageData = await _api.getAllAlbums(params);
      setState(() {
        _albums.addAll(pageData);
        _currentPage++;
        if (pageData.length < _pageSize) _hasMore = false;
      });
    } catch (e) {
      // opzionale: mostra SnackBar
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _loadingPage = false);
  }

  void _onFilterSelected(AlbumFilter f) {
    if (f == _filter) return;
    setState(() => _filter = f);
    _resetAndLoad();
  }

  void _onSearchChanged(String q) {
    _search = q;
    _resetAndLoad();
  }

  Widget _buildFilterButton(AlbumFilter f) {
    final selected = f == _filter;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.teal.shade100 : null,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => _onFilterSelected(f),
      child: Text(f.label),
    );
  }

  Widget _buildAlbumImage(Album a) {
    final slug = toSlug(a.nome);
    final jpg = 'assets/images/albums/$slug.jpg';
    final png = 'assets/images/albums/$slug.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        jpg,
        width: 56, height: 56, fit: BoxFit.cover,
        errorBuilder: (_,__,___) => Image.asset(
          png, width: 56, height: 56, fit: BoxFit.cover,
          errorBuilder: (_,__,___) => const Icon(Icons.broken_image, size: 56),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: "/albums",
      body: Row(
        children: [
          // ─── Sidebar filtri ───
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Filtri',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                for (var f in AlbumFilter.values) _buildFilterButton(f),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // ─── Right: search + infinite list ───
          Expanded(
            child: Column(
              children: [
                // search
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cerca album...',
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(height: 4),
                // lista
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    itemCount: _albums.length + (_hasMore ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i >= _albums.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final a = _albums[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: _buildAlbumImage(a),
                          title: Text(a.nome),
                          subtitle: Text(a.artista.nome),
                          onTap: () => Navigator.of(context, rootNavigator: true)
                              .pushNamed(Routes.albumDetail, arguments: a.id)
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
