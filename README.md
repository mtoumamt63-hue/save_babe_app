<div align="center">

<img src="assets/images/savebabe_logo.png" alt="SaveBabe Logo" width="120"/>

# SaveBabe 🤱

**Suivi de grossesse et du nouveau-né — Privé · Hors connexion · Panafricain**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-00BCD4)](https://riverpod.dev)
[![License](https://img.shields.io/badge/Licence-Propriétaire-red)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)](CHANGELOG.md)

</div>

---

## 📖 Présentation

**SaveBabe** est une application mobile Flutter conçue pour accompagner les femmes enceintes et les jeunes mamans, en priorité dans les contextes africains où la connectivité Internet est limitée et les structures de santé dispersées.

L'application combine :
- 🤰 **Suivi de grossesse semaine par semaine** avec contenu médical illustré et animations 3D
- 🍼 **Suivi du nouveau-né** (croissance, vaccinations, jalons)
- 🤖 **Assistant IA** (Gemini) pour répondre aux questions de santé maternelle
- 🚨 **Module urgences** avec accès rapide aux numéros d'urgence et signaux d'alarme
- 📅 **Gestion des rendez-vous** prénataux (CPN)
- 📷 **OCR du carnet de santé** pour numériser les carnets papier
- 🔔 **Notifications locales** pour rappels et alertes
- 🌍 **100 % offline-first** — toutes les données restent sécurisées sur l'appareil

---

## ✨ Fonctionnalités Clés

| Module | Description |
|---|---|
| 🤰 **Grossesse (SA 1 à 41)** | Suivi hebdomadaire, comparaison taille/fruit, symptômes, CPN, hydratation, nutrition |
| 👶 **Bébé & Postpartum** | Suivi poids/taille, courbe OMS, vaccins, jalons de développement, soins du nourrisson |
| 🤖 **IA Assistante (Gemini)** | Conseils de santé maternelle via chat interactif et commande vocale |
| 🚨 **Urgences & Signaux d'Alarme** | Détection des complications, gestes de secours, numéros d'urgence configurables |
| 📷 **Scan OCR Carnet** | Reconnaissance optique (ML Kit) pour digitaliser les constantes du carnet médical |
| 📅 **Rendez-vous & CPN** | Calendrier des consultations obligatoires et examens recommandés |
| 👤 **Personne de Confiance** | Partage d'alertes et accompagnement par un proche désigné |
| 🔔 **Rappels & Notifications** | Alertes locales personnalisées (hydratation, médicaments, rendez-vous) |
| 🌙 **Thème & Confort Visuel** | Support natif Mode Sombre / Mode Clair adapté aux conditions d'éclairage |
| 🌍 **Multilingue & Accessibilité** | Français, Anglais (extensible aux langues locales comme le Wolof, Bambara...) |

---

## 🏗️ Architecture du Projet

L'application suit une architecture **Feature-First** combinée aux principes de la **Clean Architecture** (séparation `presentation`, `domain`, `data`) pour garantir maintenabilité, modularité et testabilité.

```
save_babe_app/
├── lib/
│   ├── main.dart                    # Point d'entrée, initialisation (Firebase, Hive, Notifications)
│   ├── firebase_options.dart        # Configuration Firebase auto-générée
│   │
│   ├── core/                        # Socle transversal partagé
│   │   ├── constants/               # Constantes, couleurs de base, URLs, clés
│   │   ├── errors/                  # Exceptions personnalisées et gestion des pannes
│   │   ├── network/                 # Client HTTP, configuration réseau
│   │   ├── router/                  # Navigation déclarative (GoRouter) & Guards d'accès
│   │   │   ├── app_router.dart
│   │   │   └── scaffold_with_nav_bar.dart
│   │   ├── services/                # Services partagés (Auth, LocalStorage, Notifications)
│   │   │   ├── auth_service.dart
│   │   │   ├── local_storage_service.dart  # Wrapper Hive (Offline-First)
│   │   │   └── notification_service.dart
│   │   ├── state/                   # État utilisateur global (User Profile, DDR, Préférences)
│   │   │   ├── app_user_state.dart  # Modèle immutable (Freezed)
│   │   │   ├── app_user_notifier.dart
│   │   │   └── app_user_provider.dart
│   │   ├── theme/                   # Charte graphique & Design System (AppTheme)
│   │   │   └── app_theme.dart
│   │   ├── utils/                   # Calculateurs médicaux, formatage dates, validateurs
│   │   └── widgets/                 # Composants d'interface génériques et réutilisables
│   │
│   └── features/                    # Modules métier indépendants
│       ├── splash/                  # Écran de démarrage avec loader animé et transition
│       ├── onboarding/              # Welcome, Consentement médical, Inscription/Connexion
│       ├── home/                    # Dashboard central & raccourcis dynamiques
│       ├── pregnancy_tracker/       # ⭐ Suivi de grossesse complet
│       │   ├── data/                # Dataset médical SA 1-41 & conseils
│       │   ├── domain/              # Calculateur de terme, règles de santé prénatale
│       │   └── presentation/        # TrackingScreen, carrousel SA, fiches conseils
│       ├── baby_tracker/            # Suivi néonatal et pédiatrique
│       ├── ai_assistant/            # Intégration Gemini 3.8 Flash (Chat + Vocal STT/TTS)
│       ├── appointments/            # Planification et gestion des consultations prénatales
│       ├── emergency/               # Guide des signes de danger et appel rapide
│       ├── health_card_scan/        # Scanner OCR (Google ML Kit)
│       ├── notifications/           # Configuration et historique des alertes
│       ├── profile/                 # Gestion du compte, sécurité, choix langue/thème
│       └── trusted_person/          # Liaison et partage avec un proche
│
├── assets/
│   ├── images/                      # Identité visuelle, logos officiels, badges
│   └── pregnancy/
│       ├── weekly/                  # Visuels du fœtus semaine par semaine
│       ├── topics/                  # Infographies (Nutrition, Préparation accouchement...)
│       ├── photos/                  # Clichés éducatifs
│       └── 3d/                      # Rendu volumétrique 3D du bébé
│
├── docs/                            # Documentation d'équipe et fiches de mission
├── android/                         # Configuration native Android (icônes adaptatives, splash)
├── ios/                             # Configuration native iOS
├── pubspec.yaml                     # Manifeste, packages et assets
└── CheckMe.md                       # Guide de workflow et checklist qualité
```

### Flux de Données & Réactivité

```
┌──────────────────────────────────────────────┐
│             UI Layer (Flutter)               │
│  (ConsumerWidget / ConsumerStatefulWidget)    │
└──────────────────────┬───────────────────────┘
                       │ watch / read
                       ▼
┌──────────────────────────────────────────────┐
│         State Management (Riverpod)          │
│    (StateNotifierProvider / Notifier)        │
└──────────────────────┬───────────────────────┘
                       │ calls
                       ▼
┌──────────────────────────────────────────────┐
│          Service / Repository Layer          │
│  (LocalStorageService, GeminiService, etc.)  │
└──────────────┬───────────────────────────────┘
               │
      ┌────────┴────────┐
      ▼                 ▼
┌───────────┐     ┌───────────┐
│ Local DB  │     │ Remote /  │
│  (Hive)   │     │  Cloud    │
│ [Offline] │     │ (Firebase/│
└───────────┘     │  Gemini)  │
                  └───────────┘
```

---

## 🛠️ Stack Technique

### Core & Framework
- **Flutter 3.x** / **Dart 3.13+**
- **Firebase Core & Auth** : Authentification fluide et sécurisée.
- **Flutter Riverpod 2.x** : Gestion d'état prédictive, réactive et typée.
- **GoRouter 14.x** : Routage déclaratif avec gestion des redirections d'authentification.
- **Hive Flutter** : Base de données locale ultra-rapide (NoSQL key-value) garantissant le fonctionnement **100% hors-ligne**.
- **Freezed & JSON Serializable** : Génération de modèles de données immutables.
- **Fpdart** : Programmation fonctionnelle pour un traitement robuste des erreurs.

### Intelligence Artificielle & Multimédia
- **Google Gemini API** : Modèle IA génératif pour l'assistance interactive aux futures mères.
- **Google ML Kit Text Recognition** : Numérisation OCR sur appareil (on-device) sans fuite de données.
- **Speech To Text & Flutter TTS** : Accessibilité vocale pour les utilisatrices analphabètes ou malvoyantes.

### UI & Styling
- **Google Fonts** : Typographies professionnelles et élégantes.
- **Material Symbols Icons & Flutter SVG** : Iconographie moderne et vectorielle.
- **Design System Personnalisé** : Palette chromatique harmonieuse, contrastes respectueux des normes WCAG.

---

## ⚡ Démarrage Rapide (Quick Start)

### 1. Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé (version >= 3.13).
- Android Studio ou VS Code avec extensions Flutter & Dart.
- Émulateur Android / iOS ou appareil physique avec débogage USB activé.

### 2. Cloner et Installer

```bash
# 1. Cloner le projet
git clone https://github.com/mtoumamt63-hue/save_babe_app.git
cd save_babe_app

# 2. Vérifier la configuration
flutter doctor

# 3. Récupérer les dépendances
flutter pub get
```

### 3. Lancer l'Application

```bash
# Démarrer en mode debug sur votre cible connectée
flutter run
```

---

## 🧪 Contrôle Qualité & Tests

Avant chaque commit ou Pull Request, l'équipe applique une politique **Zéro Avertissement** :

```bash
# 1. Analyse statique du code (linter strict)
flutter analyze

# 2. Formatage standardisé du code Dart
dart format .

# 3. Exécution de la suite de tests unitaires et widgets
flutter test
```

### Commandes Utiles (Génération de code)
En cas de modification d'annotations Freezed ou Riverpod :
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 👥 Rôles & Fiches de Mission

Consultez le dossier [`docs/`](docs/) pour retrouver le cahier des charges de chaque responsable :
- 🔔 [docs/Responsable_Notifications.md](docs/Responsable_Notifications.md)
- 🔐 [docs/Responsable_Securite.md](docs/Responsable_Securite.md)
- 🤖 [docs/Responsable_Integration_IA.md](docs/Responsable_Integration_IA.md)
- 📚 [docs/Responsable_Structuration_Documentation.md](docs/Responsable_Structuration_Documentation.md)
- 🤰 [docs/Responsable_Suivi_Grossesse.md](docs/Responsable_Suivi_Grossesse.md)

Le guide général des développeurs est disponible dans [`CheckMe.md`](CheckMe.md).

---

## 🔒 Confidentialité & Éthique Médicale

- **Privacy by Design** : Aucune donnée de santé (date des dernières règles, examens, constantes) n'est transmise à des tiers ni hébergée sur des serveurs non autorisés.
- **Traitement local prioritaire** : Les calculs de terme et l'analyse OCR s'exécutent directement sur l'appareil.
- **Avertissement Médical** : SaveBabe fournit des conseils d'orientation et de bien-être mais ne remplace en aucun cas l'avis ou le diagnostic d'un professionnel de santé qualifié.

---

<div align="center">
  <sub>Projet SaveBabe • Conçu avec passion pour la santé maternelle et infantile.</sub>
</div>
