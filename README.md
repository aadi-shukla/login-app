# 🚀 Flutter Auth & Profile Manager

A modern, professional Flutter application featuring robust Firebase authentication, real-time Firestore integration, and a sleek user interface for profile management.

---

## ✨ Features

- **🔐 Secure Authentication**: Full Sign In and Sign Up flows powered by Firebase Auth.
- **📱 Responsive UI**: Beautifully crafted screens for Home, Explore, Profile, and Settings.
- **👤 Profile Management**: Detailed user profile viewing and editing capabilities.
- **📁 Real-time Database**: User data synchronization using Cloud Firestore.
- **🖼️ Image Uploads**: Profile picture updates with a seamless image picker integration.
- **🧭 Intuitive Navigation**: Modern bottom tab bar for easy app exploration.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.5.0)
- **Backend**: [Firebase](https://firebase.google.com/)
  - **Auth**: Firebase Authentication
  - **Database**: Cloud Firestore
- **UI Components**: Material Design & Custom Vanilla CSS-inspired styling
- **Assets**: SVG integration and custom typography (Inter)

## 📁 Project Structure

```text
lib/
├── assets/          # SVG icons and custom fonts
├── core/            # Core utilities and shared components
└── features/        # Feature-based modular architecture
    ├── auth/        # Authentication logic and screens
    ├── explore/     # App discovery features
    ├── home/        # User dashboard
    ├── navigation/  # Main shell and tab management
    ├── profile/     # Profile viewing and editing
    └── settings/    # Application configurations
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase Account and Project

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd login
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Create a project on the [Firebase Console](https://console.firebase.google.com/).
   - Add Android/iOS apps and download `google-services.json` / `GoogleService-Info.plist`.
   - Run `flutterfire configure` to update `firebase_options.dart`.

4. **Run the app**:
   ```bash
   flutter run
   ```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](<repository-url>/issues).

## 📄 License

This project is licensed under the MIT License.
