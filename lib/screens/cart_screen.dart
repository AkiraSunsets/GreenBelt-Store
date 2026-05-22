import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/app_state.dart';
import 'checkout_screen.dart';
import '../models/produto.dart'; // <--- Adicione esta linha

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _promoError = false;
  bool _promoSuccess = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(AppState state) {
    final ok = state.applyPromo(_promoController.text);
    setState(() {
      _promoError = !ok;
      _promoSuccess = ok;
    });
  }

  Future<bool?> _confirmRemove(BuildContext context, String name) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Remove from Cart?',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to remove "$name"?',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6500B2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.montserrat(
                            color: const Color(0xFF6500B2),
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6500B2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text('Yes, Remove',
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
                fontSize: isTotal ? 15 : 14,
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? Colors.black : Colors.grey.shade600),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
                fontSize: isTotal ? 16 : 14,
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.w600,
                color: valueColor ??
                    (isTotal ? const Color(0xFF6500B2) : Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final items = state.cartItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Cart',
          style: GoogleFonts.montserrat(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? _emptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Dismissible(
                        key: Key(item.produto.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          final ok = await _confirmRemove(
                              context, item.produto.nome);
                          return ok ?? false;
                        },
                        onDismissed: (_) =>
                            state.removeFromCart(item.produto.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 28),
                        ),
                        child: _CartTile(item: item),
                      );
                    },
                  ),
                ),

                // Promo + Resumo
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, -4))
                    ],
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Promo code
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              decoration: InputDecoration(
                                hintText: 'Promo Code',
                                hintStyle: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey.shade400),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText:
                                    _promoError ? 'Invalid code' : null,
                                suffixIcon: _promoSuccess
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : null,
                              ),
                              style: GoogleFonts.montserrat(fontSize: 14),
                              onChanged: (_) => setState(() {
                                _promoError = false;
                                _promoSuccess = false;
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _applyPromo(state),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6500B2),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                            child: Text('Apply',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      _summaryRow('Sub-Total',
                          '\$${state.subTotal.toStringAsFixed(2)}'),
                      _summaryRow('Delivery Charge',
                          '\$${state.deliveryCharge.toStringAsFixed(2)}'),
                      _summaryRow(
                          'Tax', '\$${state.tax.toStringAsFixed(2)}'),
                      if (state.discountValue > 0)
                        _summaryRow(
                            'Discount',
                            '-\$${state.discountValue.toStringAsFixed(2)}',
                            valueColor: Colors.green),
                      const Divider(),
                      _summaryRow(
                          'Total Cost',
                          '\$${state.totalCost.toStringAsFixed(2)}',
                          isTotal: true),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6500B2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text('Proceed to Checkout',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text('Add some products to get started!',
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tile individual do carrinho
// ---------------------------------------------------------------------------
class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

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
                  item.produto is Buque ? 'Bouquet' : 'Bear',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.produto.preco.toStringAsFixed(2)}',
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
                  onTap: () =>
                      state.updateQuantity(item.produto.id, -1),
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
                  color: const Color(0xFF6500B2),
                  onTap: () =>
                      state.updateQuantity(item.produto.id, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CounterBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color == const Color(0xFF6500B2)
              ? const Color(0xFF6500B2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 16,
            color: color == const Color(0xFF6500B2)
                ? Colors.white
                : color),
      ),
    );
  }
}