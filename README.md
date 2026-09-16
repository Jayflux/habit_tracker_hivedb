# Habit Tracker (HiveDB)

<p align="center">
  <img src="assets/habit.png" alt="Habit Tracker Logo" width="120" />
</p>

<p align="center">
  A local-first, offline-capable habit tracking application built with <b>Flutter</b> and <b>Hive NoSQL Database</b>. Designed to help individuals cultivate consistency, build routines, and celebrate daily progress without reliance on external servers.
</p>

---

## Key Features

- **Daily Habit Tracking:** Easily create, edit, check off, and delete daily routines.
- **Activity Heatmap Calendar:** Visual representation of monthly consistency and completion intensity.
- **Swipe-to-Manage:** Quick swipe actions on habit cards to modify names or delete entries.
- **Daily Reminders & Overview:** Dedicated views to track pending tasks for today and preview upcoming schedules.
- **History & Streaks:** Chronological view of past habit completions organized by date.
- **Light & Dark Mode:** Built-in theme switch accessible via the navigation drawer.
- **Offline-First Storage:** High-performance local persistence using Hive boxes, ensuring fast access without network dependencies.
- **Responsive Layout:** Optimized for cross-platform usage across Google Chrome (Web), macOS Desktop, Android, and iOS.
- **User & Admin Management:** Supports multiple local user accounts with administrative capabilities.

---

## Tech Stack

| Component | Technology |
|---|---|
| **Framework** | Flutter (Channel stable, Material 3) |
| **Language** | Dart (>= 3.6.0) |
| **Local Database** | Hive & Hive Flutter (Lightweight NoSQL key-value store) |
| **State Management** | ValueNotifier & StatefulWidget |
| **UI Components** | `flutter_heatmap_calendar`, `flutter_slidable`, `cupertino_icons` |
| **Date & Time** | `intl` |

---

## Project Structure

```text
habit_tracker/
├── assets/                  # Brand assets and member avatars
├── lib/
│   ├── components/          # Reusable UI widgets (HabitTile, MonthlySummary, Drawer, etc.)
│   ├── data/                # Hive database helper and local operations
│   ├── datetime/            # Date formatting and conversion utilities
│   ├── models/              # Hive model adapters (Habit, User)
│   ├── pages/               # Application screens (Home, Login, Register, History, etc.)
│   │   └── admin/           # Admin dashboard and user management pages
│   ├── theme/               # Centralized design tokens and theme configuration
│   └── main.dart            # Application entry point and theme provider
├── pubspec.yaml             # Dependencies and Flutter configurations
└── DESIGN.md                # Brand style and design direction documentation
```

---

## Getting Started

### Prerequisites

- Flutter SDK (version 3.27 or higher recommended)
- CocoaPods (required for macOS desktop and iOS targets)
- Google Chrome (for running web target)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Jayflux/habit_tracker_hivedb.git
   cd habit_tracker_hivedb
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters (if needed):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## Running the Application

### Google Chrome (Web)
```bash
flutter run -d chrome
```

### macOS Desktop
```bash
flutter run -d macos
```

### iOS Simulator / Android Emulator
```bash
flutter run
```

---

## Development Team

This application was developed as a collaborative project by:

- **Rayssa Modelline .J.S** (NIM: 2310511151)
- **Muhamad Najwan** (NIM: 2310511149)
- **Abdul Faris Aufar** (NIM: 2310511154)
- **Daniel Hemas .M.S** (NIM: 2310511162)
- **Aqiel Syafiq Rahman** (NIM: 2310511139)

---

## License

This project is released for educational and personal use under the standard project terms.
