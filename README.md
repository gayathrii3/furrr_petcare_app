# Furrr - PetCare AI (Premium Companion)

**Furrr** is a high-performance Flutter application designed to provide Indian pet owners with intelligent, real-time health and behavioral insights. Combining premium UI design with Google's **Gemini AI** and advanced UX animations, Furrr offers a comprehensive ecosystem for proactive pet care.

---

##  Key Features

###  AI Health & Play Ecosystem
- **Bark & Play Fun Activity**: Interactive real-time sound board featuring high-quality dog barks to engage and play with your pet.
- **Smart Symptom Checker**: Select symptoms and provide custom descriptions to receive dynamic health verdicts.
- **Enhanced Behavior Analyzer**: Now supports **custom observations**. Describe specific pet behaviors in detail for tailored AI insights.
- **Interactive Text-to-Speech (TTS)**: Accessibly "Read Aloud" feature for all AI analysis results (Behavior & Symptoms).

###  Premium UX & Animations
- **Jumping Navigation Bar**: A custom, playful "jump arc" animation for indicator transitions.
- **Staggered Onboarding**: Elegant right-to-left entrance animations on the Welcome Screen.
- **Dynamic Peeping Mascots**: Animated mascots like the "Flirting Dog" and "Boxing Dog" that interact with the UI layout.
- **Universal Light Theme**: A cohesive "Soft Beige and Caramel" premium theme across all modules.

###  Localized Services & Real-World Data
- **Real-Time Find Vets**: Uses GPS and the **Google Places API** to find actual veterinary clinics near you.
- **Indian Food Safety Guide**: Specialized guide for Indian foods (Roti, Dal, Paneer...) rated for pet safety.
- **Community Feed**: A vibrant feed of pet-related content powered by **YouTube Shorts** integration.

###  Breed-Specific Intelligence
- **Custom Care Guides**: The app adapts based on your pet's breed, offering tailored health risks and care tips.
- **Real-Time Profile Sync**: Centralized service ensures pet profile changes are instantly reflected everywhere.

---

##  Technology Stack
- **Framework**: Flutter (Dart)
- **AI Core**: Google Gemini AI
- **Audio Engine**: Audioplayers 5.x
- **Accessibility**: Flutter TTS (Text-to-Speech)
- **UI Architecture**: Custom Paint & Lottie Animations
- **Location**: Google Places API & Geolocator
- **Feed**: YouTube Data v3

---

## 🔑 API Configuration & Security (BYOK)

To ensure the app is **100% free** to run, host, and scale, it uses a **Bring Your Own Key (BYOK)** architecture:

* **Local Development**: The app loads fallback API keys from `assets/.env`. This file is ignored by Git and is never committed to keep credentials safe.
* **Production Users**: Users can easily configure their own free Gemini API key by tapping the **Settings gear icon** in the top-right header of the Home Screen.
* **Hardware-Backed Encryption**: Stored keys are encrypted at rest using `flutter_secure_storage` (using iOS Keychain and Android Keystore), making them secure against rooted devices, debug extractions, or backups.

### Setup for Local Development

1. Copy `.env.example` to `assets/.env`:
   ```bash
   cp .env.example assets/.env
   ```
2. Open `assets/.env` and replace the placeholder values with your real API keys (Gemini, YouTube, and Google Maps).
3. Run the app:
   ```bash
   flutter run
   ```

---

*Author - Gayathri Reddy*
