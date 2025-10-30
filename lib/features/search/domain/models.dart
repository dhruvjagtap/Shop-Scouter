// lib/features/search/domain/models.dart
// class Shop {
//   final String id;
//   final String name;
//   final String category;
//   final double rating;
//   final String imageUrl;

//   const Shop({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.rating,
//     required this.imageUrl,
//   });

//   factory Shop.fromMap(String id, Map<String, dynamic> data) {
//     return Shop(
//       id: id,
//       name: data['name'] ?? '',
//       category: data['category'] ?? '',
//       rating: (data['rating'] ?? 0).toDouble(),
//       imageUrl: data['imageUrl'] ?? '',
//     );
//   }
// }

// class Product {
//   final String id;
//   final String name;
//   final String shopId;
//   final String shopName;
//   final double price;
//   final String imageUrl;

//   const Product({
//     required this.id,
//     required this.name,
//     required this.shopId,
//     required this.shopName,
//     required this.price,
//     required this.imageUrl,
//   });

//   factory Product.fromMap(String id, Map<String, dynamic> data) {
//     return Product(
//       id: id,
//       name: data['name'] ?? '',
//       shopId: data['shopId'] ?? '',
//       shopName: data['shopName'] ?? '',
//       price: (data['price'] ?? 0).toDouble(),
//       imageUrl: data['imageUrl'] ?? '',
//     );
//   }
// }

// lib/features/search/domain/models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Opening hours for a single day
class OpeningHours {
  final bool closed;
  final String? open; // "09:00"
  final String? close; // "21:30"

  OpeningHours({required this.closed, this.open, this.close});

  factory OpeningHours.fromMap(Map<String, dynamic>? m) {
    if (m == null) return OpeningHours(closed: true);
    return OpeningHours(
      closed: m['closed'] ?? false,
      open: m['open'],
      close: m['close'],
    );
  }

  Map<String, dynamic> toMap() => {
    'closed': closed,
    'open': open,
    'close': close,
  };
}

/// Weekly schedule keyed by weekday short names, e.g. "mon", "tue", ...
class WeeklySchedule {
  final Map<String, OpeningHours> days;
  WeeklySchedule({required this.days});

  factory WeeklySchedule.fromMap(Map<String, dynamic>? m) {
    final defaultDays = <String, OpeningHours>{};
    if (m == null) {
      for (var d in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']) {
        defaultDays[d] = OpeningHours(closed: true);
      }
      return WeeklySchedule(days: defaultDays);
    }
    final map = <String, OpeningHours>{};
    m.forEach((k, v) {
      map[k] = OpeningHours.fromMap((v as Map<String, dynamic>?));
    });
    return WeeklySchedule(days: map);
  }

  Map<String, dynamic> toMap() {
    final out = <String, dynamic>{};
    days.forEach((k, v) => out[k] = v.toMap());
    return out;
  }
}

/// Review model (usable for product or shop reviews)
class Review {
  final String id;
  final String userId;
  final String userName;
  final double rating; // 1.0 - 5.0
  final String? comment;
  final Timestamp createdAt;
  final String? productId; // optional: review for a product
  final String? shopId; // optional: review for a shop

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.productId,
    this.shopId,
  });

  factory Review.fromMap(String id, Map<String, dynamic> data) {
    return Review(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      productId: data['productId'],
      shopId: data['shopId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt,
    'productId': productId,
    'shopId': shopId,
  };
}

/// Offer / deal model
class Offer {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? productId; // optional: target product
  final Timestamp startAt;
  final Timestamp endAt;
  final bool isActive;
  final String discountType; // 'percentage' | 'fixed'
  final double discountValue; // e.g. 10.0 means 10% or 10 currency units
  final Map<String, dynamic>? terms;

  Offer({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.productId,
    required this.startAt,
    required this.endAt,
    required this.isActive,
    required this.discountType,
    required this.discountValue,
    this.terms,
  });

  factory Offer.fromMap(String id, Map<String, dynamic> data) {
    return Offer(
      id: id,
      title: data['title'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      productId: data['productId'],
      startAt: data['startAt'] ?? Timestamp.now(),
      endAt: data['endAt'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? true,
      discountType: data['discountType'] ?? 'fixed',
      discountValue: (data['discountValue'] ?? 0).toDouble(),
      terms: (data['terms'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'productId': productId,
    'startAt': startAt,
    'endAt': endAt,
    'isActive': isActive,
    'discountType': discountType,
    'discountValue': discountValue,
    'terms': terms,
  };
}

/// Price history entry (useful if you want to show price changes / compare)
class PriceHistoryEntry {
  final double price;
  final Timestamp updatedAt;
  final String? note; // optional reason for change

  PriceHistoryEntry({required this.price, required this.updatedAt, this.note});

  factory PriceHistoryEntry.fromMap(Map<String, dynamic> m) {
    return PriceHistoryEntry(
      price: (m['price'] ?? 0).toDouble(),
      updatedAt: m['updatedAt'] ?? Timestamp.now(),
      note: m['note'],
    );
  }

  Map<String, dynamic> toMap() => {
    'price': price,
    'updatedAt': updatedAt,
    'note': note,
  };
}

/// Owner / manager of a shop
class ShopOwner {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? profileImage;

  ShopOwner({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.profileImage,
  });

  factory ShopOwner.fromMap(String id, Map<String, dynamic> m) {
    return ShopOwner(
      id: id,
      name: m['name'] ?? '',
      email: m['email'],
      phone: m['phone'],
      profileImage: m['profileImage'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
  };
}

/// Shop document - comprehensive
class Shop {
  final String id;
  final String name;
  final String category; // e.g. 'grocery', 'electronics'
  final String? description;
  final String? imageUrl;
  final List<String> imageUrls;
  final String address; // human readable address
  final String? phone;
  final String? email;
  final GeoPoint location; // latitude/longitude
  final WeeklySchedule? hours;
  final bool isVerified;
  final bool isFeatured;
  final double ratingAvg; // aggregated rating average
  final int ratingCount; // number of ratings
  final int views; // simple analytics fields
  final int clicks;
  final ShopOwner? owner;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final Map<String, dynamic>? metadata; // flexible field for tags, extras

  Shop({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.address,
    this.phone,
    this.email,
    required this.location,
    this.hours,
    this.isVerified = false,
    this.isFeatured = false,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.views = 0,
    this.clicks = 0,
    this.owner,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory Shop.fromMap(String id, Map<String, dynamic> data) {
    return Shop(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      address: data['address'] ?? '',
      phone: data['phone'],
      email: data['email'],
      location: (data['location'] as GeoPoint?) ?? GeoPoint(0, 0),
      hours: WeeklySchedule.fromMap((data['hours'] as Map<String, dynamic>?)),
      isVerified: data['isVerified'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
      ratingAvg: (data['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (data['ratingCount'] ?? 0),
      views: (data['views'] ?? 0),
      clicks: (data['clicks'] ?? 0),
      owner: data['owner'] != null
          ? ShopOwner.fromMap(
              data['owner']['id'] ?? '',
              (data['owner'] as Map<String, dynamic>),
            )
          : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      metadata: (data['metadata'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'description': description,
    'imageUrl': imageUrl,
    'imageUrls': imageUrls,
    'address': address,
    'phone': phone,
    'email': email,
    'location': location,
    'hours': hours?.toMap(),
    'isVerified': isVerified,
    'isFeatured': isFeatured,
    'ratingAvg': ratingAvg,
    'ratingCount': ratingCount,
    'views': views,
    'clicks': clicks,
    'owner': owner?.toMap(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'metadata': metadata,
  };
}

/// Product document - comprehensive
class Product {
  final String id;
  final String name;
  final String shopId;
  final String shopName;
  final String? description;
  final double price;
  final String currency; // e.g. "INR", "USD"
  final String? imageUrl;
  final List<String> imageUrls;
  final int stock; // number of units available; use -1 for unlimited / unknown
  final String? unit; // e.g. "500g", "1 liter", "pcs"
  final String? sku;
  final String? barcode;
  final bool isActive;
  final bool isFeatured;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  final List<Map<String, dynamic>>
  priceHistory; // list of PriceHistoryEntry maps
  final Map<String, dynamic>? metadata;

  Product({
    required this.id,
    required this.name,
    required this.shopId,
    required this.shopName,
    this.description,
    required this.price,
    this.currency = 'INR',
    this.imageUrl,
    this.imageUrls = const [],
    this.stock = -1,
    this.unit,
    this.sku,
    this.barcode,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.priceHistory = const [],
    this.metadata,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? '',
      description: data['description'],
      price: (data['price'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'INR',
      imageUrl: data['imageUrl'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      stock: (data['stock'] ?? -1),
      unit: data['unit'],
      sku: data['sku'],
      barcode: data['barcode'],
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      priceHistory: List<Map<String, dynamic>>.from(data['priceHistory'] ?? []),
      metadata: (data['metadata'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'shopId': shopId,
    'shopName': shopName,
    'description': description,
    'price': price,
    'currency': currency,
    'imageUrl': imageUrl,
    'imageUrls': imageUrls,
    'stock': stock,
    'unit': unit,
    'sku': sku,
    'barcode': barcode,
    'isActive': isActive,
    'isFeatured': isFeatured,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'priceHistory': priceHistory,
    'metadata': metadata,
  };
}
