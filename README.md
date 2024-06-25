<img src="https://github.com/16BitNarwhal/ScoreSwipe/assets/132689272/2a77e24d-60dd-486b-aec9-4265365497b5" alt="logo image" width="150" height="150">

# ScoreSwipe

![Tests](https://img.shields.io/circleci/project/github/badges/shields/master)
![Code Size](https://img.shields.io/github/languages/code-size/16bitnarwhal/scoreswipe)
![GitHub issues](https://img.shields.io/github/issues/16bitnarwhal/scoreswipe)
![GitHub contributors](https://img.shields.io/github/contributors/16bitnarwhal/scoreswipe)
![GitHub last commit](https://img.shields.io/github/last-commit/16bitnarwhal/scoreswipe)

Ever wanted to play a piece of music but you don't have enough hands to turn the page? Look no further! With **ScoreSwipe**, you can flip through the pages of your digital sheet music effortlessly by ~~using your mind~~ simply tilting your head.

# Table of Contents

- [ScoreSwipe](#scoreswipe)
- [Table of Contents](#table-of-contents)
- [⭐ About](#-about)
  - [🌱 Features](#-features)
  - [📱 Screenshots](#-screenshots)
- [💻 For Developers](#-for-developers)
  - [🛠️ Setup](#️-setup)
  - [📐 Project Structure](#-project-structure)
  - [🖼️ Presentation](#️-presentation)
  - [📱 Business logic](#-business-logic)
  - [📝 Models](#-models)
  - [📦 Data](#-data)
  - [🧪 Testing](#-testing)
- [Extra](#extra)
  - [🙏 Acknowledgements](#-acknowledgements)

# ⭐ About

ScoreSwipe is a unique and innovative application that leverages computer vision technology to simplify the experience of reading sheet music. With ScoreSwipe, you can flip through the pages of your digital sheet music effortlessly by simply tilting your head.

## 🌱 Features

1. **Hands-Free Page Flipping:** Tilt your head left to flip the page backward and right to flip the page forward.
2. **Digital Sheet Creation:** Upload your own PDFs, photos from your gallery, or take and crop photos from within the app.
3. **Customizable Sensitivity:** Adjust the sensitivity of head tilts to match your preferences.

## 📱 Screenshots

<p float="left">
  <img src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/5525b36a-200b-4a1e-96fb-092c7f267618" width="24%">
  <img src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/f574ab3c-0da4-4736-8bf0-faeefb8ab367" width="24%">
  <img src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/c3fc7759-1b5c-4b7b-ab65-22acce423676" width="24%">
  <img src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/a44cc3fa-d90b-4f7d-a628-d58d414242ff" width="24%">
</p>

Create & Navigate Score | Edit & Delete Score
:-: | :-:
<video src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/33e26ffc-5fcd-46d9-9042-b742e4df46cc"/> | <video src="https://github.com/16BitNarwhal/ScoreSwipe/assets/31218485/cf3e4fee-d5c2-48d2-bac4-7bb78f6aecd0"/>


# 💻 For Developers

The application is entirely built using [Flutter](https://flutter.dev/), a cross-platform UI toolkit for building applications for mobile, web, and desktop from a single codebase. Flutter uses the [Dart](https://dart.dev/) programming language.

## 🛠️ Setup

1. Install [Flutter](https://flutter.dev/docs/get-started/install)
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to run the app
5. Run `flutter test` to run the tests
6. Run `flutter build apk` to build the apk

## 📐 Project Structure

Important files and directories:

```bash
.
├── assets # Static assets (eg. logo)
├── fonts # Custom fonts
├── lib # Source files. Contains all the logic for the app.
│   ├── main.dart # Entry point for the app
│   ├── common # Common files used throughout the app
│   │  ├── data # Deals with fetching and storing data
│   │  └── models # Data models
│   ├── features # Contains the separate features of the app (UI and logic)
│   │  ├── score_browser # Browser for viewing and selecting scores
│   │  ├── score_creator # Editor for creating new scores
│   │  └── score_viewer # Displays score and handles page flipping
├── test # Automated tests. Consists of unit tests
├── pubspec.yaml # Contains all the dependencies for the app
└── README.md # This file

```

## 🖼️ Presentation

The **user interface** is in `lib/features`. Each feature is contained in its own directory and consists of screen(s) and/or widgets. The UI layer is responsible for communicating with the business logic layer.

_note: not all the logic and UI is completely separated_

## 📱 Business logic

The **business logic** is also contained in `lib/features`. When state management becomes complex, we switch to blocs (using the [Business Logic Component pattern](https://bloclibrary.dev/)). Complex features consist of a `bloc` and `event` and `state` classes. The `bloc` class contains the business logic and the `event` and `state` classes are used to communicate with the `bloc`. The `bloc` class is also responsible for communicating with the data layer through the repositories.

## 📝 Models

**Models** are in `lib/common/models`. This folder contains the data models used throughout the app. Currently there is only one model, `Score`, which represents a score.

## 📦 Data

**Data** is handled in `lib/common/data`. This folder contains the logic for fetching and storing data. The repositories are responsible for communicating with the data sources. The data sources are responsible for fetching and storing data from the respective sources: local database with the Flutter SQLite plugin [sqflite](https://pub.dev/packages/sqflite) and local filestorage with `dart:io` and [path_provider](https://pub.dev/packages/path_provider).

## 🧪 Testing

**Tests** are in `test`. Currently, there are only unit tests that test the models and datasources. The tests are run using the [Flutter test](https://flutter.dev/docs/testing) framework.

## 🙂 Facial Gesture Tracking
The gesture tracking leverages ML Kit's face detection API for precise landmarking and rotational information. When the user's head rotation surpasses a predefined threshold, the app flips to the next page. The app waits for the user's head to return below the threshold to reset the process.

# Extra

## 🙏 Acknowledgements

[@floofysaur](https://www.github.com/floofysaur) - User Interface and Logo Design
