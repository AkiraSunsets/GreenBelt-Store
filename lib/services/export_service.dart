// lib/services/export_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportService {

  static Future<String> exportarPedidoParaArquivo(String conteudoPedido) async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/pedido_exportado.txt');
      await file.writeAsString(conteudoPedido);
      return file.path;
    } catch (e) {
      throw Exception("Erro ao salvar arquivo: $e");
    }
  }
}