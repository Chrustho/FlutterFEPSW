import 'package:album_reviews_app/models/Model.dart';
import 'package:album_reviews_app/models/objects/recensione_album.dart';
import 'package:album_reviews_app/models/objects/users.dart';
import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';
import '../services/auth_service.dart';
import '../routes.dart';  // <-- importiamo il Routes

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> _handleLogout(BuildContext ctx) async {
    // 1) Revoca token e logout Keycloak
    await AuthService().logout();
    // 2) Ripulisci la stack di navigazione e torna al login
    Navigator.pushNamedAndRemoveUntil(
      ctx,
      Routes.login,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: Routes.profile,
      body: FutureBuilder<Users>(
        future: Model().getUserById(0),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Errore: ${snap.error}'));
          }
          final user = snap.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.nome} ${user.cognome}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text('Le tue ultime recensioni:'),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<RecensioneAlbum>>(
                  future: Model().getRecensioniByUserId(user.id),
                  builder: (ctx2, snap2) {
                    if (snap2.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap2.hasError) {
                      return Text('Errore: ${snap2.error}');
                    }
                    final reviews = snap2.data!;
                    if (reviews.isEmpty) {
                      return const Text('Ancora nessuna recensione.');
                    }
                    return ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (ctx3, i) {
                        final r = reviews[i];
                        return ListTile(
                          title: Text(r.album!.nome),
                          subtitle: Text('${r.voto} ★ – ${r.testo}'),
                        );
                      },
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  child: const Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
