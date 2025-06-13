import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const _kcRegisterUrl =
      'http://localhost:8080/auth/realms/album-realm/protocol/openid-connect/registrations?client_id=album-app';

  Future<void> _openRegistration() async {
    if (await canLaunch(_kcRegisterUrl)) {
      await launch(_kcRegisterUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrazione')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Verrai reindirizzato alla pagina di registrazione Keycloak',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _openRegistration,
                child: const Text('Registrati'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                child: const Text('Ho già un account, esegui il login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
