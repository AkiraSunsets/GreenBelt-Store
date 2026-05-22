// lib/services/database_service.dart
// C7: Persistência de dados no banco de dados interno (SQLite)

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // -----------------------------------------------------------------------
  // Singleton — garante uma única instância do banco em todo o app
  // -----------------------------------------------------------------------
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'greenbelt.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // C7: Criação da tabela de pedidos no armazenamento interno
        await db.execute('''
          CREATE TABLE pedidos (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            data      TEXT    NOT NULL,
            total     REAL    NOT NULL,
            frete     TEXT    NOT NULL,
            itensJson TEXT    NOT NULL
          )
        ''');
      },
    );
  }

  // -----------------------------------------------------------------------
  // INSERT — salva o pedido finalizado localmente
  // Chamado em checkout_screen.dart ao confirmar o pagamento
  // -----------------------------------------------------------------------
  static Future<int> salvarPedido({
    required double total,
    required String frete,
    required List<Map<String, dynamic>> itens,
  }) async {
    final db = await database;
    return db.insert('pedidos', {
      'data': DateTime.now().toIso8601String(),
      'total': total,
      'frete': frete,
      'itensJson': jsonEncode(itens), // lista de itens serializada como texto
    });
  }

  // -----------------------------------------------------------------------
  // SELECT ALL — retorna todos os pedidos do histórico
  // Usado na tela "My Orders" do perfil
  // -----------------------------------------------------------------------
  static Future<List<Map<String, dynamic>>> buscarPedidos() async {
    final db = await database;
    return db.query('pedidos', orderBy: 'data DESC');
  }

  // -----------------------------------------------------------------------
  // SELECT ONE — retorna um pedido específico pelo id
  // -----------------------------------------------------------------------
  static Future<Map<String, dynamic>?> buscarPedidoPorId(int id) async {
    final db = await database;
    final result = await db.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // -----------------------------------------------------------------------
  // DELETE — remove um pedido do histórico local
  // -----------------------------------------------------------------------
  static Future<void> deletarPedido(int id) async {
    final db = await database;
    await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  // -----------------------------------------------------------------------
  // DELETE ALL — limpa todo o histórico (útil ao fazer logout)
  // -----------------------------------------------------------------------
  static Future<void> limparHistorico() async {
    final db = await database;
    await db.delete('pedidos');
  }
}