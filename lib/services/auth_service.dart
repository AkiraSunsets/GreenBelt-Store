// lib/services/auth_service.dart
// Persistência de dados sensíveis localmente com SharedPreferences

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyUsersDb = 'users_db'; // banco local de usuários cadastrados

  // -----------------------------------------------------------------------
  // Hash simples da senha (SHA-256) — nunca armazene senha em texto puro
  // -----------------------------------------------------------------------
  static String _hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    return sha256.convert(bytes).toString();
  }

  // -----------------------------------------------------------------------
  // Recupera o mapa de usuários cadastrados { email: { name, passwordHash } }
  // -----------------------------------------------------------------------
  static Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUsersDb);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsersDb, jsonEncode(users));
  }

  // -----------------------------------------------------------------------
  // Cadastro — retorna null se OK, ou mensagem de erro
  // -----------------------------------------------------------------------
  static Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (nome.trim().isEmpty) return 'O nome não pode ser vazio.';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Informe um e-mail válido.';
    }
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';

    final users = await _getUsers();
    final key = email.trim().toLowerCase();

    if (users.containsKey(key)) {
      return 'Este e-mail já está cadastrado. Faça login.';
    }

    users[key] = {
      'name': nome.trim(),
      'passwordHash': _hashSenha(senha),
    };
    await _saveUsers(users);
    return null; // sucesso
  }

  // -----------------------------------------------------------------------
  // Login — retorna null se OK, ou mensagem de erro
  // -----------------------------------------------------------------------
  static Future<String?> login({
    required String email,
    required String senha,
  }) async {
    if (email.trim().isEmpty || senha.isEmpty) {
      return 'Preencha e-mail e senha.';
    }

    final users = await _getUsers();
    final key = email.trim().toLowerCase();

    if (!users.containsKey(key)) {
      return 'E-mail não cadastrado. Crie uma conta primeiro.';
    }

    final userData = users[key] as Map<String, dynamic>;
    if (userData['passwordHash'] != _hashSenha(senha)) {
      return 'Senha incorreta.';
    }

    // Salva sessão
    await salvarSessao(email.trim().toLowerCase(),
        nome: userData['name'] as String);
    return null; // sucesso
  }

  // -----------------------------------------------------------------------
  // Salva a sessão do usuário após login/cadastro bem-sucedido
  // -----------------------------------------------------------------------
  static Future<void> salvarSessao(String email, {String nome = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
    if (nome.isNotEmpty) await prefs.setString(_keyUserName, nome);
  }

  // -----------------------------------------------------------------------
  // Verifica se o usuário já está logado
  // -----------------------------------------------------------------------
  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // -----------------------------------------------------------------------
  // Recupera o email salvo localmente
  // -----------------------------------------------------------------------
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? '';
  }

  // -----------------------------------------------------------------------
  // Recupera o nome salvo localmente
  // -----------------------------------------------------------------------
  static Future<String> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Usuário';
  }

  // -----------------------------------------------------------------------
  // Atualiza o nome do usuário logado (usado em EditProfileScreen)
  // -----------------------------------------------------------------------
  static Future<void> atualizarNome(String novoNome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, novoNome);

    // Atualiza também no banco de usuários
    final email = await getEmail();
    final users = await _getUsers();
    if (users.containsKey(email)) {
      (users[email] as Map<String, dynamic>)['name'] = novoNome;
      await _saveUsers(users);
    }
  }

  // -----------------------------------------------------------------------
  // Logout — limpa todos os dados de sessão
  // -----------------------------------------------------------------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
  }

  // -----------------------------------------------------------------------
  // Onboarding
  // -----------------------------------------------------------------------
  static Future<void> marcarOnboardingFeito() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, true);
  }

  static Future<bool> onboardingJaFeito() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }
}