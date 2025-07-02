# MovieAppUIKit

A simple iOS application built using **UIKit**, **MVVM architecture**, and **Coordinator pattern**, demonstrating:

- Movie list and detail screens
- Asynchronous networking using `async/await`
- Dependency injection via protocols
- Navigation handled via Coordinator (not in ViewControllers)
- Unit tests for all key components
- Follows SOLID principles

## 🧱 Architecture Overview

```
+------------------+        +---------------------+        +---------------------------+
|   ViewModel      | -----> |     Coordinator      | -----> |  ViewControllers (UI)     |
| (No UIKit code)  |        |  (Handles Navigation)|        | (No navigation logic)     |
+------------------+        +---------------------+        +---------------------------+
        ↑                                                            ↓
        |                                                    User Interactions
        +----------------------------------------------------+
```

## 📂 Folder Structure

```
MovieAppUIKit/
├── Model/
│   └── Movie.swift
├── Services/
│   ├── MovieServiceProtocol.swift
│   └── MovieService.swift
├── ViewModels/
│   ├── MovieListViewModel.swift
│   └── MovieDetailViewModel.swift
├── ViewControllers/
│   ├── MovieListViewController.swift
│   └── MovieDetailViewController.swift
├── Coordinator/
│   └── MovieCoordinator.swift
├── SceneDelegate.swift
├── Tests/
│   └── MovieAppTests.swift
└── README.md
```

## 🚀 Getting Started

1. Clone the repository
2. Open the `.xcodeproj` file in Xcode
3. Make sure your `SceneDelegate.swift` loads the `MovieCoordinator`
4. Run the app on Simulator or Device

## ✅ Features

- MVVM + Coordinator for scalable navigation
- Uses `async/await` for modern networking
- Testable with mock services
- Unit tests written using `XCTest`

## 🧪 Run Tests

1. Open Xcode
2. `⌘ + U` to run all tests
3. Or navigate to Product > Test

## 📜 License

MIT License. Free to use and modify.
