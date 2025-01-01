# Notes App

A simple and efficient **Notes App** built with **Flutter** and **Hive** for offline note management. This app allows you to create, update, delete, and view notes without any need for an internet connection.

## Features

- Add new notes with a title and body.
- Update existing notes easily.
- Delete notes when no longer needed.
- Fully offline storage with Hive database.
- Lightweight and fast.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Android Studio, Xcode, or VS Code (for development environment)

## Getting Started
  
Follow these instructions to get the project up and running on your local machine.

### Clone the Repository

```bash
git clone https://github.com/SubramanyaKS/NotesApp.git
cd NotesApp
```
### Install Dependencies

```bash
flutter pub get
```
### Setup Hive for the App

Initialize Hive by calling Hive.init() in the app's entry point (main.dart).
Generate Hive adapters for your data model (Note):

```bash
flutter packages pub run build_runner build
```

### Run the App
Start the app using the Flutter CLI:

```bash
flutter run
```

## Hive Database Schema

### `Note` Model

| Field    | Type   | Description                  |
|----------|--------|------------------------------|
| id       | int    | Unique index for each note   |
| title    | String | Title of the note            |
| body     | String | Content of the note          |
| priority | String | priority of the note         |
| created  | Date   | created date of the note     |

## Screenshots

Add some screenshots or GIFs of the app here to showcase its features.

## Packages Used

- **[Hive](https://pub.dev/packages/hive):** Lightweight and blazing-fast key-value database.
- **[Provider](https://pub.dev/packages/provider):** State management solution for Flutter.
- **[Hive Flutter](https://pub.dev/packages/hive_flutter):** Hive support for Flutter.

## License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

Happy Coding! 🚀