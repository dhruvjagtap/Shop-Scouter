// lib/features/search/widgets/shop_card.dart
import 'package:flutter/material.dart';
import '../domain/models.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  const ShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            shop.imageUrl ??
                'https://imgs.search.brave.com/WxJabv_Z9-GRRLyj86T4hkYbgrPk6uZuP66JRs3McjY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9jb2ZmZWUtc2hv/cC1jYWZlLW93bmVy/LXNlcnZpY2UtY29u/Y2VwdF81Mzg3Ni01/MDc4NS5qcGc_c2Vt/dD1haXNfaHlicmlk/Jnc9NzQwJnE9ODA',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(shop.name),
        subtitle: Text(
          '${shop.category} • ⭐ ${shop.ratingAvg.toStringAsFixed(1)}',
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Visit'),
        ),
      ),
    );
  }
}
