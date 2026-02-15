<div align="center">

# 📖 Rasikh | راسخ

**رفيقك الذكي لإتقان حفظ القرآن الكريم**
**Your Smart Companion for Mastering the Holy Quran**

[![Flutter](https://img.shields.io/badge/Flutter-3.32.5-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-0175C2?style=for-the-badge&logo=dart)](https://dart.dev/)
[![State Management](https://img.shields.io/badge/State-Riverpod-purple?style=for-the-badge)](https://riverpod.dev/)

</div>

---

## 💡 About The Project | عن المشروع

**Rasikh (راسخ)** is a comprehensive educational platform designed to streamline the Quran memorization process. By combining traditional learning methods with modern technology, it offers dynamic study plans, progress tracking, and interactive memorization tools.

**راسخ** هي منصة تعليمية شاملة صممت لتسهيل عملية حفظ القرآن الكريم. يجمع التطبيق بين طرق التعليم التقليدية والتقنية الحديثة لتوفير خطط دراسية ديناميكية، أدوات تتبع التقدم، ووسائل مساعدة تفاعلية للحفظ.

---

## ✨ Key Features | المميزات الرئيسية

*   🔐 **Secure Authentication:** Robust login system (Email) with secure token storage.
*   📅 **Dynamic Study Plans:** Daily memorization tasks fetched directly from the server.
*   🎧 **Interactive Learning:** Tools for audio listening, repetition counters, and writing verification.
*   📊 **Progress & Analytics:** Detailed dashboards with charts to track memorization performance.
*   🏆 **Certificates:** Auto-generated PDF certificates upon plan completion.
*   📖 **Rich Resources:** Integrated Tafsir (Interpretation) search and viewing.
*   👤 **Profile Management:** Full control over personal data, address, and plans.
*   🌍 **Localization:** Fully supports Arabic (RTL) and English.

---

## 🛠️ Tech Stack & Architecture | التقنيات والهيكلية

The project is built using a **Feature-First Clean Architecture** to ensure scalability and maintainability.

*   **Framework:** Flutter & Dart.
*   **State Management:** Riverpod (ConsumerWidget, StateNotifier).
*   **Networking:** Dio (with Interceptors & Custom Exception Handling).
*   **Local Storage:** Shared Preferences & Flutter Secure Storage.
*   **Code Generation:** Json Serializable & Build Runner.
*   **Utilities:** PDF Generation, Cached Network Images, SVG support.

### 📂 Folder Structure
- lib/
  - core/ (Shared components: API, Models, Services, Theme)
  - features/ (Feature-based modules)
    - auth/ (Authentication logic & UI)
    - guide/ (Instructions screen)
    - home/ (Dashboard & Navigation)
    - memorization_plan/ (Core memorization logic)
    - profile/ (User profile management)
    - reports/ (Statistics & Certificates)
    - resources/ (Tafsir & Tajweed)
  - main.dart (Entry point)

---

## 🚀 Getting Started | كيفية التشغيل

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Sharaf-AlFaqeeh/Hudhud-Intelligence-Hub
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate code (Essential):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

> **Note for Developers:** The app is configured to connect to a backend API. Ensure the `_baseUrl` in `api_service.dart` is correctly set to your server environment (Dev stage or Production).

---

<div align="center">

Developed with ❤️ using Flutter

</div># Rasikh
