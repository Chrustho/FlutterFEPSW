import 'package:flutter/material.dart';
import 'site_app_bar.dart';

class SiteScaffold extends StatelessWidget {
  final Widget body;
  final String currentRouteName;

  const SiteScaffold({
    Key? key,
    required this.body,
    required this.currentRouteName,
  }) : super(key: key);

  void _navigate(BuildContext context, String routeName) {
    if (routeName != currentRouteName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SiteAppBar(
        onAlbums:     () => _navigate(context, '/albums'),
        onArtists:    () => _navigate(context, '/artists'),
        onCreateReview: () => _navigate(context, '/reviews/new'),
        onProfile:    () => _navigate(context, '/profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}
