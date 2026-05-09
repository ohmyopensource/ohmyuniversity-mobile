# OhMyUniversity! - Mobile

This repository contains the **mobile frontend of OhMyUniversity!**, implemented in Flutter.
It manages all **UI components, screens, client-side logic, and integration with the backend API**.

> **Note:** This repository does **not** contain backend business logic, architecture documentation, or organizational guidelines.

## Documentation

For full documentation of the application architecture, frontend design patterns, and system structure, see the **OhMyUniversity! Docs** repository:
[Architecture Documentation](https://github.com/ohmyopensource/ohmyuniversity-docs/tree/main/docs/architecture)

## Guidelines

For any additional information, contribution rules, code of conduct, and organizational standards, refer to the **OhMyOpenSource! Guidelines** repository:
[Guidelines](https://github.com/ohmyopensource/ohmyopensource-guidelines)

---

## Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (riverpod, freezed, json_serializable)
dart run build_runner build

# 3. Run the app
flutter run
```

For active development with auto-regeneration:
```bash
dart run build_runner watch
```

---

## Project Structure

```
lib/
├── main.dart                    # Entry point — ProviderScope
├── app.dart                     # Root widget — MaterialApp.router
│
├── core/                        # Code shared across all features
│   ├── constants/
│   │   └── app_constants.dart   # Padding, radius, durations, timeouts
│   ├── error/
│   │   ├── exceptions.dart      # Technical exceptions (Data Layer)
│   │   └── failures.dart        # Domain errors (Domain Layer)
│   ├── network/                 # Dio client, interceptors
│   ├── usecases/
│   │   └── usecase.dart         # Base UseCase<T, P> interface
│   └── utils/                   # Helpers, extensions, formatters
│
├── config/
│   ├── env/                     # Environment variables (envied)
│   ├── routes/
│   │   ├── app_router.dart      # GoRouter — route definitions
│   │   └── app_routes.dart      # Path and route name constants
│   └── theme/
│       ├── app_colors.dart      # Semantic colors
│       └── app_theme.dart       # ThemeData light + dark (Material3)
│
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── data_sources/    # AuthRemoteDataSource (flutter_appauth)
    │   │   ├── models/          # UserModel (freezed + json_serializable)
    │   │   └── repositories/    # AuthRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/        # User entity (freezed)
    │   │   ├── repositories/    # AuthRepository (interface)
    │   │   └── usecases/        # LoginUseCase, LogoutUseCase
    │   └── presentation/
    │       ├── pages/           # LoginPage
    │       ├── providers/       # authStateProvider (riverpod)
    │       └── widgets/
    │
    └── home/
        └── presentation/
            ├── pages/           # HomePage
            ├── providers/
            └── widgets/
```

---

## Tech Stack

| Area | Package |
|---|---|
| State Management + DI | flutter_riverpod + riverpod_generator |
| Navigation | go_router |
| HTTP | dio |
| SSO Auth | flutter_appauth |
| Token storage | flutter_secure_storage |
| Immutable models | freezed + json_serializable |
| Environment | envied |
| Calendar | kalender |
| Charts | fl_chart |
| Timeline | timelines_plus |
| Skeleton loading | skeletonizer |
| Swipe actions | flutter_slidable |
| Toast | toastification |
| Animations | animations |