import 'package:album_reviews_app/pages/album_page.dart';
import 'package:album_reviews_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'app.dart';

/*
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


 */

import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Keycloak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AlbumsPage(),
    );
  }
}
