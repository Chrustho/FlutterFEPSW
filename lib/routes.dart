import 'package:album_reviews_app/pages/album_detail_page.dart';
import 'package:album_reviews_app/pages/album_page.dart';
import 'package:album_reviews_app/pages/artist_detail_page.dart';
import 'package:album_reviews_app/pages/artist_page.dart';
import 'package:flutter/material.dart';
import 'pages/splash_page.dart';       // <-- import
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/review_create_page.dart';
import 'pages/profile_page.dart';

class Routes {
  static const String splash     = '/';
  static const String login      = '/login';
  static const String register   = '/register';
  static const String albums     = '/albums';
  static const String artists    = '/artists';
  static const String newReview  = '/reviews/new';
  static const String profile    = '/profile';
  static const String artistDetail = '/artists/detail';
  static const String albumDetail  = '/albums/detail';


  static Map<String, WidgetBuilder> get all {
    return {
      splash:    (ctx) => const SplashPage(),      // <-- splash entry
      login:     (ctx) => const LoginPage(),
      register:  (ctx) => const RegisterPage(),
      albums:    (ctx) => const AlbumsPage(),
      artists:   (ctx) => const ArtistsPage(),
      newReview: (ctx) => const ReviewCreatePage(),
      profile:   (ctx) => const ProfilePage(),
      artistDetail: (ctx) => const ArtistDetailPage(),
      albumDetail:  (ctx) => const AlbumDetailPage(),
    };
  }
}
