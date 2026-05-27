import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyUsersDb = 'users_db'; 

  static String _hashSenha(String senha) {
    return sha256.convert(utf8.encode(senha)).toString();
  }

  static Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUsersDb);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  static Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsersDb, jsonEncode(users));
  }

  static Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (nome.trim().isEmpty) return 'O nome não pode ser vazio.';
    if (!email.contains('@') || !email.contains('.')) return 'Informe um e-mail válido.';
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';

    final users = await _getUsers();
    final key = email.trim().toLowerCase();

    if (users.containsKey(key)) return 'Este e-mail já está cadastrado.';

    users[key] = {
      'name': nome.trim(),
      'passwordHash': _hashSenha(senha),
    };
    await _saveUsers(users);
    return null;
  }

  static Future<String?> login({required String email, required String senha}) async {
    final users = await _getUsers();
    final key = email.trim().toLowerCase();

    if (!users.containsKey(key)) return 'E-mail não encontrado.';

    final userData = users[key] as Map<String, dynamic>;
    if (userData['passwordHash'] != _hashSenha(senha)) return 'Senha incorreta.';

    await salvarSessao(key, nome: userData['name'] as String);
    return null;
  }

  static Future<void> salvarSessao(String email, {String nome = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, nome);
  }

  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? '';
  }

  static Future<String> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Usuário';
  }

  static Future<void> atualizarNome(String novoNome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, novoNome);

    final email = await getEmail();
    final users = await _getUsers();
    if (users.containsKey(email)) {
      final user = users[email] as Map<String, dynamic>;
      user['name'] = novoNome;
      await _saveUsers(users);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false); //definido como falso pq n há login
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
  }

  static Future<void> marcarOnboardingFeito() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, true);
  }

  static Future<bool> onboardingJaFeito() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }
}