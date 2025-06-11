# 🛒 Flutter Auction App

A real-time auction mobile application built with **Flutter** and **Firebase**. Users can create auctions, bid on items, and see results in real time.

## 📲 Features

- User authentication (Firebase)
- Create/view auctions
- Live countdown timers
- Auto-refresh and bidding updates
- Firebase Firestore integration
- User balance and winner logic

---

## 🚀 Getting Started

Follow these steps to install and run the project on your local machine.

### ✅ Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter/Dart extensions
- A Firebase account

---

### 1. Clone the Repository
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME

### 2. Install Flutter Dependencies
flutter pub get

### 3. Setup Firebase
🔐 This project uses Firebase for auth and database. You must set up your own Firebase project.

  A. Create Firebase Project :
  - Go to Firebase Console
  - Click Add Project and follow the steps
  
  B. Add Platforms :
  - Add Android App
    -- Use your app's package name (e.g., com.example.auctionapp)
    --Download google-services.json
    --Place it in: android/app/google-services.json
  
  - Add iOS App (if needed)
    --Download GoogleService-Info.plist
    --Place it in: ios/Runner/GoogleService-Info.plist
  
  C. Configure with FlutterFire CLI (optional but recommended) :
    dart pub global activate flutterfire_cli
    flutterfire configure
  
  ### 4.Run the App
  flutter run

