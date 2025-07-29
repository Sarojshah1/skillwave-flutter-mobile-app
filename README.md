# SkillWave - E-Learning Platform

<div align="center">
  <img src="assets/icons/appicon.png" alt="SkillWave Logo" width="120"/>
  <h3>Modern E-Learning Platform for Students and Tutors</h3>
  <p><strong>Semester 5 College Project</strong></p>
  <p><strong>Developed by: Saroj Kumar Sah</strong></p>
  <p><strong>Coventry ID: 14188846</strong></p>
  <p><strong>BSc (Hons) Computing</strong></p>
  <p><strong>Softwarica College of IT and E-Commerce</strong></p>
  <p><strong>Affiliated to Coventry University</strong></p>
</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [WebRTC Video Calling](#webrtc-video-calling)
- [API Documentation](#api-documentation)
- [User Roles](#user-roles)
- [Development Guide](#development-guide)
- [Deployment](#deployment)
- [Contributing](#contributing)

---

## 🎯 Overview

**SkillWave** is a comprehensive e-learning mobile application built with Flutter, designed to connect students and tutors through interactive courses, study groups, and real-time collaboration features, including **WebRTC video calling**. The app offers a seamless learning experience with a modern, responsive UI and robust backend integration.

---

## ✨ Features

### 🎓 For Students
- **Course Discovery**: Browse/search courses by category
- **Learning Management**: Track progress, access content, earn certificates
- **Study Groups**: Join/create groups for collaborative learning
- **Video Calling**: High-quality WebRTC video calls with screen sharing
- **Community**: Share posts, comment, interact with peers
- **Profile Management**: Achievements, certificates, and profile editing
- **Payment**: Secure checkout with eSewa, Khalti, and more

### 👨‍🏫 For Tutors
- **Course Creation**: Manage courses, lessons, and quizzes
- **Dashboard**: Analytics and performance tracking
- **Blog Management**: Create/manage educational content
- **Student Management**: Track student progress and engagement
- **Profile Management**: Professional profile with achievements

### 🌐 Shared Features
- **Authentication**: Secure login/signup, role-based access
- **Real-time Chat**: Live messaging in study groups
- **WebRTC Video Calls**: Peer-to-peer video communication
- **Blog System**: Educational content with PDF support
- **Responsive Design**: Works on Android, iOS, and desktop
- **Search & Filter**: Advanced course discovery

---

## 🛠️ Tech Stack

- **Flutter 3.x** (Dart) – Cross-platform mobile development
- **Dio** – HTTP client for API integration
- **Hive** – Local storage
- **Provider/Bloc** – State management
- **WebRTC** – Real-time video calling
- **Lottie** – Animations
- **Firebase** (optional) – Push notifications, analytics
- **eSewa/Khalti SDKs** – Payment integration

---

## 🏗️ Architecture

### Modular, Feature-Based Architecture

The project follows a **modular, feature-based architecture** for scalability and maintainability.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x recommended)
- Android Studio/Xcode (for emulators/simulators)
- Dart 3.x
- A device or emulator (Android/iOS)
- API backend (see `.env` or config files for endpoints)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd skillwave-flutter-mobile-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment**
   - Update API endpoints in `lib/config/constants/api_endpoints.dart` as needed.
   - Add any required keys for payment gateways or Firebase in the appropriate config files.

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Build for release**
   ```bash
   flutter build apk   # Android
   flutter build ios   # iOS
   ```

---

## 📁 Project Structure

```
lib/
├── app.dart
├── main.dart
├── config/
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   └── app_assets.dart
│   ├── di/
│   │   ├── di.container.config.dart
│   │   ├── di.container.dart
│   │   └── injection_module.dart
│   ├── routes/
│   │   ├── app_router.gr.dart
│   │   ├── route_guard.dart
│   │   └── app_router.dart
│   └── themes/
│       ├── app_text_styles.dart
│       ├── app_themes_color.dart
│       ├── extensions/
│       │   └── text_theme_extension.dart
│       ├── styles/
│       │   ├── button_theme.dart
│       │   ├── input_theme.dart
│       │   └── text_theme.dart
│       └── theme_bloc/
│           ├── theme_bloc.dart
│           ├── theme_event.dart
│           └── theme_state.dart
├── cores/
│   ├── common/
│   │   ├── common_scaffold.dart
│   │   └── common_snackbar.dart
│   ├── failure/
│   │   └── failure.dart
│   ├── network/
│   │   ├── auth_interceptor.dart
│   │   ├── dio_interseptors.dart
│   │   ├── dio_modules.dart
│   │   ├── hive_service.dart
│   │   ├── network_aware_app.dart
│   │   ├── models/
│   │   │   └── skillwave_response.dart
│   │   └── modules/
│   │       └── hive_modules.dart
│   ├── services/
│   │   ├── socket_service.dart
│   │   ├── api_service.dart
│   │   ├── biometric_service.dart
│   │   └── snackbar_service.dart
│   ├── shared_prefs/
│   │   ├── app_shared_prefs.dart
│   │   ├── shared_pref_key.dart
│   │   └── user_shared_prefs.dart
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositoryImpl/
│   │   ├── domian/
│   │   │   ├── entity/
│   │   │   ├── repository/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   ├── blogScreen/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── model/
│   │   │   └── repository/
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   └── repository/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   ├── coursesScreen/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   ├── model/
│   │   │   └── repository/
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   ├── repository/
│   │   │   └── usecase/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   ├── dashboardScreen/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   ├── domin/
│   │   │   ├── entity/
│   │   │   ├── repository/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── providers/
│   │       ├── screen/
│   │       ├── screens/
│   │       ├── utils/
│   │       └── widgets/
│   ├── homeScreen/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── constants/
│   │       ├── screens/
│   │       └── widgets/
│   ├── my-learnings/
│   │   ├── data /
│   │   ├── domain/
│   │   └── presentation/
│   ├── profileScreen/
│   │   ├── data/
│   │   ├── domin/
│   │   └── presentation/
│   ├── SettingScreen/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── study_groups/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── welcomescreens/
│       └── presentation/
├── assets/
│   ├── icons/
│   │   ├── appicon.png
│   │   ├── appiconlarge.png
│   │   ├── congrats.png
│   │   ├── credit-card.png
│   │   ├── esewa.png
│   │   ├── khalti.png
│   │   ├── paypal.png
│   │   └── splash.png
│   ├── images/
│   │   ├── onboarding1.png
│   │   ├── onboarding2.png
│   │   ├── onboarding3.png
│   │   ├── onboarding4.png
│   │   ├── onboarding5.png
│   │   └── profile.jpg
│   └── lottie/
│       ├── success.json
│       └── updated.json
```

---

## 📹 WebRTC Video Calling

SkillWave integrates **WebRTC** for real-time, peer-to-peer video calls within study groups.

**Features:**
- Peer-to-peer video/audio calls
- Screen sharing (where supported)
- Participant management
- Mute/unmute, camera toggle
- Connection quality monitoring
- Works on Android and iOS

**Technical Highlights:**
- Uses [flutter_webrtc](https://pub.dev/packages/flutter_webrtc) for media streams and peer connections
- Socket-based signaling for call setup
- ICE servers for NAT traversal
- Clean resource management and error handling

---

## 🔌 API Documentation

**Base URL:** See `lib/config/constants/api_endpoints.dart`

**Authentication:**
- `POST /user/login` – User login
- `POST /user/register` – User registration
- `GET /user/profile` – Get user profile

**Courses:**
- `GET /courses/pagination` – Get paginated courses
- `GET /courses/:id` – Get course by ID
- `POST /courses` – Create course (tutor only)

**Study Groups:**
- `GET /groupstudy` – List groups
- `POST /groupstudy/create` – Create group
- `POST /groupstudy/:groupId/addMember` – Join group

**Posts & Comments:**
- `GET /post` – List posts
- `POST /post` – Create post
- `POST /post/:id/comments` – Add comment

**Real-time Chat:**
- `POST /chats` – Send message
- `GET /chats/:context_id` – Get chat messages

---

## 👥 User Roles

### Student
- Browse/enroll in courses
- Access content, track progress
- Join study groups, participate in discussions
- Join video calls with screen sharing
- Community posts, profile management

### Tutor
- Create/manage courses
- Add lessons/quizzes
- View analytics, student progress
- Create blog posts, manage profile

**Authentication Flow:**
- Registration with multi-step profile setup
- Email/password login
- Role-based access and protected routes

---

## 🛠️ Development Guide

- **Code Style:** Follows Dart/Flutter best practices, with `analysis_options.yaml` for linting
- **State Management:** Bloc/Provider pattern
- **Naming:** PascalCase for classes, snake_case for files
- **Adding Features:** Create a new folder in `lib/features/`, follow modular structure

**Example: Adding a New Feature**
```
lib/features/new_feature/
├── data/
├── domain/
└── presentation/
```

---

## 🚀 Deployment

- **Android:** `flutter build apk`
- **iOS:** `flutter build ios`
- **Web:** (if enabled) `flutter build web`

**Environment Variables:**  
Configure API endpoints and keys in `lib/config/constants/` or use `.env` with [flutter_dotenv](https://pub.dev/packages/flutter_dotenv).

**WebRTC Production Considerations:**
- HTTPS required for WebRTC
- Configure STUN/TURN servers for production
- Monitor bandwidth and connection quality

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request. For major changes, open an issue first to discuss what you would like to change.

---

<div align="center">
  <p>Built by Saroj Kumar Sah</p>
  <p>BSc (Hons) Computing, Semester 5</p>
  <p>Softwarica College of IT and E-Commerce</p>
  <p>Affiliated to Coventry University</p>
</div>

---

**Note:** This project is for educational purposes as part of a college assignment.
