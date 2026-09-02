<div align="center">

# CHEFAA HEALTHCARE PLATFORM

### An AI-assisted healthcare app, built with Flutter

*Connecting Patients, Doctors, Pharmacies, and Facilities in one seamless mobile experience.*

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State_Management-BLoC%2FCubit-4285F4?style=for-the-badge)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![REST API](https://img.shields.io/badge/REST-API-FF6F00?style=for-the-badge)

</div>

<br>

## About the Project

**Chefaa** is a Flutter mobile application that brings together four types of healthcare users — **Patients, Doctors, Pharmacies, and Facilities** — into a single, role-aware app. It consumes a REST backend to handle authentication, appointments, prescriptions, pharmacy orders, and facility discovery, while the Flutter layer focuses on a fast, clean, and localized native experience.

The app is built on a **feature-based architecture**, with dedicated modules per user role, shared infrastructure for cross-cutting concerns like file handling, and dependency injection wiring everything together.

<br>

---

## Feature Overview

<table>
<tr>
<td width="50%" valign="top">

### Onboarding & Entry
- App entry / splash flow
- Onboarding walkthrough
- Multi-language support (Arabic / English)

### Authentication
- Registration & login
- OTP verification
- Google Sign-In
- Email validation
- Forgot / reset password
- Secure session storage

### Doctor Module
- Doctor-specific dashboard and screens
- Clinic and appointment management
- Data visualization for schedules / analytics

</td>
<td width="50%" valign="top">

### Patient Module
- Patient-specific dashboard and screens
- Appointment booking with a calendar picker
- Document / medical report uploads

### Pharmacy Module
- Pharmacy-specific dashboard and screens
- Order and inventory-related views

### Facility Discovery
- Map-based facility & clinic browsing
- Current location detection
- Geocoding and location permissions
- Custom map markers for facility pins

### Shared File Handling
- Centralized file picking & upload state
- Reused across patient, doctor & pharmacy modules

</td>
</tr>
</table>

<br>

---

## Tech Stack

| Category | Packages Used |
|---|---|
| **Framework** | Flutter, Dart |
| **State Management** | `flutter_bloc` |
| **Dependency Injection** | `get_it`, `injectable` |
| **Networking** | `dio`, `dart_either` (functional error handling) |
| **Routing** | `go_router` |
| **Local Storage** | `shared_preferences`, `flutter_secure_storage`, `hive`, `hive_flutter` |
| **Firebase** | `firebase_core` |
| **Authentication** | `google_sign_in`, `email_validator`, `flutter_otp_text_field` |
| **Maps & Location** | `google_maps_flutter`, `geolocator`, `geocoding`, `permission_handler`, `widget_to_marker` |
| **Charts & Data Viz** | `fl_chart`, `syncfusion_flutter_gauges` |
| **Scheduling** | `syncfusion_flutter_datepicker` |
| **File Handling** | `file_picker` |
| **UI & UX** | `flutter_screenutil`, `flutter_svg`, `dotted_border`, `animated_snack_bar`, `animated_toggle`, `material_symbols_icons`, `flutter_markdown`, `cupertino_icons` |
| **Localization** | `easy_localization`, `intl` |
| **Splash & Icons** | `flutter_native_splash`, `flutter_launcher_icons` |
| **Code Generation** | `build_runner`, `injectable_generator`, `hive_generator` |

<br>

---

## Architecture

Chefaa follows a **feature-based clean architecture**, with one module per user role and shared infrastructure kept separate from feature logic.

```text
lib/
├── core/
│
├── features/
│   ├── auth/
│   ├── doctor/
│   ├── entry/
│   │   └── presentation/
│   │       └── pages/
│   ├── facility/
│   ├── onboarding/
│   ├── patient/
│   └── pharmacy/
│
├── shared/
│   └── file_handler/
│       └── presentation/
│           └── manager/
│               ├── file_handler_cubit.dart
│               └── file_handler_state.dart
│
├── chefaa.dart
├── firebase_options.dart
└── main.dart
```

### State Management

State is managed with **BLoC/Cubit** (`flutter_bloc`), scoped per feature. Shared, cross-feature logic — like file uploads used across the Patient, Doctor, and Pharmacy modules — lives in `shared/`, so it isn't duplicated per role.

`FileHandlerCubit`, for example, centralizes file picking and upload state (`file_handler_cubit.dart` / `file_handler_state.dart`), and is reused wherever a screen needs to attach documents, reports, or images.

Dependencies are wired through **GetIt** and **Injectable**, with code generation handled by `build_runner`.

<br>

---

## Application Flow

<div align="center">

**Entry / Splash**  →  **Onboarding**  →  **Authentication**
→  **Role-Based Home** (Patient / Doctor / Pharmacy)  →  **Facility Discovery**
→  **Appointments / Orders**  →  **Documents & Reports**

</div>

<br>

---

## API Integration

The app communicates with the Chefaa backend over REST, using **Dio** for networking and `dart_either` to model success/failure results cleanly through the data and domain layers. Firebase (`firebase_core`) is initialized via `firebase_options.dart`, laying the groundwork for platform services such as push notifications.

<br>

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.8`
- A configured Firebase project (`firebase_options.dart` is already generated via FlutterFire CLI)

Verify your Flutter installation:

```bash
flutter doctor
```

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/your-username/chefaa.git
```

**2. Navigate into the project**

```bash
cd chefaa
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Generate injectable / hive code**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**5. Run the app**

```bash
flutter run
```

<br>

---

## Project Goals

This project was built to:

- Build a complete, role-based healthcare app using Flutter
- Practice scalable state management with BLoC/Cubit across multiple user roles
- Structure shared logic (like file handling) separately from per-role features
- Integrate maps and location services for real-world facility discovery
- Apply dependency injection and code generation for a maintainable codebase
- Support full localization across the app
- Apply clean, feature-based architecture end to end

<br>

---

## License

This project was developed as a **Graduation Project** at the Faculty of Computers and Information, Menoufia University.

<br>

---

<div align="center">

## Developer

**[Abdullah Esmail and Eman Medhat]**

*Flutter Developer | Computer Science Graduate*

</div>
