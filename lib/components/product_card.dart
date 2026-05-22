import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/produto.dart'; // Ajuste o caminho conforme sua pasta

class ProductCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.produto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container da Imagem
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                produto.imagemUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Nome do Produto
          Text(
            produto.nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          
          // Preço
          Text(
            'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          
          // Estrelas e Reviews
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < produto.avaliacao.floor() ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFAB00),
                  size: 15,
                );
              }),
              const SizedBox(width: 4),
              Text(
                '(${produto.totalReviews})',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}