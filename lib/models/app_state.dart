// lib/models/app_state.dart
import 'package:flutter/material.dart';
import 'produto.dart';

class CartItem {
  final Produto produto;
  int quantidade;

  CartItem({required this.produto, this.quantidade = 1});

  double get subtotal => produto.preco * quantidade;
}

class AppState extends ChangeNotifier {
  // Dados do usuário
  String _nomeUsuario = '';
  String _emailUsuario = '';

  String get nomeUsuario => _nomeUsuario.isNotEmpty ? _nomeUsuario : 'Usuário';
  String get emailUsuario => _emailUsuario;

  void setUsuario({required String nome, required String email}) {
    _nomeUsuario = nome;
    _emailUsuario = email;
    notifyListeners();
  }

  void clearUsuario() {
    _nomeUsuario = '';
    _emailUsuario = '';
    notifyListeners();
  }

  // Lista central de produtos
  List<Produto> _produtos = [];
  void setProdutos(List<Produto> novosProdutos) {
    _produtos = novosProdutos;
    notifyListeners();
  }

  // Carrinho
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

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
    if (_cartItems[idx].quantidade <= 0) _cartItems.removeAt(idx);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _promoCode = null;
    _discount = 0;
    notifyListeners();
  }

  // Cálculos Financeiros (Logica Unificada)
  int get cartCount => _cartItems.fold(0, (sum, i) => sum + i.quantidade);
  double get subTotal => _cartItems.fold(0.0, (sum, i) => sum + i.subtotal);
  
  // Frete Dinâmico (Unificado)
  double get deliveryCharge {
    if (_cartItems.isEmpty) return 0.0;
    if (subTotal >= 200) return 0.0; // Frete grátis acima de 200
    if (subTotal >= 100) return 10.0; // Taxa reduzida
    return 20.0; // Taxa padrão
  }

  double get tax => subTotal * 0.03;
  double get discountValue => _discount;
  
  // Total Geral
  double get totalCost => subTotal + deliveryCharge + tax - _discount;

  // Cupom
  String? _promoCode;
  double _discount = 0;
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

  // Wishlist
  final Set<String> _wishlistIds = {};
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
      _produtos.where((p) => _wishlistIds.contains(p.id)).toList();
}

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