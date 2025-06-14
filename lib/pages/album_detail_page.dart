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

  /// Costruisce i dati per fl_chart
  List<BarChartGroupData> _makeBarGroups(Map<String, dynamic> dist) {
    // dist: { "1": count1, "2": count2, ... "5": count5 }
    final entries = dist.entries.toList()
      ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
    return entries.map((e) {
      final rating = int.parse(e.key);
      final count = (e.value as int).toDouble();
      return BarChartGroupData(
        x: rating,
        barRods: [
          BarChartRodData(toY: count, width: 16),
        ],
      );
    }).toList();
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

          // Prepara i dati per il BarChart
          final dist = Map<String, dynamic>.from(album['ratingDistribution']);
          final barGroups = _makeBarGroups(dist);

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

                // ─── fl_chart BarChart ───
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: barGroups
                              .map((g) => g.barRods.first.toY)
                              .reduce((a, b) => a > b ? a : b) +
                              5, // un margine sopra
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) => Text(
                                  value.toInt().toString(),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: barGroups,
                        ),
                      ),
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
