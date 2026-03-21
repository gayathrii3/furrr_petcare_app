# Furrr - 🐾 PetCare AI (Advanced Companion)

**Furrr** is a state-of-the-art Flutter application designed to provide Indian pet owners with intelligent, real-time health and behavioral insights. Combining modern UI design with Google's **Gemini 2.0 Flash** AI and Google Places, Furrr offers a comprehensive ecosystem for proactive pet care tailored to the Indian market.

---

## 🚀 Key Features

### 🧠 AI Health Ecosystem
- **AI Wound Analyzer**: Upload or capture images of pet wounds for instant AI-driven severity assessment and first-aid guidance (Powered by Gemini).
- **Smart Symptom Checker**: Select symptoms and provide custom descriptions to receive dynamic health verdicts and professional advice.
- **Behavior Analyzer**: Transform pet behavior observations into actionable insights using AI to understand the "Why" and "What to do."

### 📍 Localized Services & Real-World Data
- **Real-Time Find Vets**: Uses GPS and the **Google Places API** to find actual veterinary clinics near you.
- **Indian Food Safety Guide**: Specialized guide for Indian foods (Roti, Dal, Idli, Paneer, Jaggery...) rated for pet safety.
- **Location-Based Content**: Neighborhood-optimized service lists for Indian cities (starting with Hyderabad).

### 🐕 Breed-Specific Intelligence
- **Custom Care Guides**: The app adapts based on your pet's breed, offering tailored health risks, care tips, and medication warnings.
- **Real-Time Profile Sync**: A centralized service ensures that changes to your pet's profile are instantly reflected everywhere.

### 🌎 Community & Accessibility
- **Community Feed**: A vibrant feed of pet-related content powered by **YouTube Shorts** integration.
- **Multilingual Support**: Support for English, Hindi (हिन्दी), Telugu (తెలుగు), and Tamil (தமிழ்) for global and local accessibility.

---

## 🔒 Security & API Configuration

This project uses a secure method to manage API keys. **Never** commit your API keys to version control.

### 1. Simple Setup (Recommended)
Create a `secrets.json` file in the root directory:

```json
{
  "GEMINI_API_KEY": "YOUR_KEY_HERE",
  "YOUTUBE_API_KEY": "YOUR_KEY_HERE",
  "GOOGLE_MAPS_API_KEY": "YOUR_KEY_HERE"
}
```

### 2. Running the App
```bash
flutter run --dart-define-from-file=secrets.json
```

---

## 🛠️ Technology Stack
- **Framework**: Flutter (Dart)
- **AI Core**: Google Gemini 2.0 Flash
- **Location**: Google Places API & Geolocator
- **Feed**: YouTube Data API v3
- **State Management**: Service-based singleton pattern for real-time synchronization.

---

*Made with ❤️ for pet owners everywhere.*
