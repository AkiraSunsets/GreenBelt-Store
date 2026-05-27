import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenbelt_flutter/services/produto_service.dart';
import 'package:greenbelt_flutter/services/auth_service.dart';

import '../models/produto.dart';
import '../models/app_state.dart';
import '../components/product_card.dart';
import '../components/category_button.dart';
import '../components/banner_carousel.dart';
import '../components/nav_bar_bottom.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  String _selectedCategory = 'Todos';

  List<Produto> _produtos = [];
  bool _isLoading = true;
  String _userName = '';

  final List<String> _categories = ['Todos', 'Buquês', 'Flores', 'Pelúcias'];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
    _recarregarNome();
  }

  Future<void> _carregarProdutos() async {
    try {
      final lista = await ProdutoService.getProdutos();
      if (!mounted) return;
      AppStateProvider.of(context).setProdutos(lista);
      setState(() {
        _produtos = lista;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Filtro Dinâmico: Compara a categoria do produto com a selecionada
  List<Produto> get _filteredProdutos {
    if (_selectedCategory == 'Todos') return _produtos;
    return _produtos.where((p) => p.categoria == _selectedCategory).toList();
  }

  void _recarregarNome() async {
    final nome = await AuthService.getNome();
    if (mounted) {
      setState(() => _userName = nome.isNotEmpty ? nome : 'Visitante');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          cartCount: state.cartCount,
          hasWishlistItems: state.wishlistProdutos.isNotEmpty,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF881F72)),
                )
              : IndexedStack(
                  index: _currentIndex,
                  children: [
                    _homeBody(state),
                    _productsBody(state),
                    const WishlistScreen(),
                    const CartScreen(),
                    ProfileScreen(onNameUpdated: _recarregarNome),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _homeBody(AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          const BannerCarousel(),
          const SizedBox(height: 28),
          _buildCategoryHeader(),
          const SizedBox(height: 12),
          _buildCategoryList(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Destaques',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo de volta!',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              _userName.isEmpty ? 'Carregando...' : _userName,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          ),
        ),
      ],
    ),
  );

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: TextFormField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar flores ou pelúcias...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _buildCategoryHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categorias',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 1),
          child: Text(
            'Ver Tudo',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF881F72),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildCategoryList() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: _categories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CategoryButton(
                title: cat,
                isSelected: _selectedCategory == cat,
                onPressed: () => setState(() => _selectedCategory = cat),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _buildProductGrid() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: GridView.builder(
      key: ValueKey(_selectedCategory),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: _filteredProdutos.length,
      itemBuilder: (context, index) {
        final produto = _filteredProdutos[index];
        return ProductCard(
          produto: produto,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(produto: produto),
            ),
          ),
        );
      },
    ),
  );

  Widget _productsBody(AppState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Text(
                'Explorar',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        _buildCategoryList(),
        const SizedBox(height: 16),
        Expanded(child: _buildProductGrid()),
      ],
    );
  }
}
