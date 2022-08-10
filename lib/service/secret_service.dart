import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:netflix_gallery/domain/credentials.dart';

class SecretService {
  final String _usernameKey = "username";
  final String _passwordKey = "password";

  final storage = const FlutterSecureStorage();

  Future storeCredentials(Credentials cred) async {
    await storage.write(key: _usernameKey, value: cred.username);
    await storage.write(key: _passwordKey, value: cred.password);
  }

  Future<Credentials?> receiveCredentials() async {
    String? username = await storage.read(key: _usernameKey);
    String? password = await storage.read(key: _passwordKey);

    if (username == null || password == null) {
      return null;
    }

    return Credentials(username, password);
  }
}
