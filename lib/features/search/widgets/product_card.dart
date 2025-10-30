// lib/features/search/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../domain/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl ?? 'https://via.placeholder.com/150',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          '${product.shopName} • \$${product.price.toStringAsFixed(2)}',
        ),
        trailing: ElevatedButton(onPressed: () {}, child: const Text('View')),
      ),
    );
  }
}
