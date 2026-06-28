# Furrr - PetCare AI

**Furrr** is a high-performance Flutter application designed to provide Indian pet owners with intelligent, real-time health and behavioral insights. Combining premium UI design with Google's **Gemini AI** and advanced UX animations, Furrr offers a comprehensive ecosystem for proactive pet care.

---

##  Key Features

###  AI Health & Play Ecosystem
- **Bark & Play Fun Activity**: Interactive real-time sound board featuring high-quality dog barks to engage and play with your pet.
- **Smart Symptom Checker**: Select symptoms and provide custom descriptions to receive dynamic health verdicts.
- **Behavior Analyzer**: Supports **custom observations**. Describe specific pet behaviors in detail for tailored AI insights.
- **Interactive Text-to-Speech (TTS)**: Accessibly "Read Aloud" feature for all AI analysis results (Behavior & Symptoms).

###  UX & Animations
- **Jumping Navigation Bar**: A custom, playful "jump arc" animation for indicator transitions.
- **Staggered Onboarding**: Elegant right-to-left entrance animations on the Welcome Screen.
- **Dynamic Mascots**: Animated mascots like the "Flirting Dog" and "Boxing Dog" that interact with the UI layout.

###  Localized Services & Real-World Data
- **Real-Time Find Vets**: Uses GPS and the **OpenStreetMap API** to find actual veterinary clinics near you.
- **Indian Food Safety Guide**: Specialized guide for Indian foods (Roti, Dal, Paneer...) rated for pet safety.
- **Community Feed**: A dynamic and personalized reels feed powered by **YouTube Shorts**. Features query rotation (to keep content fresh), search ordering randomization, breed-specific customization, and pull-to-refresh support.

###  Breed-Specific Intelligence
- **Custom Care Guides**: The app adapts based on your pet's breed, offering tailored health risks and care tips.
- **Real-Time Profile Sync**: Centralized service ensures pet profile changes are instantly reflected everywhere.

### Authentication & Session Security
- **Local User Database**: Holds user records, emails, phones, and passwords in a local `SharedPreferences` database list.
- **Dynamic Guest Mode**: Login instantly as a guest, creating a unique random guest identifier recorded in the local DB.
- **Automatic Session Restore**: Bypasses welcome onboarding screens if a guest or user session is already active.

---

## Technology Stack

| Category | Technology / Package | Purpose |
| :--- | :--- | :--- |
| **Framework** | **Flutter (Dart)** | Cross-platform core rendering engine and application lifecycle. |
| **Generative AI** | **Google Gemini API** (`google_generative_ai`) | Powers symptom triage, behavior analysis, and injury scanner. |
| **Secure Storage** | **`flutter_secure_storage`** | Cryptographically encrypts user API keys via Keychain/Keystore. |
| **Real-Time Locator** | **OpenStreetMap (Overpass API)** | Searches and maps nearby veterinary clinics without API keys. |
| **Video Integration** | **YouTube Data API v3** | Queries short-form video reels for the Community Screen. |
| **Video Player** | **`youtube_player_flutter`** | Custom inline controller to play YouTube Shorts within the app. |
| **Location Services** | **`geolocator`** | Handles device GPS permissions and fetches user coordinates. |
| **Audio Engine** | **`audioplayers`** | Feeds soundboard events inside the Bark & Play Activity. |
| **Accessibility** | **`flutter_tts`** | Standard Text-to-Speech support to read out AI diagnostics. |

---

## Project Structure

```text
lib/
├── config/              # App constant configurations (API endpoints, environment vars)
├── models/              # Data parsing entities (Pet profiles, Vet clinics)
├── Screens/             # Feature-specific screens and controllers
│   ├── auth/            # Welcome, Login, and Registration pages
│   ├── Home/            # Dashboard and Settings configuration gear
│   ├── Community/       # YouTube Shorts vertical swipe feed
│   ├── Profile/         # Pet Profile management and breed selectors
│   ├── SymptomChecker/  # Symptom checklists and AI diagnostic verdicts
│   ├── Wound Analyzer/  # Gemini Vision-powered wound image scanner
│   ├── Services/        # Walker bookings and supplementary tools
│   └── Vets/            # Location-based OpenStreetMap veterinary list
├── services/            # Services layer (AI requests, OS map queries, local storage)
├── theme/               # Design tokens (Colors, Font declarations, layouts)
├── widgets/             # Reusable UI components (buttons, textfields, custom bars)
└── main.dart            # Flutter application entry point
```

---

## API Configuration & Security (BYOK)

To ensure the app is **100% free** to run, host, and scale, it uses a **Bring Your Own Key (BYOK)** architecture:

* **Local Development**: The app loads fallback API keys from `assets/.env`. 
  <!--This file is ignored by Git and is never committed to keep credentials safe.-->
* **Production Users**: Users can easily configure their own free Gemini API key by tapping the **Settings gear icon** in the top-right header of the Home Screen.
* **Hardware-Backed Encryption**: Stored keys are encrypted at rest using `flutter_secure_storage` (using iOS Keychain and Android Keystore), making them secure against rooted devices, debug extractions, or backups.

### Setup for Local Development

1. Copy `.env.example` to `assets/.env`:
   ```bash
   cp .env.example assets/.env
   ```
2. Open `assets/.env` and replace the placeholder values with your real API keys (Gemini and YouTube).
3. Run the app:
   ```bash
   flutter run
   ```

---

*Author - Gayathri Reddy*
