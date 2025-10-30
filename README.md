🛍️ ShopScouter (MVP)

ShopScouter is a hyperlocal marketplace app that connects customers with nearby shops, helping them discover, compare, and save on everyday products.
Built with Flutter + Firebase, it bridges the gap between local businesses and digital convenience, empowering users to find the best deals in their area — while supporting small shop owners.

🎯 Key Features
👤 User Features

🧭 Shop Discovery: Location-based search for nearby shops.

💸 Price Comparison: Compare product prices across multiple shops.

🎁 Exclusive Offers: View ongoing deals and seasonal discounts.

🏪 Shop Details: Address, timings, contact info, and navigation links.

⭐ Favorites & Reviews: Save favorite shops and post simple ratings.

🛒 Shop Owner Features

📝 Shop Registration: Easy onboarding and verification process.

📦 Product Listings: Add products, prices, and manage inventory.

🔔 Deal Management: Create offers and featured listings.

📊 Shop Analytics: Get insights on customer engagement and shop views.

⚙️ Core Features

📍 Geolocation Integration: Show shops based on user’s current location.

🔔 Notifications: Personalized alerts for nearby deals.

🧑‍💻 Admin Dashboard (Web): Manage shops, verify users, and monitor activity.

🧱 Tech Stack
Layer	Tech Used
Frontend	Flutter (Dart)
Backend	Firebase (Auth, Firestore, Storage)
State Mgmt	Riverpod / Provider
APIs	Google Maps API (Geolocation)
Tooling	GitHub, VS Code, Flutter DevTools
🏗️ Current Progress

 Firebase Setup

 User Authentication (Register / Login)

 Splash Screen + Loader

 Home Screen UI with Shop Cards

 Shop Detail Screen

 Offers Screen

 Profile Screen

 Search Functionality

 Admin Dashboard (Web Version)

🚀 Getting Started
1. Clone the Repo
git clone https://github.com/dhruvjagtap/ShopScouter.git
cd shopscouter

2. Install Dependencies
flutter pub get

3. Run the App
flutter run

🗺️ Roadmap

✅ MVP Authentication & Shop Discovery

🔄 Price Comparison UI + Filtering

🎁 Offers & Deals Section

🧩 Shop Details & Review System

📍 Location-based Recommendations

🧑‍💻 Admin Dashboard for Shop Verification

📦 Play Store Release (Phase 1 MVP)

💡 Future Enhancements

💰 Shop Subscription Plans for Premium Features

🎯 AI-based Price Prediction & Deal Suggestions

🧠 Smart Search with Product Recommendations

🌐 Multilingual UI for Regional Markets

🔒 Secure Payment Gateway Integration

🧩 Folder Structure
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_service.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── home/
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       └── widgets/
│   │           ├── shop_card.dart
│   │           └── offer_banner.dart
│   ├── splash/
│   │   ├── splash_screen.dart
│   │   └── shop_scouter_loader.dart
│   └── theme/
│       └── presentation/
│           └── theme_provider.dart
├── firebase_options.dart
└── main.dart

📸 Demo Screenshots

Coming soon…

👥 Team Scouter

Dhruv Jagtap

Yashraj Kusale

Shravani Jagtap

Vaishnavi Gadghe

📜 License

This project is licensed under the MIT License — see the LICENSE
 file for details.