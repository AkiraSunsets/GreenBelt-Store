import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  final List<String> _categories = ['All', 'Bouquets', 'Flowers', 'Bears'];

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Produto> get _filteredProdutos {
    if (_selectedCategory == 'All') return mockProdutos;
    if (_selectedCategory == 'Bears') {
      return mockProdutos.whereType<Pelucia>().toList();
    }
    return mockProdutos.whereType<Buque>().toList();
  }

  // Página atual do BottomNavBar
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _homeBody();
      case 1:
        return _productsBody();
      case 2:
        return const WishlistScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _homeBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

        // --- Barra de Navegação Inferior ---
        bottomNavigationBar: Container(
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF6500B2),
              unselectedItemColor: Colors.grey.shade400,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, fontSize: 12),
              unselectedLabelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, fontSize: 12),
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 26), label: 'Home'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.storefront_outlined, size: 26),
                    label: 'Explore'),
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
                                shape: BoxShape.circle),
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
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 26),
                    label: 'Profile'),
              ],
            ),
          ),
        ),

        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _homeBody(),
              _productsBody(),
              const WishlistScreen(),
              _cartBody(),
              const ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HOME body
  // -------------------------------------------------------------------------
  Widget _homeBody() {
    final state = AppStateProvider.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back! 👋',
                          style: GoogleFonts.montserrat(
                              fontSize: 13, color: Colors.grey.shade500)),
                      Text('Esther Howard',
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      // Botão Wishlist com badge
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFCE4EC),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.black),
                              onPressed: () =>
                                  setState(() => _currentIndex = 2),
                            ),
                          ),
                          if (state.wishlistProdutos.isNotEmpty)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // Botão Carrinho com badge
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFCE4EC),
                            child: IconButton(
                              icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CartScreen())),
                            ),
                          ),
                          if (state.cartCount > 0)
                            Positioned(
                              right: 2,
                              top: 2,
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
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Barra de pesquisa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for flowers, bouquets...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Carousel
            SizedBox(
              height: 170,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: const [
                        BannerCard(
                            imageUrl:
                                'https://images.unsplash.com/photo-1490750967868-88df5691cc1e?w=800&q=80'),
                        BannerCard(
                            imageUrl:
                                'https://images.unsplash.com/photo-1469259943454-aa100abba749?w=800&q=80'),
                        BannerCard(
                            imageUrl:
                                'https://images.unsplash.com/photo-1527234942534-f56dc5b41519?w=800&q=80'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const SlideEffect(
                      spacing: 8,
                      radius: 8,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: Color(0xFFFCE4EC),
                      activeDotColor: Color(0xFF6500B2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => setState(() => _currentIndex = 1),
                    child: Text('See All',
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6500B2))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: _categories.asMap().entries.map((e) {
                  final sel = _selectedCategory == e.value;
                  return Padding(
                    padding: EdgeInsets.only(
                        right: e.key < _categories.length - 1 ? 10 : 0),
                    child: CategoryButton(
                      title: e.value,
                      isSelected: sel,
                      onPressed: () =>
                          setState(() => _selectedCategory = e.value),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Featured Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Featured',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: _filteredProdutos.length,
                itemBuilder: (context, index) {
                  final produto = _filteredProdutos[index];
                  return Stack(
                    children: [
                      ProductCard(
                        produto: produto,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(produto: produto),
                          ),
                        ),
                      ),
                      // Botão de wishlist no card
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => state.toggleWishlist(produto),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Icon(
                              state.isWishlisted(produto.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: state.isWishlisted(produto.id)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // EXPLORE/PRODUCTS body
  // -------------------------------------------------------------------------
  Widget _productsBody() {
    final state = AppStateProvider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Text('Explore',
                  style: GoogleFonts.montserrat(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.tune_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: _categories.asMap().entries.map((e) {
              final sel = _selectedCategory == e.value;
              return Padding(
                padding: EdgeInsets.only(
                    right: e.key < _categories.length - 1 ? 10 : 0),
                child: CategoryButton(
                  title: e.value,
                  isSelected: sel,
                  onPressed: () =>
                      setState(() => _selectedCategory = e.value),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: _filteredProdutos.length,
            itemBuilder: (context, index) {
              final produto = _filteredProdutos[index];
              return Stack(
                children: [
                  ProductCard(
                    produto: produto,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailsScreen(produto: produto),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => state.toggleWishlist(produto),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: Icon(
                          state.isWishlisted(produto.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: state.isWishlisted(produto.id)
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Cart tab abre a CartScreen como embedded (ou push)
  Widget _cartBody() {
    return const CartScreen();
  }
}