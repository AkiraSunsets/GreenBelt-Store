// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:greenbelt_flutter/services/produto_service.dart';
import 'package:greenbelt_flutter/services/auth_service.dart';

import '../models/produto.dart';
import '../models/app_state.dart';
import '../components/product_card.dart';
import '../components/banner_card.dart';
import '../components/category_button.dart';
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
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  List<Produto> _produtos = [];
  bool _isLoading = true;

  //Username logado
  String _userName = '';

  final List<String> _categories = ['Todos', 'Buquês', 'Flores', 'Pelúcias'];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

Future<void> _carregarProdutos() async {
  try {
    final lista = await ProdutoService.getProdutos();
    if (!mounted) return;
    
    // Atualiza o estado global para que wishlist/carrinho saibam dos produtos
    AppStateProvider.of(context).setProdutos(lista);
    
    setState(() {
      _produtos = lista;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    // Erro silencioso ou SnackBar
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Produto> get _filteredProdutos {
    if (_selectedCategory == 'Todos') return _produtos;
    if (_selectedCategory == 'Pelúcias') {
      return _produtos.whereType<Pelucia>().toList();
    }
    return _produtos.whereType<Buque>().toList();
  }

  //atualiza o nome
  void _recarregarNome() async {
    final nome = await AuthService.getNome();
    if (mounted) setState(() => _userName = nome);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildNavBar(state),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
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

  Widget _buildNavBar(AppState state) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade50.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF881F72),
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 26),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined, size: 26),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.favorite_border, size: 26),
                  if (state.wishlistProdutos.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 26),
                  if (state.cartCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF881F72),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${state.cartCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 26),
              label: 'Profile',
            ),
          ],
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
          _buildHeader(state),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildCarousel(),
          const SizedBox(height: 28),
          _buildCategoryHeader(),
          const SizedBox(height: 12),
          _buildCategoryList(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Featured',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildProductGrid(state),
        ],
      ),
    );
  }

  Widget _buildHeader(AppState state) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back! ',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            // Exibe o nome real do usuário logado
            Text(
              _userName.isEmpty ? 'Loading...' : _userName,
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
        hintText: 'Search for flowers...',
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

  Widget _buildCarousel() => SizedBox(
    height: 170,
    child: Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: const [
              BannerCard(assetPath: 'assets/images/1.jpg'),
              BannerCard(assetPath: 'assets/images/2.jpg'),
              BannerCard(assetPath: 'assets/images/3.jpg'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: const SlideEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: Color(0xFF881F72),
          ),
        ),
      ],
    ),
  );

  Widget _buildCategoryHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 1),
          child: Text(
            'See All',
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

  Widget _buildProductGrid(AppState state) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: GridView.builder(
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
                'Explore',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.tune_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
        _buildCategoryList(),
        const SizedBox(height: 16),
        Expanded(child: _buildProductGrid(state)),
      ],
    );
  }
}
