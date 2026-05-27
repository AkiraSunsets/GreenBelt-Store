//persistencia de dados no banco interno com sqlite
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // Singleton — garante uma única instância do banco em todo o app
  static Future<Database?> get database async {
    if (kIsWeb) return null; // Proteção para Web
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'greenbelt.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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

  // INSERT — salva o pedido
  static Future<int> salvarPedido({
    required double total,
    required String frete,
    required List<Map<String, dynamic>> itens,
  }) async {
    if (kIsWeb) {
      print("Modo Web: Simulando salvamento de pedido no banco.");
      return 1; 
    }

    final db = await database;
    return db!.insert('pedidos', {
      'data': DateTime.now().toIso8601String(),
      'total': total,
      'frete': frete,
      'itensJson': jsonEncode(itens),
    });
  }

  // SELECT ALL — retorna todos os pedidos
  static Future<List<Map<String, dynamic>>> buscarPedidos() async {
    if (kIsWeb) return []; // Retorna lista vazia na Web

    final db = await database;
    return db!.query('pedidos', orderBy: 'data DESC');
  }

  // SELECT ONE — retorna um pedido específico
  static Future<Map<String, dynamic>?> buscarPedidoPorId(int id) async {
    if (kIsWeb) return null; // Retorna nulo na Web

    final db = await database;
    final result = await db!.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // DELETE — remove um pedido
  static Future<void> deletarPedido(int id) async {
    if (kIsWeb) return; // Nada a deletar na Web

    final db = await database;
    await db!.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  // DELETE ALL — limpa histórico
  static Future<void> limparHistorico() async {
    if (kIsWeb) return; // Nada a limpar na Web

    final db = await database;
    await db!.delete('pedidos');
  }
}