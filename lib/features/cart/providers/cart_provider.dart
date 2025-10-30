import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model for CartItem
class CartItem {
  final String id;
  final String name;
  final String shopName;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.shopName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      shopName: shopName,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Mock data
final _mockCartItems = [
  CartItem(
    id: '1',
    name: 'Apple AirPods Pro 2',
    shopName: 'TechStore',
    imageUrl:
        'https://imgs.search.brave.com/FCh2ZtXdDP2Xe0fSIRzpTOXwON6nOzrYgtVkgvVncMM/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTI5/ODA4MTI1Mi9waG90/by9hcHBsZS1haXJw/b2RzLXByby1pc29s/YXRlZC1vbi13b29k/ZW4tc3VyZmFjZS10/aGUtbmV3LWFpcnBv/ZHMtcHJvLWZlYXR1/cmVzLWFjdGl2ZS1u/b2lzZS5qcGc_cz02/MTJ4NjEyJnc9MCZr/PTIwJmM9MzR5WmQt/WXZlbE1FOGowUmNl/Ym0zT3RuaWpiUDBf/ZFg0THJ1ZF8tMmIz/ND0',
    price: 249.99,
    quantity: 1,
  ),
  CartItem(
    id: '2',
    name: 'Nike Air Max 270',
    shopName: 'Urban Shoes',
    imageUrl:
        'https://imgs.search.brave.com/80pqaE7jzVn6LNVaVbJpxNuko2LEEL2a-luqcTZbYzs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NjFPdmM0OG1PV0wu/anBn',
    price: 159.99,
    quantity: 2,
  ),
  CartItem(
    id: '3',
    name: 'Organic Coffee Beans',
    shopName: 'Brew Café',
    imageUrl:
        'https://imgs.search.brave.com/xWQmDg8ibYAu6LLnJOzMTQKzwXp_FvhdOawwKzN6RKw/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/c2hvcGlmeS5jb20v/cy9maWxlcy8xLzA2/NjAvODU3MS82MjE1/L2ZpbGVzL0Jlc3Rf/UXVhbGl0eV9Pcmdh/bmljX0NvZmZlZV9C/ZWFuc19VSy5qcGc_/dj0xNzIxNjQ4MjM4',
    price: 19.99,
    quantity: 1,
  ),
];

/// Cart Provider (Riverpod)
final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    // Simulate load delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockCartItems;
  }

  void increaseQuantity(String id) {
    final updated = state.value!
        .map(
          (item) =>
              item.id == id ? item.copyWith(quantity: item.quantity + 1) : item,
        )
        .toList();
    state = AsyncData(updated);
  }

  void decreaseQuantity(String id) {
    final updated = state.value!.map((item) {
      if (item.id == id && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    state = AsyncData(updated);
  }

  void removeItem(String id) {
    final updated = state.value!.where((item) => item.id != id).toList();
    state = AsyncData(updated);
  }
}
