// lib/services/usuario_service.dart
// C8: POST de cadastro e GET de login via API RESTful

import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {
  // ⚠️  Use a MESMA base URL do produto_service.dart
  static const String _baseUrl = 'https://SEU_MOCKAPI.mockapi.io/api/v1';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // -----------------------------------------------------------------------
  // POST /usuarios — Cadastra um novo usuário na API
  // C8: Realizando comunicação POST
  // Retorna o objeto criado com o id gerado pelo servidor
  // -----------------------------------------------------------------------
  static Future<Map<String, dynamic>> registrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: _headers,
      body: jsonEncode({
        'nome': nome,
        'email': email,
        // ⚠️  Nunca envie senha em texto puro para uma API real.
        // Em produção use hashing (bcrypt) no backend ou Firebase Auth.
        // Para este projeto de demonstração, enviamos apenas para fins didáticos.
        'senha': senha,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erro no cadastro (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // GET /usuarios?email=X — Busca usuário pelo email para simular login
  // C8: Realizando comunicação GET com query param
  // MockAPI suporta filtro por campo: /usuarios?email=teste@email.com
  // -----------------------------------------------------------------------
  static Future<Map<String, dynamic>?> buscarPorEmail(String email) async {
    final uri = Uri.parse('$_baseUrl/usuarios').replace(
      queryParameters: {'email': email},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      if (lista.isNotEmpty) {
        return lista.first as Map<String, dynamic>;
      }
      return null; // email não encontrado
    }

    throw Exception('Erro ao buscar usuário (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // PUT /usuarios/:id — Atualiza dados do perfil na API
  // C8: Realizando comunicação PUT
  // -----------------------------------------------------------------------
  static Future<Map<String, dynamic>> atualizarPerfil({
    required String id,
    required String nome,
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: _headers,
      body: jsonEncode({
        'nome': nome,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erro ao atualizar perfil (status ${response.statusCode})');
  }
}