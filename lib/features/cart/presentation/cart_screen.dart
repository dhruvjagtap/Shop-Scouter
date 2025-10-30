import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cartAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final totalPrice = cartItems.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartCard(
                      productName: item.name,
                      shopName: item.shopName,
                      imageUrl: item.imageUrl,
                      price: item.price,
                      quantity: item.quantity,
                      onIncrease: () => ref
                          .read(cartProvider.notifier)
                          .increaseQuantity(item.id),
                      onDecrease: () => ref
                          .read(cartProvider.notifier)
                          .decreaseQuantity(item.id),
                      onRemove: () =>
                          ref.read(cartProvider.notifier).removeItem(item.id),
                    );
                  },
                ),
              ),

              // ---------------- BOTTOM TOTAL & CHECKOUT ----------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text("Proceed to Checkout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checkout pressed!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const CartCardShimmer(),
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
