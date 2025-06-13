import 'package:flutter/material.dart';
import '../services/auth_service.dart';
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
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService().isLoggedIn();
    final nextRoute = loggedIn ? Routes.albums : Routes.login;
    // Sostituisce la splash con la rotta corretta
    Navigator.pushReplacementNamed(context, nextRoute);
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
