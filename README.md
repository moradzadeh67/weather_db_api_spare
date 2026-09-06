# 🌤️ SSD Weather App

A simple, clean, and junior-friendly Flutter weather application built using the **SSD (Specification-Driven Development) / SPARC** methodology.

## 📌 Project Overview
This app fetches real-time weather data from an external API, stores it locally for offline access, and displays it in a responsive UI. It follows a strict step-by-step workflow to ensure clean architecture, separation of concerns, and maintainable code.

## ✨ Key Features
- 🌐 Real-time weather data via REST API
- 💾 Local storage fallback (works offline)
- 🔄 Automatic data refresh & error handling
- 📱 Responsive & beginner-friendly UI
- 🔒 Secure credential management (no secrets in code)

## 🏗️ Architecture & Methodology
- **SSD / SPARC Workflow**: Project → Model → Storage → API → State → UI
- **Clean Separation**: UI, business logic, and data services are strictly isolated
- **State Management**: Simple & explicit (Provider/Bloc as implemented)
- **Offline-First**: Caches data locally when internet is unavailable

## 🛠️ Tech Stack
- Flutter & Dart
- `http` (API communication)
- Local storage package (e.g., `shared_preferences` / `hive`)
- State management package (e.g., `provider` / `flutter_bloc`)
- `flutter_dotenv` (Environment variables)

## 🚀 How to Run
1. Clone the repository
2. Run `flutter pub get`
3. Create a `.env` file based on `.env.example` and add your API key
4. Run `flutter run`

## 🔒 Security Note
This is a **public repository**. API keys and secrets are kept in `.env` and ignored by Git. Never commit real credentials.

## 📂 Project Structure