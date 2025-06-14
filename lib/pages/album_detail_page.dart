import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
  late Future<Map<String, dynamic>> _futureAlbum;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _albumId = ModalRoute.of(context)!.settings.arguments as int;
    _futureAlbum = ApiManager().fetchAlbumDetail(_albumId);
  }

  Widget _buildDetailImage(Map<String, dynamic> album) {
    final slug = toSlug(album['title'] as String);
    final jpg = 'assets/images/albums/$slug.jpg';
    final png = 'assets/images/albums/$slug.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        jpg,
        width: double.infinity, height: 200, fit: BoxFit.cover,
        errorBuilder: (_,__,___) => Image.asset(
          png,
          width: double.infinity, height: 200, fit: BoxFit.cover,
          errorBuilder: (_,__,___) => Container(
            width: double.infinity, height: 200,
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureAlbum,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Errore: ${snap.error}'));
          }
          final album = snap.data!;

          // dati per il grafico
          final dist = Map<String, dynamic>.from(album['ratingDistribution']);
          final data = dist.entries
              .map((e) => RatingCount(int.parse(e.key), e.value as int))
              .toList();

          final series = [
            charts.Series<RatingCount, String>(
              id: 'Ratings',
              domainFn: (rc, _) => rc.rating.toString(),
              measureFn: (rc, _) => rc.count,
              data: data,
            )
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailImage(album),
                const SizedBox(height: 16),
                Text(album['title'],
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Artista: ${album['artistName']}'),
                const SizedBox(height: 16),
                // grafico
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 200,
                      child: charts.BarChart(series, animate: true),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Tracce:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List<Widget>.from(
                  (album['tracks'] as List<dynamic>).map(
                        (t) => ListTile(
                      title: Text(t['title']),
                      subtitle: Text('${t['duration']}'),
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

class RatingCount {
  final int rating;
  final int count;
  RatingCount(this.rating, this.count);
}
