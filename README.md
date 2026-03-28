<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38.6-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Architecture-Hexagonal-blueviolet" alt="Architecture">
  <img src="https://img.shields.io/badge/State_Management-BLoC%2FCubit-orange" alt="BLoC">
</p>

# 📐 Formula Scholar

> A beautifully crafted, open-source **formula reference app** for students — built with **Hexagonal Architecture**, **Clean Code**, and **enterprise-grade** engineering practices.

Formula Scholar helps students quickly look up, study, and master mathematical formulas across Algebra, Geometry, and more. Designed with swappable backends (local → Firebase → Supabase) and a premium UI.

---

## ✨ Features

- 📊 **Dashboard** — Mastery tracking, subject exploration, continue studying
- 📐 **Geometry** — Topics with progress tracking (Triangles, Circles, etc.)
- 📝 **Algebra Cheat Sheets** — Bookmarkable formula sections with tags and badges
- 👤 **Profile** — Stats, settings, dark mode toggle
- 🔌 **Backend-agnostic** — Swap between local, Firebase, Supabase, or REST with zero code changes

---

## 🏛️ Architecture

This project follows **Hexagonal Architecture (Ports & Adapters)** combined with **Clean Architecture** principles:

```
┌───────────────────────────────────────────────────────────┐
│  OUTER: Presentation (Widgets, Pages, Cubits)             │
│  OUTER: Infrastructure (Adapters — Local/Firebase/etc.)   │
│                                                           │
│  ┌───────────────────────────────────────────────────┐    │
│  │  INNER: Domain                                    │    │
│  │  ├── Entities (pure Dart, Equatable)              │    │
│  │  ├── Ports (abstract interfaces)                  │    │
│  │  │   ├── RepositoryPort (returns Result<T>)       │    │
│  │  │   └── DataSourcePort (raw data contract)       │    │
│  │  ├── Use Cases (single-responsibility)            │    │
│  │  └── Failures (sealed class hierarchy)            │    │
│  └───────────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────────────┘
```

### Key Principles
| Principle | Implementation |
|-----------|---------------|
| **SOLID** | Use Cases (SRP), Ports (ISP/DIP), Adapters (OCP/LSP) |
| **Dependency Rule** | All deps point inward: Adapters → Domain ← Presentation |
| **Result Type** | Sealed `Result<T>` (Success/Error) — no raw exceptions at boundaries |
| **Typed Failures** | Sealed `Failure` hierarchy (Server, Cache, Auth, Unexpected) |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants (strings, routes, assets, etc.)
│   ├── di/                 # Dependency injection (get_it + injectable)
│   ├── error/              # Failure types + Result<T> sealed classes
│   ├── router/             # go_router configuration + observers
│   ├── theme/              # Colors, text styles, theme data
│   └── utils/              # Logger, BlocObserver
│
├── features/
│   └── {feature}/
│       ├── domain/
│       │   ├── entities/   # Pure Dart models (Equatable)
│       │   ├── ports/      # Abstract interfaces (Repository + DataSource)
│       │   └── usecases/   # Single-responsibility business operations
│       ├── infrastructure/
│       │   ├── adapters/   # Backend implementations (local, firebase, etc.)
│       │   └── repositories/ # Port implementations wrapping adapters
│       └── presentation/
│           ├── cubit/      # State management (Cubit + State)
│           ├── pages/      # Screen widgets
│           └── widgets/    # Reusable UI components
│
└── shared/                 # Cross-feature widgets and utilities
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.38.6 |
| **Language** | Dart 3.10.7 |
| **State Management** | flutter_bloc (Cubit) |
| **Navigation** | go_router |
| **DI** | get_it + injectable |
| **Logging** | logger |
| **Architecture** | Hexagonal (Ports & Adapters) |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.38.0
- Dart SDK >= 3.10.0
- Android Studio / VS Code with Flutter extension

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-username/formula_scholar.git
cd formula_scholar

# 2. Install dependencies
flutter pub get

# 3. Generate DI code
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Environment Setup

```bash
# Copy the example env file
cp .env.example .env

# Edit with your configuration
# (Not needed for local/development — the app runs with hardcoded data by default)
```

---

## 🔄 Swapping Backends

The app ships with a **local adapter** (hardcoded data). To integrate a real backend:

1. Create a new adapter implementing the `DataSourcePort`:
   ```dart
   @LazySingleton(as: DashboardDataSourcePort)
   @Environment('firebase')
   class DashboardFirebaseAdapter implements DashboardDataSourcePort { ... }
   ```

2. Add `@Environment('local')` to the existing local adapter

3. Regenerate DI:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Switch environment in `main.dart`:
   ```dart
   configureDependencies(environment: 'firebase');
   ```

> **Zero changes** to domain, use cases, cubits, or UI!

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate HTML coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🧹 Code Quality

```bash
# Static analysis
dart analyze lib

# Format code
dart format lib

# Check for outdated dependencies
flutter pub outdated
```

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

---

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a history of notable changes.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — State management
- [go_router](https://pub.dev/packages/go_router) — Declarative routing
- [get_it](https://pub.dev/packages/get_it) + [injectable](https://pub.dev/packages/injectable) — Dependency injection
- [equatable](https://pub.dev/packages/equatable) — Value equality
- [logger](https://pub.dev/packages/logger) — Structured logging
