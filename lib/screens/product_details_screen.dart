import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/produto.dart';
import '../models/app_state.dart';
import '../components/primary_button.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Produto produto;

  const ProductDetailsScreen({super.key, required this.produto});

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
  void _decrementar() => setState(() {
    if (_quantidade > 1) _quantidade--;
  });

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
                    children: List.generate(
                      3,
                      (_) => Image.network(
                        widget.produto.imagemUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
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
                          activeDotColor: Color(0xFF881F72),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF881F72),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              isWished ? Icons.favorite : Icons.favorite_border,
                              color: isWished
                                  ? Colors.red
                                  : const Color(0xFF881F72),
                            ),
                            onPressed: () =>
                                state.toggleWishlist(widget.produto),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.share_outlined,
                            color: Color(0xFF881F72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Informações
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.produto is Buque ? 'Buquês' : 'Pelúcias',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Ver avaliações',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF881F72),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.produto.nome,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB700),
                            size: 20,
                          ),
                          Text(' ${widget.produto.avaliacao}'),
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
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF881F72),
                        ),
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
                              onPressed: _decrementar,
                            ),
                            Text(
                              '$_quantidade',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                                color: Color(0xFF881F72),
                              ),
                              onPressed: _incrementar,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Detalhes do Produto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Um buquê bem cuidado dura de 5 a 14 dias. Retire folhas submersas, troque a água a cada 2 dias e mantenha longe do calor.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => state.toggleWishlist(widget.produto),
                          icon: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFF881F72),
                          ),
                          label: const Text(
                            'Favoritar',
                            style: TextStyle(color: Color(0xFF881F72)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF881F72)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          text: 'Adicionar ao Carrinho',
                          onPressed: () {
                            state.addToCart(
                              widget.produto,
                              quantidade: _quantidade,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$_quantidade x ${widget.produto.nome} adicionado!',
                                ),
                                backgroundColor: const Color(0xFF881F72),
                                action: SnackBarAction(
                                  label: 'Ver Carrinho',
                                  textColor: Colors.white,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CartScreen(),
                                    ),
                                  ),
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
