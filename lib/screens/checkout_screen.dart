import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/app_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shippingType = 'Economy';

  final Map<String, Map<String, String>> _shippingOptions = {
    'Economy': {
      'label': 'Economy',
      'eta': 'Estimated Arrival 5–7 business days',
      'price': '\$7.00',
    },
    'Express': {
      'label': 'Express',
      'eta': 'Estimated Arrival 1–2 business days',
      'price': '\$15.00',
    },
    'Same Day': {
      'label': 'Same Day',
      'eta': 'Delivery today by 9 PM',
      'price': '\$25.00',
    },
  };

  void _showShippingPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setBS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Choose Shipping Type',
                  style: GoogleFonts.montserrat(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._shippingOptions.entries.map((e) {
                final selected = _shippingType == e.key;
                return GestureDetector(
                  onTap: () {
                    setState(() => _shippingType = e.key);
                    setBS(() {});
                    Future.delayed(const Duration(milliseconds: 200),
                        () => Navigator.pop(ctx));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF3E5FF)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6500B2)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            color: selected
                                ? const Color(0xFF6500B2)
                                : Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value['label']!,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              Text(e.value['eta']!,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Text(e.value['price']!,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6500B2))),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _placeOrder(AppState state) {
    state.clearCart();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check,
                    color: Color(0xFF6500B2), size: 40),
              ),
              const SizedBox(height: 20),
              Text('Order Placed!',
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Your order has been confirmed and will be delivered soon.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6500B2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Back to Home',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final items = state.cartItems;
    final shipping = _shippingOptions[_shippingType]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Checkout',
            style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            _SectionTitle(title: 'Shipping Address'),
            const SizedBox(height: 12),
            _InfoTile(
              icon: Icons.location_on_outlined,
              title: 'Home',
              subtitle: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
              actionLabel: 'CHANGE',
              onAction: () {},
            ),

            const SizedBox(height: 24),

            // Shipping Type
            _SectionTitle(title: 'Choose Shipping Type'),
            const SizedBox(height: 12),
            _InfoTile(
              icon: Icons.local_shipping_outlined,
              title: shipping['label']!,
              subtitle: shipping['eta']!,
              actionLabel: 'CHANGE',
              onAction: _showShippingPicker,
            ),

            const SizedBox(height: 24),

            // Order List
            _SectionTitle(title: 'Order List'),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Image.network(item.produto.imagemUrl,
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.produto.nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            Text(
                                item.produto is Buque
                                    ? 'Bouquet'
                                    : 'Bear',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6500B2)),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            _summaryRow('Sub-Total',
                '\$${state.subTotal.toStringAsFixed(2)}'),
            _summaryRow('Shipping', shipping['price']!),
            _summaryRow('Tax', '\$${state.tax.toStringAsFixed(2)}'),
            if (state.discountValue > 0)
              _summaryRow(
                  'Discount',
                  '-\$${state.discountValue.toStringAsFixed(2)}',
                  valueColor: Colors.green),
            const Divider(),
            _summaryRow(
                'Total', '\$${state.totalCost.toStringAsFixed(2)}',
                isTotal: true),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _placeOrder(state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6500B2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: Text('Continue to Payment',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: isTotal ? 15 : 14,
                  fontWeight:
                      isTotal ? FontWeight.bold : FontWeight.w500,
                  color: isTotal ? Colors.black : Colors.grey.shade600)),
          Text(value,
              style: GoogleFonts.montserrat(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight:
                      isTotal ? FontWeight.bold : FontWeight.w600,
                  color: valueColor ??
                      (isTotal
                          ? const Color(0xFF6500B2)
                          : Colors.black))),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Text(
        title,
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _InfoTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.actionLabel,
      required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6500B2), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.montserrat(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel,
                style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6500B2))),
          ),
        ],
      ),
    );
  }
}