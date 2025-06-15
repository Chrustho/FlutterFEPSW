import 'package:flutter/material.dart';
import '../routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goToAlbumsPage();
  }

  /// Navigates directly to the albums page after a brief delay
  Future<void> _goToAlbumsPage() async {
    // Optional: keep the splash visible for at least 1 second
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, Routes.albums);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Qui potresti inserire il logo o un'animazione personalizzata
        child: CircularProgressIndicator(),
      ),
    );
  }
}
