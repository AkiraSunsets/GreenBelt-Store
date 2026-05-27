

import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {

   static const String _baseUrl = 'http://192.168.15.170:3000';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };


  // POST /usuarios — Cadastra um novo usuário na API
  // Realizando comunicação POST
  // Retorna o objeto criado com o id gerado pelo servidor

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
        'senha': senha,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erro no cadastro (status ${response.statusCode})');
  }

  // GET /usuarios?email=X — Busca usuário pelo email para simular login
  // C8: Realizando comunicação GET com query param
  // MockAPI suporta filtro por campo: /usuarios?email=teste@email.com

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


  // PUT /usuarios/:id — Atualiza dados do perfil na API
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

