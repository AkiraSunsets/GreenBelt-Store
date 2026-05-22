// lib/services/produto_service.dart
// C8: Integração com serviço web RESTful — GET, POST, PUT, DELETE

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  // ⚠️  Substitua pela URL real do seu MockAPI ou backend
  // Exemplo MockAPI: https://XXXXXXXX.mockapi.io/api/v1
  static const String _baseUrl = 'https://SEU_MOCKAPI.mockapi.io/api/v1';

  // Headers padrão para todas as requisições com corpo JSON
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // -----------------------------------------------------------------------
  // GET /produtos — Busca a lista completa de produtos da API
  // C8: Realizando comunicação GET
  // -----------------------------------------------------------------------
  static Future<List<Produto>> getProdutos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/produtos'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // C11: usa o factory Produto.fromJson() para criar os objetos corretos
      return data.map((json) => Produto.fromJson(json)).toList();
    }

    // Fallback: retorna a lista mock se a API falhar
    // Remova este fallback quando a API estiver configurada
    return mockProdutos;
  }

  // -----------------------------------------------------------------------
  // GET /produtos/:id — Busca um único produto pelo ID
  // C8: Realizando comunicação GET
  // -----------------------------------------------------------------------
  static Future<Produto> getProdutoPorId(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/produtos/$id'),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    }

    throw Exception('Produto não encontrado (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // POST /produtos — Cria um novo produto na API
  // C8: Realizando comunicação POST
  // -----------------------------------------------------------------------
  static Future<Produto> criarProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/produtos'),
      headers: _headers,
      // C11: usa o método toJson() da classe Produto para serializar
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 201) {
      return Produto.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao criar produto (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // PUT /produtos/:id — Atualiza um produto existente na API
  // C8: Realizando comunicação PUT
  // -----------------------------------------------------------------------
  static Future<Produto> atualizarProduto(String id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/produtos/$id'),
      headers: _headers,
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao atualizar produto (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // DELETE /produtos/:id — Remove um produto da API
  // C8: Realizando comunicação DELETE
  // -----------------------------------------------------------------------
  static Future<void> deletarProduto(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/produtos/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar produto (status ${response.statusCode})');
    }
  }
}