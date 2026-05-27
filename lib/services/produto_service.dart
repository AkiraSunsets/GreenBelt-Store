// lib/services/produto_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  // Endereço do seu JSON Server
  static const String _baseUrl = 'http://192.168.15.170:3000';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // -----------------------------------------------------------------------
  // GET /produtos — Tenta buscar da API, se falhar, usa o Mock
  // -----------------------------------------------------------------------
  static Future<List<Produto>> getProdutos() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/produtos'));

      if (response.statusCode == 200) {
        // Uso utf8.decode para garantir que acentos funcionem bem
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Produto.fromJson(json)).toList();
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro ao conectar na API ($e). Usando dados locais.");
      return getProdutosMock();
    }
  }

  // Método auxiliar para ler o JSON local (seu plano B)
  static Future<List<Produto>> getProdutosMock() async {
    final String response = await rootBundle.loadString('assets/data/produtos.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Produto.fromJson(json)).toList();
  }

  // -----------------------------------------------------------------------
  // GET /produtos/:id — Busca um único produto pelo ID
  // -----------------------------------------------------------------------
  static Future<Produto> getProdutoPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/produtos/$id'));

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Produto não encontrado (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // POST /produtos — Cria um novo produto
  // -----------------------------------------------------------------------
  static Future<Produto> criarProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/produtos'),
      headers: _headers,
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 201) {
      return Produto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Erro ao criar produto (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // PUT /produtos/:id — Atualiza um produto existente
  // -----------------------------------------------------------------------
  static Future<Produto> atualizarProduto(String id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/produtos/$id'),
      headers: _headers,
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Erro ao atualizar produto (status ${response.statusCode})');
  }

  // -----------------------------------------------------------------------
  // DELETE /produtos/:id — Remove um produto
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