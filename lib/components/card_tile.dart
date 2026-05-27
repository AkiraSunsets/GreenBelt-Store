import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_state.dart';
import '../models/produto.dart';

class CartTile extends StatelessWidget {
  final CartItem item;
  
  const CartTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Imagem
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: Image.network(item.produto.imagemUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produto.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  item.produto is Buque ? 'Buquê' : 'Pelúcia',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 6),
                Text(
                  'R\$ ${item.produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          // Contador
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CounterBtn(
                  icon: Icons.remove,
                  color: item.quantidade > 1
                      ? Colors.black
                      : Colors.grey.shade300,
                  isPrimary: false,
                  onTap: () => state.updateQuantity(item.produto.id, -1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantidade}',
                    style: GoogleFonts.montserrat(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                _CounterBtn(
                  icon: Icons.add,
                  color: const Color(0xFF881F72),
                  isPrimary: true,
                  onTap: () => state.updateQuantity(item.produto.id, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// O botão contador pode ficar privado aqui dentro mesmo, 
// já que só o CartTile vai usar ele.
class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final VoidCallback onTap;
  
  const _CounterBtn({
    required this.icon, 
    required this.color, 
    this.isPrimary = false, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF881F72) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 16,
            color: isPrimary ? Colors.white : color),
      ),
    );
  }
}