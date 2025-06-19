# 🌍 Countries Explorer

A beautiful Flutter application that allows users to explore countries around the world, view detailed information, and manage their favorite countries. Built with clean architecture, BLoC pattern, and modern Material Design 3.

## ✨ Features

### 🏠 Core Functionality
- **Countries List**: Browse all independent countries with real-time search
- **Country Details**: View comprehensive information including population, area, region, and time zones
- **Favorites System**: Add/remove countries to favorites with local storage
- **Real Flag Images**: High-quality flag images from REST Countries API
- **Dark/Light Theme**: Toggle between beautiful light and dark themes

### 🎨 UI/UX Features
- **Modern Design**: Material Design 3 with clean, intuitive interface
- **Hero Animations**: Smooth transitions between screens
- **Pull-to-Refresh**: Refresh countries data with pull gesture
- **Search with Debouncing**: Efficient real-time search functionality
- **Loading States**: Beautiful loading indicators and error handling
- **Responsive Layout**: Optimized for different screen sizes

### 🏗️ Technical Features
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **BLoC Pattern**: State management with flutter_bloc
- **Dependency Injection**: GetIt for dependency management
- **Local Storage**: SharedPreferences for favorites persistence
- **Network Handling**: Dio for HTTP requests with error handling
- **Offline Support**: Local caching and network connectivity awareness

## 📱 Screenshots

### Light Theme
- **Home Screen**: Countries list with search functionality
- **Country Details**: Comprehensive country information with large flag display
- **Favorites**: Saved countries with quick access

### Dark Theme
- **Seamless Theme Switching**: All screens adapt to dark mode
- **Eye-friendly Colors**: Carefully chosen dark theme palette

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator / iOS device or simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/countries-explorer.git
   cd countries-explorer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### 📱 Platform Setup

#### Android
Add internet permission in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS
Add network permissions in `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🏗️ Architecture

### Clean Architecture Layers
```
lib/
├── core/                   # Core functionality
│   ├── constants/         # App constants
│   ├── databases/         # API configuration
│   ├── errors/           # Error handling
│   ├── injection/        # Dependency injection
│   ├── network/          # Network utilities
│   ├── services/         # Core services
│   └── theme/            # App themes
├── features/             # Feature modules
│   ├── display_countries/
│   │   ├── data/         # Data layer (models, repositories, data sources)
│   │   ├── domain/       # Domain layer (entities, use cases, repositories)
│   │   └── presentation/ # Presentation layer (screens, widgets, BLoC)
│   └── favorites/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart            # App entry point
```

### State Management
- **BLoC Pattern**: Business Logic Components for state management
- **Event-Driven**: Reactive programming with streams
- **Separation of Concerns**: Clear separation between UI and business logic

## 📦 Dependencies

### Core Dependencies
```yaml
flutter_bloc: ^8.1.3          # State management
get_it: ^7.6.4                # Dependency injection
dio: ^5.3.2                   # HTTP client
dartz: ^0.10.1               # Functional programming
equatable: ^2.0.5            # Value equality
connectivity_plus: ^5.0.1    # Network connectivity
shared_preferences: ^2.2.2   # Local storage
```

### Development Dependencies
```yaml
flutter_test: ^1.0.0         # Testing framework
flutter_lints: ^2.0.0        # Linting rules
json_annotation: ^4.8.1      # JSON serialization
```

## 🌐 API Integration

### REST Countries API
- **Base URL**: `https://restcountries.com/v3.1/`
- **Endpoint**: `/independent?status=true&fields=name,population,flags,flag,area,region,subregion,timezones`
- **Features**: Real flag images, comprehensive country data
- **Rate Limiting**: Handled with proper error management

## 💾 Data Persistence

### Local Storage
- **Favorites**: Stored using SharedPreferences
- **JSON Serialization**: Custom models with toJson/fromJson
- **Data Integrity**: Proper error handling and validation

## 🎨 Theming

### Light Theme
- **Primary Color**: Blue (#2196F3)
- **Accent Color**: Pink (#E91E63)
- **Background**: Light gray (#FAFAFA)
- **Surface**: White (#FFFFFF)

### Dark Theme
- **Primary Color**: Light Blue (#64B5F6)
- **Accent Color**: Pink (#E91E63)
- **Background**: Dark (#121212)
- **Surface**: Dark Gray (#1E1E1E)

## 🧪 Testing

Run tests with:
```bash
flutter test
```

### Test Coverage
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete flows

## 🚀 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com/) for providing comprehensive country data
- [Flutter](https://flutter.dev/) for the amazing framework
- [Material Design](https://material.io/) for design guidelines
- [BLoC Library](https://bloclibrary.dev/) for state management patterns

## 📞 Support

If you have any questions or need help, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
