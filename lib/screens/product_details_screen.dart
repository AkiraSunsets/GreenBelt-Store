import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/produto.dart';
import '../models/app_state.dart';
import '../components/primary_button.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Produto produto;

  const ProductDetailsScreen({
    super.key,
    required this.produto,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  int _quantidade = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _incrementar() => setState(() => _quantidade++);
  void _decrementar() =>
      setState(() { if (_quantidade > 1) _quantidade--; });

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isWished = state.isWishlisted(widget.produto.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel de Imagens
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      Image.network(widget.produto.imagemUrl,
                          fit: BoxFit.cover, width: double.infinity),
                      Image.network(widget.produto.imagemUrl,
                          fit: BoxFit.cover, width: double.infinity),
                      Image.network(widget.produto.imagemUrl,
                          fit: BoxFit.cover, width: double.infinity),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: const SlideEffect(
                          spacing: 8,
                          radius: 8,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: Color(0x80FFFFFF),
                          activeDotColor: Color(0xFF6500B2),
                        ),
                      ),
                    ),
                  ),
                  // Botão Voltar
                  Positioned(
                    top: 50,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF6500B2)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  // Botões Favoritar e Compartilhar
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              isWished
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isWished
                                  ? Colors.red
                                  : const Color(0xFF6500B2),
                            ),
                            onPressed: () =>
                                state.toggleWishlist(widget.produto),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.share_outlined,
                                color: Color(0xFF6500B2)),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge carrinho
                  Positioned(
                    top: 50,
                    right: 120,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartScreen())),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.shopping_cart_outlined,
                                color: Color(0xFF6500B2)),
                          ),
                          if (state.cartCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    color: Color(0xFF6500B2),
                                    shape: BoxShape.circle),
                                child: Text('${state.cartCount}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informações
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.produto is Buque ? 'Buquês' : 'Pelúcias',
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6500B2)),
                        child: Text('Ver avaliações',
                            style: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.produto.nome,
                          style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFFB700), size: 24),
                          const SizedBox(width: 4),
                          Text(
                            widget.produto.avaliacao.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${widget.produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6500B2)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              color: _quantidade > 1
                                  ? Colors.black
                                  : Colors.grey,
                              onPressed: _decrementar,
                            ),
                            Text('$_quantidade',
                                style: GoogleFonts.interTight(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              color: const Color(0xFF6500B2),
                              onPressed: _incrementar,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Product Details',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    'Um buquê bem cuidado dura de 5 a 14 dias. Retire folhas submersas, troque a água a cada 2 dias e mantenha longe do calor e frutas para evitar maturação precoce.',
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            state.toggleWishlist(widget.produto);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isWished
                                      ? 'Removed from wishlist'
                                      : 'Added to wishlist!',
                                  style: GoogleFonts.montserrat(),
                                ),
                                backgroundColor:
                                    isWished ? Colors.grey : Colors.pink,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            isWished
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWished ? Colors.red : const Color(0xFF6500B2),
                          ),
                          label: Text('Wishlist',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6500B2))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF6500B2)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          text: 'Adicionar ao Carrinho',
                          onPressed: () {
                            state.addToCart(widget.produto,
                                quantidade: _quantidade);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '$_quantidade x ${widget.produto.nome} adicionado!',
                                    style: GoogleFonts.montserrat()),
                                backgroundColor:
                                    const Color(0xFF6500B2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                action: SnackBarAction(
                                  label: 'Ver Carrinho',
                                  textColor: Colors.white,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const CartScreen())),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}