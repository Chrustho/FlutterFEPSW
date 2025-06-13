import 'package:flutter/material.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAlbums;
  final VoidCallback onArtists;
  final VoidCallback onCreateReview;
  final VoidCallback onProfile;

  const SiteAppBar({
    Key? key,
    required this.onAlbums,
    required this.onArtists,
    required this.onCreateReview,
    required this.onProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Logo
          Image.asset(
            'assets/logo.png',
            height: 32,
          ),
          const SizedBox(width: 8),
          const Text('Album Reviews'),
          const Spacer(),
          // Bottoni di navigazione
          TextButton(
            onPressed: onAlbums,
            child: const Text('Album', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: onArtists,
            child: const Text('Artisti', style: TextStyle(color: Colors.white)),
          ),
          // Pulsante + per nuova recensione
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuova recensione',
            onPressed: onCreateReview,
          ),
          // Icona profilo
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profilo',
            onPressed: onProfile,
          ),
        ],
      ),
      backgroundColor: Colors.teal, // tonalità Material piacevole
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
