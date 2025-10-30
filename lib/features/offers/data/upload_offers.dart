import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../search/domain/models.dart';

final List<Map<String, dynamic>> mockOffers = [
  {
    "shopName": "Fresh Mart",
    "offerText": "Buy 1 Get 1 Free on all fruits",
    "category": "Groceries",
    "validTill": "30 Oct 2025",
    "imageUrl":
        "https://imgs.search.brave.com/f8JsfINKYZUMyavpPO4vSfTxprZWlPBD_VtbYUufHRs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzE0LzI4Lzc4Lzk0/LzM2MF9GXzE0Mjg3/ODk0NjFfMWlCVkh5/VzlIMEJSckhoQ01Q/cTVnanVEa3pUSXc4/bzIuanBn",
  },
  {
    "shopName": "Trendy Threads",
    "offerText": "Flat 40% OFF on new arrivals",
    "category": "Clothing",
    "validTill": "15 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/l-J-eHo54xM1tFuFFxW7mmOLQd53JU-thutLyYsbFb4/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/c2h1dHRlcnN0b2Nr/LmNvbS9pbWFnZS12/ZWN0b3IvZmxhdC00/MC1wZXJjZW50LW9m/Zi1zYWxlLTI2MG53/LTIxOTY0MDgzMjUu/anBn",
  },
  {
    "shopName": "ElectroWorld",
    "offerText": "Up to ₹6000 Cashback on Smartphones",
    "category": "Electronics",
    "validTill": "5 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/SwsteTElesSk9N7TSmpNUbqMcUQYjlmUN5dmMKbeivA/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/aWNpY2liYW5rLmNv/bS9jb250ZW50L2Rh/bS9pY2ljaWJhbmsv/aW5kaWEvbWFuYWdl/ZC1hc3NldHMvaW1h/Z2VzL29mZmVycy81/OTV4MjQyLWlwaG9u/ZS13ZWJzaXRlLWJh/bm5lci1jb3B5Lndl/YnA",
  },
  {
    "shopName": "Café Aroma",
    "offerText": "Free Coffee with every Dessert",
    "category": "Food & Beverages",
    "validTill": "28 Oct 2025",
    "imageUrl":
        "https://imgs.search.brave.com/5bCHaVSHPNfp96BcGnhqr1IDujiDGnf_smo21FJ0Qbo/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTI1/NTA0MDM0NC9waG90/by90aXJhbWlzdS1k/ZXNzZXJ0LXdpdGgt/Y3VwLW9mLWNvZmZl/ZS1kYXJrLWJhY2tn/cm91bmQtY2xvc2Ut/dXAtdG9wLXZpZXcu/anBnP3M9NjEyeDYx/MiZ3PTAmaz0yMCZj/PWc4ODdtT3RFZ09n/c0FwdWN0TG56akti/anN1UUpQMWNDdEhP/ckU0Z0k3Qjg9",
  },
  {
    "shopName": "Book Haven",
    "offerText": "20% OFF on all Fiction Books",
    "category": "Stationery",
    "validTill": "10 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/VuZVdrdV_WQHaPdZxG3iqVVA6YJfXwgFzP0EUi10lsI/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/cHNib29rcy5jby51/ay9tZWRpYS93eXNp/d3lnL0NvbnRlbnRf/QmxvY2tfSG9tZXBh/Z2VfQ3JpbWVGaWN0/aW9uXzg1MHg3NTBf/MS5qcGc",
  },
  {
    "shopName": "FitZone Gym",
    "offerText": "Free 1 Week Trial + 15% OFF Membership",
    "category": "Fitness",
    "validTill": "1 Dec 2025",
    "imageUrl":
        "https://imgs.search.brave.com/0B5nRlgcGkrLtWKouELE0crOetht3v1aQrfAFYqLbC8/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/cnlhbmFuZGFsZXgu/Y29tL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDIwLzA3L0JlYWNo/Ym9keS1vbi1kZW1h/bmQtZnJlZS10cmlh/bC1wcm9ncmFtLW1h/dGVyaWFscy5qcGc",
  },
  {
    "shopName": "The Shoe Stop",
    "offerText": "Buy 2, Get 1 Free",
    "category": "Footwear",
    "validTill": "20 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/xsz1GaJ_QMk7otb80QLTXd2C0hEYWPgaKVD-8ZpFY6Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTk5/NTA3MTkyMS92ZWN0/b3IvYnV5LXR3by1n/ZXQtb25lLWZyZWUt/b2ZmZXItc2FsZS1i/YW5uZXItdmVjdG9y/LWRlc2lnbi5qcGc_/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9Xy1u/VHloemNTcGljUVZ4/UVF0VDB3YV9XdkQ1/dXJ5WElzZ0kwUmwy/a19ZST0",
  },
  {
    "shopName": "Glow & Go Salon",
    "offerText": "Flat 25% OFF on Hair Spa & Facial",
    "category": "Beauty",
    "validTill": "18 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/vVBX7-h3FUo-cCHs1Bi1swFr9RwvBbDv5sGdwAiNeKE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9yZXMu/Y2xvdWRpbmFyeS5j/b20vdXJiYW5jbGFw/L2ltYWdlL3VwbG9h/ZC90X2hpZ2hfcmVz/X3RlbXBsYXRlLHFf/YXV0bzpsb3csZl9h/dXRvL3dfMTIzMixk/cHJfMixmbF9wcm9n/cmVzc2l2ZTpzdGVl/cCxxX2F1dG86bG93/LGZfYXV0byxjX2xp/bWl0L2ltYWdlcy9z/dXBwbHkvY3VzdG9t/ZXItYXBwLXN1cHBs/eS8xNzU4NTI3Nzgx/NDkzLThkMmY2NS5q/cGVn",
  },
  {
    "shopName": "Tech Town",
    "offerText": "Free Accessories with Every Laptop",
    "category": "Electronics",
    "validTill": "22 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/d3SvkPNWf7Wjk3FfBaIXpSeqRigPtFOYpyJxo6ob55g/rs:fit:0:180:1:0/g:ce/aHR0cHM6Ly93d3cu/dmlqYXlzYWxlcy5j/b20vY29udGVudC9k/YW0vdmlqYXlzYWxl/c3dlYnNpdGUvaW4v/ZW4vY29tbW9uL2hl/YWRlci9uYXZpZ2F0/aW9uLWNhcmQvanVu/ZS0yMDI1LzE5LTA2/LTI1L1JlZnVyYmlz/aGVkJTIwTGFwdG9w/cyUyME5hdmlnYXRp/b24lMjBjYXJkJTIw/TW9iaWxlLmpwZw",
  },
  {
    "shopName": "HomeStyle Décor",
    "offerText": "Up to 50% OFF on Furniture",
    "category": "Home & Living",
    "validTill": "30 Nov 2025",
    "imageUrl":
        "https://imgs.search.brave.com/J4jyjhUjCy_zdHMOlazmG4AblvJnTSeWyARNKPI-1N8/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMucm9vbXN0b2dv/LmNvbS92Mi9DOF9S/MV9EU1BfQ3VyYXRl/U3BhY2VfVElMRV9T/V180OTN4NDkzLnBu/Zz9xPTYwJmNhY2hl/LWlkPUM4X1IxX0RT/UF9DdXJhdGVfU3Bh/Y2VfVElMRV9TV180/OTN4NDkzX2ZlOTRh/MGMxNGE",
  },
];

Future<void> uploadOffers() async {
  final firestore = FirebaseFirestore.instance;

  for (var offer in mockOffers) {
    await firestore.collection('offers').add(offer);
  }

  debugPrint("All offers uploaded successfully!");
}

final List<Map<String, dynamic>> mockShops = [
  {
    'name': 'Fresh Mart',
    'category': 'Groceries',
    'description':
        'Your friendly neighborhood grocery store with fresh fruits and daily essentials.',
    'imageUrl':
        'https://imgs.search.brave.com/f8JsfINKYZUMyavpPO4vSfTxprZWlPBD_VtbYUufHRs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzE0LzI4Lzc4Lzk0/LzM2MF9GXzE0Mjg3/ODk0NjFfMWlCVkh5/VzlIMEJSckhoQ01Q/cTVnanVEa3pUSXc4/bzIuanBn',
    'imageUrls': [],
    'address': '12 Main Street, Mumbai, India',
    'phone': '+91 9876543210',
    'email': 'info@freshmart.com',
    'location': GeoPoint(19.0760, 72.8777),
    'hours': WeeklySchedule(
      days: {
        'mon': OpeningHours(closed: false, open: '08:00', close: '21:00'),
        'tue': OpeningHours(closed: false, open: '08:00', close: '21:00'),
        'wed': OpeningHours(closed: false, open: '08:00', close: '21:00'),
        'thu': OpeningHours(closed: false, open: '08:00', close: '21:00'),
        'fri': OpeningHours(closed: false, open: '08:00', close: '21:00'),
        'sat': OpeningHours(closed: false, open: '09:00', close: '20:00'),
        'sun': OpeningHours(closed: true),
      },
    ).toMap(),
    'isVerified': true,
    'isFeatured': true,
    'ratingAvg': 4.5,
    'ratingCount': 120,
    'views': 540,
    'clicks': 320,
    'owner': {
      'id': 'owner1',
      'name': 'Rahul Mehta',
      'email': 'rahul@freshmart.com',
      'phone': '+91 9876543210',
      'profileImage': null,
    },
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'metadata': {
      'tags': ['organic', 'local', 'discounts'],
    },
  },
  {
    'name': 'Tech Town',
    'category': 'Electronics',
    'description': 'One-stop shop for the latest gadgets and accessories.',
    'imageUrl':
        'https://imgs.search.brave.com/d3SvkPNWf7Wjk3FfBaIXpSeqRigPtFOYpyJxo6ob55g/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/dmlqYXlzYWxlcy5j/b20vY29udGVudC9k/YW0vdmlqYXlzYWxl/c3dlYnNpdGUvaW4v/ZW4vY29tbW9uL2hl/YWRlci9uYXZpZ2F0/aW9uLWNhcmQvanVu/ZS0yMDI1LzE5LTA2/LTI1L1JlZnVyYmlz/aGVkJTIwTGFwdG9w/cyUyME5hdmlnYXRp/b24lMjBjYXJkJTIw/TW9iaWxlLmpwZw',
    'imageUrls': [],
    'address': '45 Market Road, Pune, India',
    'phone': '+91 9123456789',
    'email': 'sales@techtown.com',
    'location': GeoPoint(18.5204, 73.8567),
    'hours': WeeklySchedule(
      days: {
        'mon': OpeningHours(closed: false, open: '10:00', close: '20:00'),
        'tue': OpeningHours(closed: false, open: '10:00', close: '20:00'),
        'wed': OpeningHours(closed: false, open: '10:00', close: '20:00'),
        'thu': OpeningHours(closed: false, open: '10:00', close: '20:00'),
        'fri': OpeningHours(closed: false, open: '10:00', close: '20:00'),
        'sat': OpeningHours(closed: false, open: '11:00', close: '18:00'),
        'sun': OpeningHours(closed: true),
      },
    ).toMap(),
    'isVerified': true,
    'isFeatured': false,
    'ratingAvg': 4.3,
    'ratingCount': 80,
    'views': 420,
    'clicks': 200,
    'owner': {
      'id': 'owner2',
      'name': 'Priya Sharma',
      'email': 'priya@techtown.com',
      'phone': '+91 9123456789',
    },
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  },
];

final List<Map<String, dynamic>> mockProducts = [
  {
    'name': 'Apple (1kg)',
    'shopId': 'shop1',
    'shopName': 'Fresh Mart',
    'description': 'Fresh and juicy apples directly from local farms.',
    'price': 180.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/9F3vSxyFzXnZjQwqOGvVld_3vJ4VGsvosq4spvcyqOQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMucHJvZHVjdGh1/YnMuY29tL21lZGlh/L2ltYWdlcy9mcnVpdHMvYXBwbGVzLmpwZw',
    'stock': 50,
    'unit': '1kg',
    'isActive': true,
    'isFeatured': true,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'priceHistory': [
      {'price': 190.0, 'updatedAt': Timestamp.now(), 'note': 'Weekly discount'},
    ],
  },
  {
    'name': 'Bananas (Dozen)',
    'shopId': 'shop1',
    'shopName': 'Fresh Mart',
    'description': 'Organic bananas full of nutrients.',
    'price': 60.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/NmKZ5M4fOa-wZ8xvRlNTxz8cq8pHbODgKn2q9j3F6sE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9mcmVl/cGlrLmNvbS9pbWcv/MjAyMTAxL2JhbmFu/YXMuanBn',
    'stock': 100,
    'unit': '1 dozen',
    'isActive': true,
    'isFeatured': false,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  },
  {
    'name': 'iPhone 15 Pro',
    'shopId': 'shop2',
    'shopName': 'Tech Town',
    'description': 'Apple iPhone 15 Pro with 256GB storage, Titanium finish.',
    'price': 134999.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/4JoWOfxTdOq9Krk3i6LVfKTxh6Q6US7rIocH17uHyDA/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdGF0/aWMuYXBwbGUuY29t/L2ltYWdlcy9pbmZv/L2lwaG9uZTE1cHJv/L2hlcm9pbWFnZS9p/cGhvbmUxNXByb19m/YW1pbHkxXzEuanBn',
    'stock': 10,
    'unit': '1 unit',
    'isActive': true,
    'isFeatured': true,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'priceHistory': [
      {'price': 139999.0, 'updatedAt': Timestamp.now(), 'note': 'Launch price'},
    ],
  },
  {
    'name': 'Wireless Headphones',
    'shopId': 'shop2',
    'shopName': 'Tech Town',
    'description': 'Noise-cancelling Bluetooth headphones with 30h battery.',
    'price': 3499.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/rmPQgrm44TPBbmZbE74eZxokU94lqPj0yXx4qYYxSYQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/c2hvcGlmeS5jb20v/cHJvZHVjdHMvaGVh/ZHBob25lcy5qcGc',
    'stock': 30,
    'unit': '1 piece',
    'isActive': true,
    'isFeatured': false,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  },
];

// class OfferCard extends StatelessWidget {
//   final String shopName;
//   final String offerText;
//   final String category;
//   final String validTill;
//   final String imageUrl;
//   final VoidCallback onViewDetails;
//   final VoidCallback onNavigate;
//   final VoidCallback onGrabOffer;
//   final bool isNetworkImage; // <-- new optional parameter

//   const OfferCard({
//     super.key,
//     required this.shopName,
//     required this.offerText,
//     required this.category,
//     required this.validTill,
//     required this.imageUrl,
//     required this.onViewDetails,
//     required this.onNavigate,
//     required this.onGrabOffer,
//     this.isNetworkImage = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: SizedBox(
//                     height: 80,
//                     width: 80,
//                     child: isNetworkImage && imageUrl.isNotEmpty
//                         ? Image.network(
//                             imageUrl,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.image_not_supported),
//                               );
//                             },
//                           )
//                         : Image.asset(
//                             imageUrl.isNotEmpty ? imageUrl : 'assets/placeholder.png',
//                             fit: BoxFit.cover,
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         shopName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         offerText,
//                         style: TextStyle(
//                           color: Colors.green[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Category: $category",
//                         style: const TextStyle(color: Colors.black54),
//                       ),
//                       Text(
//                         "Valid Till: $validTill",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),
//             Divider(color: Colors.grey[300]),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _actionButton(icon: Icons.store, text: "View Details", onTap: onViewDetails),
//                 _actionButton(icon: Icons.navigation, text: "Navigate", onTap: onNavigate),
//                 _actionButton(icon: Icons.local_offer, text: "Grab Offer", onTap: onGrabOffer),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionButton({required IconData icon, required String text, required VoidCallback onTap}) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFFFC107),
//         foregroundColor: Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//         elevation: 2,
//       ),
//       icon: Icon(icon, size: 18),
//       label: Text(
//         text,
//         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
