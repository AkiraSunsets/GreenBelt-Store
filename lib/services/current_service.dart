import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  // Consumindo a API da AwesomeAPI para obter a cotação do Dólar
  static Future<double> getUsdRate() async {
    try {
      final response = await http.get(
        Uri.parse('https://economia.awesomeapi.com.br/last/USD-BRL'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // O campo 'bid' traz o valor de compra atual do dólar
        return double.parse(data['USDBRL']['bid']);
      }
    } catch (e) {
      // Caso ocorra erro na API, retornamos um valor fixo de fallback
      // ou 0 para não quebrar a UI
      return 0.0; 
    }
    return 0.0;
  }
}