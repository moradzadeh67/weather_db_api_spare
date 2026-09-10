# 🌤️ SSD Weather App

A professional, offline-first Flutter weather application built using the **SSD (Specification-Driven Development)** methodology and **SPARC** workflow.

## 📌 Project Overview
This application provides real-time weather information using a clean, modular architecture. It is designed to be resilient to network issues by implementing a robust local caching system, ensuring users can always access their last viewed weather data.

## 🏗️ Methodology: SSD & SPARC
This project was developed following the **SSD (Specification-Driven Development)** principles, which prioritize clear definitions and requirements before implementation. The **SPARC** workflow was utilized to ensure a logical and maintainable build process:

1.  **S**etup: Project initialization and dependency management.
2.  **P**ersistence: Designing the data models and local storage services.
3.  **A**PI: Implementing stateless network services for data retrieval.
4.  **R**eactivity: Managing application state and business logic.
5.  **C**omponents: Building a responsive and intuitive user interface.

## ✨ Key Features
- 🌐 **Real-time Data**: Integrated with the **Open-Meteo API** (No API Key required).
- 💾 **Offline-First**: Automatic local storage of weather data and the selected city for instant access without internet.
- 🏳️ **Country Identity**: Visual identification of cities using dynamic emoji flags in search results and main view.
- 🔍 **Smart Search**: Custom relevance filtering that prioritizes exact matches and removes irrelevant results.
- 📱 **Modern UI**: A glassmorphic design featuring adaptive backgrounds that change based on current weather conditions.

## 🛠️ Tech Stack
- **Flutter & Dart**
- **State Management**: **ChangeNotifier** + **ListenableBuilder** for lightweight and reactive UI updates.
- **API Communication**: **http** for efficient REST API calls.
- **Local Persistence**: **Custom JSON Storage** (via `path_provider`) for lightweight data caching.
- **Connectivity**: **connectivity_plus** for real-time monitoring of network status.

## 🚀 How to Run
1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/moradzadeh67/weather_db_api_spare.git
    ```
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

## 📂 Project Structure
- `lib/models/`: Robust data structures with full JSON serialization.
- `lib/services/`: Specialized services for API calls and local storage.
- `lib/state/`: Centralized business logic and UI state notifications.
- `lib/pages/`: Modular UI screens and reusable widgets.
