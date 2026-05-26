import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_state.dart';
import '../services/database_service.dart';
import '../services/export_service.dart';
import '../services/produto_service.dart';
import '../screens/order_sucess_screen.dart'; // Import da tela de sucesso
import '../services/current_service.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final String frete;
  final String endereco;

  const PaymentScreen({super.key, required this.total, required this.frete, required this.endereco});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _metodoPagamento = 'Cartão de Crédito';
  double _taxaDolar = 0;

  @override
  void initState() {
    super.initState();
    _carregarCambio();
  }

  // [C8] Requisito: Integração de Múltiplas APIs
  Future<void> _carregarCambio() async {
    final taxa = await CurrencyService.getUsdRate();
    setState(() => _taxaDolar = taxa);
  }

  Future<void> _finalizarTudo(AppState state) async {
    final itens = state.cartItems.map((i) => {
      'nome': i.produto.nome,
      'quantidade': i.quantidade,
      'subtotal': i.subtotal,
    }).toList();

    // [C7] Requisito: Persistência Interna (SQLite)
    await DatabaseService.salvarPedido(
      total: widget.total,
      frete: widget.frete,
      itens: itens,
    );

    // [C7] Requisito: Persistência Externa (Arquivo TXT)
    String conteudo = "COMPROVANTE GREENBELT\n"
        "Endereço: ${widget.endereco}\n"
        "Total: R\$ ${widget.total.toStringAsFixed(2)}\n"
        "Método: $_metodoPagamento";
    await ExportService.exportarPedidoParaArquivo(conteudo);

    state.clearCart();

    if (!mounted) return;
    
    // --- AQUI ESTÁ O CAMINHO PARA A TELA DE ORDER SUCCESS ---
    // O const já está aplicado corretamente aqui!
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total a pagar: R\$ ${widget.total.toStringAsFixed(2)}", 
              style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
            
            if (_taxaDolar > 0)
              Text("(Valor em Dólar: \$ ${(widget.total / _taxaDolar).toStringAsFixed(2)})",
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),
            const Text("Selecione o método:"),
            ListTile(
              title: const Text("Cartão de Crédito"),
              leading: Radio(value: 'Cartão', groupValue: _metodoPagamento, onChanged: (v) => setState(() => _metodoPagamento = v!)),
            ),
            ListTile(
              title: const Text("Pix"),
              leading: Radio(value: 'Pix', groupValue: _metodoPagamento, onChanged: (v) => setState(() => _metodoPagamento = v!)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF881F72)),
                // O botão chama a função que faz toda a lógica e navega no final
                onPressed: () => _finalizarTudo(state),
                child: const Text("CONFIRMAR E PAGAR", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}