// lib/services/auth_service.dart
// C7: Persistência de dados sensíveis localmente com SharedPreferences

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Chaves privadas — evita erros de digitação em todo o projeto
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyOnboardingDone = 'onboarding_done';

  // -----------------------------------------------------------------------
  // Salva a sessão do usuário após login bem-sucedido
  // Dados sensíveis ficam no dispositivo — não vão para a API (C7)
  // -----------------------------------------------------------------------
  static Future<void> salvarSessao(String email, {String nome = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
    if (nome.isNotEmpty) await prefs.setString(_keyUserName, nome);
  }

  // -----------------------------------------------------------------------
  // Verifica se o usuário já está logado (usado no initial_screen para auto-login)
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
  // Logout — limpa todos os dados de sessão do dispositivo
  // -----------------------------------------------------------------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    // onboarding_done não é removido — usuário não verá o onboarding novamente
  }

  // -----------------------------------------------------------------------
  // Marca o onboarding como visto (evita exibir toda vez que abre o app)
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