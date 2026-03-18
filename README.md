# Furrr - 🐾 PetCare AI

> An AI-powered pet healthcare companion app built for Indian dog owners — with breed-aware health intelligence, vernacular support, and hyperlocal community features.

---

## What is Furr - PetCare AI?

Furrr is a mobile-app of a dog health and community app designed specifically for the Indian market. Most pet apps are built for Western audiences — Furrr PetCare AI focuses on problems that Indian pet owners actually face: desi food safety, vernacular language barriers, monsoon health risks, and lack of hyperlocal pet services in Tier 2/3 cities.

---

## Features

### AI-Powered
| Feature | Description |
|---|---|
| **AI Wound Analyzer** | Upload a photo of your dog's wound — Claude analyzes severity, type, and recommends action |
| **AI Symptom Checker** | Select symptoms → AI generates a likely diagnosis with urgency level and next steps |
| **AI Behavior Analyzer** | Describe unusual behavior → AI explains the cause and what to do |

| Feature | Description |
|---|---|
| **Indian Food Safety Guide** | 18 Indian foods (Roti, Dal, Idli, Biryani, Paneer, Mango, Jaggery...) rated Safe / Caution / Toxic |
| **Vernacular Support** | Full UI available in English, Hindi (हिन्दी), Telugu (తెలుగు), Tamil (தமிழ்) |
| **Breed Health Risk Engine** | Proactive genetic risk analysis for 9 breeds including Indie/Desi dogs — age-filtered |

### Unique Features
| Feature | Description |
|---|---|
| **Walker Finder** | Find verified dog walkers and pet sitters within 2km with ratings, pricing, and booking |
| **Playdate Finder** | Match your dog with compatible dogs nearby by size, temperament, and vaccination status |
| **Vaccine Tracker** | Smart status per vaccine — Up to date / Due Soon / Overdue with days countdown |
| **Pet Reels** | YouTube Shorts feed of pet videos embedded in a vertical scroll experience |

### Core Features
- Pet Profile with editable health data synced to home screen
- Food Safety Guide with search and tap-to-expand details
- Medication Guide with dosage and safety ratings
- Nearby Vet Finder
- Multi-language support across all screens

---

## Supported Breeds — Health Risk Engine

Each risk includes: description, warning signs to watch, and prevention/management advice. Risks are filtered by the dog's current age — only age-relevant conditions are shown.

---

No backend. No database. This is a frontend-only prototype with one live API call (wound analyzer).


---

## Known Limitations

This is a prototype. The following features use mock/static data:

- Walker and sitter profiles are hardcoded — no real backend
- Vet locations and distances are static — no Google Maps integration
- Playdate profiles are simulated — no real user accounts
- YouTube Shorts may not autoplay due to browser iframe restrictions
- Profile data resets on page refresh — no persistent storage

In a production version these would be replaced with:
- Firebase Firestore for real-time data
- Firebase Auth for user accounts
- Google Maps Platform for live location and distances
- React Native + Expo for true Android/iOS deployment

---

*Built with care for every Brownie, Bruno, Coco, and Luna out there.*
