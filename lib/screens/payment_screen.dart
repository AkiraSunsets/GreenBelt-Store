import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_state.dart';
import 'order_sucess_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final String frete;
  final String endereco;

  const PaymentScreen({
    super.key,
    required this.total,
    required this.frete,
    required this.endereco,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _metodoPagamento = 'Cartão de Crédito';

  // Navegação direta e limpa para evitar travamentos
  void _finalizarPedido(AppState state) {
    state.clearCart(); // Limpa o carrinho antes de sair

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Pagamento",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total a pagar",
              style: GoogleFonts.montserrat(color: Colors.grey.shade600),
            ),
            Text(
              "R\$ ${widget.total.toStringAsFixed(2).replaceAll('.', ',')}",
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF881F72),
              ),
            ),

            const SizedBox(height: 40),
            Text(
              "Método de Pagamento",
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildRadioOption('Cartão de Crédito', Icons.credit_card),
            _buildRadioOption('Pix', Icons.qr_code),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF881F72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () => _finalizarPedido(state),
                child: Text(
                  "CONFIRMAR E PAGAR",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String valor, IconData icone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile(
        title: Text(valor, style: GoogleFonts.montserrat()),
        value: valor,
        groupValue: _metodoPagamento,
        secondary: Icon(icone, color: const Color(0xFF881F72)),
        onChanged: (v) => setState(() => _metodoPagamento = v!),
      ),
    );
  }
}
