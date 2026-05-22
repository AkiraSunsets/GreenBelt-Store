import 'package:flutter/material.dart';
import 'produto.dart';

// ---------------------------------------------------------------------------
// CartItem – agrupa Produto + quantidade
// ---------------------------------------------------------------------------
class CartItem {
  final Produto produto;
  int quantidade;

  CartItem({required this.produto, this.quantidade = 1});

  double get subtotal => produto.preco * quantidade;
}

// ---------------------------------------------------------------------------
// AppState – InheritedWidget simples para compartilhar carrinho e wishlist
// ---------------------------------------------------------------------------
class AppState extends ChangeNotifier {
  // Carrinho
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  // Wishlist
  final Set<String> _wishlistIds = {};

  // Código promo aplicado
  String? _promoCode;
  double _discount = 0;

  // -------------------------------------------------------------------------
  // Carrinho
  // -------------------------------------------------------------------------
  void addToCart(Produto produto, {int quantidade = 1}) {
    final idx = _cartItems.indexWhere((i) => i.produto.id == produto.id);
    if (idx >= 0) {
      _cartItems[idx].quantidade += quantidade;
    } else {
      _cartItems.add(CartItem(produto: produto, quantidade: quantidade));
    }
    notifyListeners();
  }

  void removeFromCart(String produtoId) {
    _cartItems.removeWhere((i) => i.produto.id == produtoId);
    notifyListeners();
  }

  void updateQuantity(String produtoId, int delta) {
    final idx = _cartItems.indexWhere((i) => i.produto.id == produtoId);
    if (idx < 0) return;
    _cartItems[idx].quantidade += delta;
    if (_cartItems[idx].quantidade <= 0) {
      _cartItems.removeAt(idx);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _promoCode = null;
    _discount = 0;
    notifyListeners();
  }

  int get cartCount => _cartItems.fold(0, (sum, i) => sum + i.quantidade);

  double get subTotal => _cartItems.fold(0.0, (sum, i) => sum + i.subtotal);
  double get deliveryCharge => _cartItems.isEmpty ? 0 : 7.0;
  double get tax => subTotal * 0.03;
  double get discountValue => _discount;
  double get totalCost => subTotal + deliveryCharge + tax - _discount;

  // Promo code
  String? get appliedPromo => _promoCode;
  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'GREENBELT10') {
      _promoCode = code;
      _discount = subTotal * 0.1;
      notifyListeners();
      return true;
    }
    return false;
  }

  // -------------------------------------------------------------------------
  // Wishlist
  // -------------------------------------------------------------------------
  bool isWishlisted(String id) => _wishlistIds.contains(id);

  void toggleWishlist(Produto produto) {
    if (_wishlistIds.contains(produto.id)) {
      _wishlistIds.remove(produto.id);
    } else {
      _wishlistIds.add(produto.id);
    }
    notifyListeners();
  }

  List<Produto> get wishlistProdutos =>
      mockProdutos.where((p) => _wishlistIds.contains(p.id)).toList();
}

// ---------------------------------------------------------------------------
// Provider widget – envolve o MaterialApp
// ---------------------------------------------------------------------------
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .notifier!;
  }
}