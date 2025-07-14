# Employee Directory App

A Flutter application built with Clean Architecture, Bloc pattern, and Hive for local storage. The app allows users to view, add, and manage employee information with offline support.

## Features

- **Employee List**: View all employees with a modern, card-based UI
- **Employee Details**: Detailed view of individual employee information
- **Add Employee**: Add new employees with form validation
- **Offline Support**: View employees from local storage when offline
- **Online Sync**: Automatically syncs with the API when internet is available
- **Error Handling**: Graceful error handling with retry functionality
- **Loading States**: Beautiful loading animations with shimmer effects

## Architecture

This app follows Clean Architecture principles with the following layers:

### Domain Layer
- **Entities**: Core business objects (Employee)
- **Use Cases**: Business logic (GetEmployees, CreateEmployee)
- **Repositories**: Abstract interfaces for data operations

### Data Layer
- **Models**: Data models with JSON serialization and Hive adapters
- **Data Sources**: Remote (API) and Local (Hive) data sources
- **Repository Implementation**: Concrete implementation of repositories

### Presentation Layer
- **Bloc**: State management using flutter_bloc
- **Pages**: UI screens (List, Details, Add)
- **Widgets**: Reusable UI components

### Core Layer
- **Network**: API client and constants
- **Error Handling**: Failure classes and error mapping
- **Dependency Injection**: Service locator pattern
- **Utils**: Hive initialization and other utilities

## Dependencies

### State Management
- `flutter_bloc`: ^8.1.6
- `equatable`: ^2.0.5
- `dartz`: ^0.10.1

### Local Storage
- `hive_ce`: ^2.11.3
- `hive_ce_flutter`: ^2.3.1
- `hive_ce_generator`: ^1.8.1

### Network & Connectivity
- `http`: ^1.2.2
- `connectivity_plus`: ^6.1.5

### UI Components
- `cached_network_image`: ^3.4.1
- `shimmer`: ^3.0.0

### Code Generation
- `json_annotation`: ^4.9.0
- `json_serializable`: ^6.8.0
- `build_runner`: ^2.4.13

## Getting Started

### Prerequisites
- Flutter SDK (3.27.4 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd employee_directory_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## API Integration

The app uses [ReqRes.in](https://reqres.in/) as a fake API for testing purposes. The API endpoints are:

- **GET /api/users**: Fetch all employees
- **POST /api/users**: Create a new employee

The API requires the `x-api-key: reqres-free-v1` header for authentication.

## Offline Functionality

- When offline, the app displays employees from local Hive storage
- Adding employees is disabled when offline with an appropriate error message
- Data is automatically synced when internet connection is restored

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── utils/
│   └── di/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## Key Features Implementation

### Clean Architecture
- Clear separation of concerns
- Dependency inversion
- Testable business logic

### Bloc Pattern
- Predictable state management
- Event-driven architecture
- Easy testing and debugging

### Hive Local Storage
- Fast NoSQL database
- Type-safe data storage
- Automatic serialization

### Error Handling
- Functional error handling with Either
- User-friendly error messages
- Graceful degradation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.