<div align="center">

<img src="assets/images/savebabe_logo.png" alt="SaveBabe Logo" width="120"/>

# SaveBabe

**Suivi de grossesse et du nouveau-ne -- Prive, Hors connexion, Panafricain**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-00BCD4)](https://riverpod.dev)
[![License](https://img.shields.io/badge/Licence-Proprietaire-red)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)](CHANGELOG.md)

</div>

---

## Presentation

SaveBabe est une application mobile Flutter concue pour accompagner les femmes enceintes et les jeunes meres, principalement dans les contextes africains ou la connectivite Internet est limitee et les infrastructures sanitaires eloignees.

L'application combine :
- Suivi de grossesse semaine par semaine avec contenu medical illustre et modelisation 3D
- Suivi du nouveau-ne (croissance, vaccinations, jalons de developpement)
- Assistant IA (Gemini) specialise dans l'orientation et la sante maternelle
- Module de gestion des urgences avec signaux d'alarme et contacts rapides
- Gestion des consultations prenatales (CPN) et calendrier medical
- Reconnaissance optique (OCR) pour la numerisation des carnets de sante papier
- Notifications locales pour les rappels de sante et de rendez-vous
- Architecture 100 % hors-ligne (Offline-First) preservant la confidentialite des donnees

---

## Fonctionnalites Cles

| Module | Description |
|---|---|
| Grossesse (SA 1 a 41) | Suivi hebdomadaire, comparaison de taille, symptomes, CPN, hydratation, nutrition |
| Bebe et Post-partum | Suivi poids et taille, courbes OMS, vaccins, jalons d'eveil, soins infantiles |
| Assistante IA (Gemini) | Orientation et reponses aux interrogations courantes par ecrit et par commande vocale |
| Urgences et Signes d'Alerte | Identification des complications, gestes reflexes, repertoires d'urgence configurables |
| Scan OCR Carnet | Numerisation des donnees et constantes par analyse optique embarquee (Google ML Kit) |
| Rendez-vous et CPN | Planification des consultations obligatoires et des examens biologiques |
| Personne de Confiance | Partage d'alertes et suivi conjoint avec un proche designe |
| Rappels et Notifications | Alertes locales programmees (medicaments, hydratation, echeances medicales) |
| Theme et Ergonomie | Modes Clair et Sombre optimises pour la lisibilite et le confort visuel |
| Langues et Accessibilite | Francais, Anglais (architecture prete pour l'integration de langues locales) |

---

## Architecture du Projet

L'application applique les principes de la Clean Architecture associee a un decoupage Feature-First pour assurer modularite et maintenabilite.

```
save_babe_app/
├── lib/
│   ├── main.dart                    # Initialisation globale (Firebase, Hive, Notifications)
│   ├── firebase_options.dart        # Configuration des services Firebase
│   │
│   ├── core/                        # Socle technique transverse
│   │   ├── constants/               # Constantes d'application, couleurs, cles
│   │   ├── errors/                  # Typage des erreurs et exceptions
│   │   ├── network/                 # Configuration des appels reseau
│   │   ├── router/                  # Routage applicatif (GoRouter) et controle d'acces
│   │   │   ├── app_router.dart
│   │   │   └── scaffold_with_nav_bar.dart
│   │   ├── services/                # Services partages (Auth, LocalStorage, Notifications)
│   │   │   ├── auth_service.dart
│   │   │   ├── local_storage_service.dart  # Persistance locale (Hive)
│   │   │   └── notification_service.dart
│   │   ├── state/                   # Etat utilisateur persistant (User Profile, DDR, Mesures)
│   │   │   ├── app_user_state.dart  # Modele immutable Freezed
│   │   │   ├── app_user_notifier.dart
│   │   │   └── app_user_provider.dart
│   │   ├── theme/                   # Charte visuelle et styles (AppTheme)
│   │   │   └── app_theme.dart
│   │   ├── utils/                   # Moteurs de calcul medical, formatage des dates
│   │   └── widgets/                 # Composants d'interface partages
│   │
│   └── features/                    # Domaines fonctionnels autonomes
│       ├── splash/                  # Demarrage, chargement et verification initiale
│       ├── onboarding/              # Accueil, consentement medical, authentification
│       ├── home/                    # Tableau de bord principal
│       ├── pregnancy_tracker/       # Module central de suivi de grossesse
│       │   ├── data/                # Dataset medical hebdomadaire
│       │   ├── domain/              # Moteur de calcul du terme et regles de suivi
│       │   └── presentation/        # Ecrans, carrousels et guides thématiques
│       ├── baby_tracker/            # Suivi pediatrique du nouveau-ne
│       ├── ai_assistant/            # Integration Gemini (Chat textuel et flux vocal STT/TTS)
│       ├── appointments/            # Agenda des consultations prenatales
│       ├── emergency/               # Signes de danger et declenchement d'appels d'urgence
│       ├── health_card_scan/        # Numerisation OCR du carnet de sante
│       ├── notifications/           # Parametrage et gestion des alertes locales
│       ├── profile/                 # Parametres de compte, langue et apparence
│       └── trusted_person/          # Liaison securisee avec un proche
│
├── assets/
│   ├── images/                      # Logos, marque et iconographie generale
│   └── pregnancy/
│       ├── weekly/                  # Illustrations hebdomadaires du foetus
│       ├── topics/                  # Infographies thematiques
│       ├── photos/                  # Visuels educatifs
│       └── 3d/                      # Rendus 3D du foetus
│
├── docs/                            # Fiches de mission techniques par role
├── android/                         # Configuration specifique a la plateforme Android
├── ios/                             # Configuration specifique a la plateforme iOS
├── pubspec.yaml                     # Dependances, polices et declarations d'assets
└── CheckMe.md                       # Protocole de developpement et standards qualite
```

### Flux de Donnees et Reactivite

```
+----------------------------------------------+
|             Couche UI (Flutter)              |
|  (ConsumerWidget / ConsumerStatefulWidget)   |
+----------------------┬-----------------------+
                       | ecoute / lecture
                       v
+----------------------------------------------+
|          Gestion d'Etat (Riverpod)           |
|    (StateNotifierProvider / Notifier)        |
+----------------------┬-----------------------+
                       | declenche
                       v
+----------------------------------------------+
|            Services & Repositories           |
|  (LocalStorageService, GeminiService, etc.)  |
+----------------------┬-----------------------+
                       |
            +----------+----------+
            v                     v
+-----------------------+ +--------------------+
|  Base Locale (Hive)   | |  Services Distants |
|      Hors-ligne       | | (Firebase, Gemini) |
+-----------------------+ +--------------------+
```

---

## Stack Technique

### Socle Applicatif
- Framework : Flutter 3.x / Dart 3.13+
- Authentification : Firebase Authentication
- Gestion d'etat : Flutter Riverpod 2.x
- Routage : GoRouter 14.x
- Base locale : Hive Flutter (stockage cle-valeur integre, ultra-rapide et autonome)
- Immutabilite : Freezed et JSON Serializable
- Programmation fonctionnelle : Fpdart

### Intelligence Artificielle et Traitement Visuel
- Moteur IA : API Google Gemini (modele conversationnel de sante)
- Reconnaissance de texte : Google ML Kit Text Recognition (traitement sur l'appareil)
- Accessibilite audio : Speech To Text et Flutter TTS

### Interface et Design
- Polices : Google Fonts
- Icones : Material Symbols Icons et Flutter SVG
- Ergonomie : Interface responsive respectant les ratios de contraste et l'accessibilite

---

## Demarrage Rapide (Quick Start)

### 1. Prerequis
- Flutter SDK installe (version superieure ou egale a 3.13)
- Dart SDK associe
- Environnement de test configure (appareil reel ou emulateur Android / iOS)

### 2. Installation

```bash
# Cloner le repertoire
git clone https://github.com/mtoumamt63-hue/save_babe_app.git
cd save_babe_app

# Verifier l'environnement Flutter
flutter doctor

# Installer l'ensemble des dependances
flutter pub get
```

### 3. Execution

```bash
# Lancer l'application sur le terminal cible
flutter run
```

---

## Controle Qualite et Standards de Developpement

Avant chaque soumission de code, chaque membre applique les regles de conformite suivantes :

```bash
# 1. Analyse statique (zero avertissement tolere)
flutter analyze

# 2. Formatage standard du code source
dart format .

# 3. Execution des tests unitaires
flutter test
```

### Generation de Code
Lors d'ajouts ou de modifications sur les modeles annotes (Freezed, Riverpod) :
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Documentation d'Equipe et Fiches de Mission

Consultez le repertoire [docs/](docs/) pour acceder aux instructions techniques detaillees :
- [Responsable Notifications](docs/Responsable_Notifications.md)
- [Responsable Securite](docs/Responsable_Securite.md)
- [Responsable Integration IA](docs/Responsable_Integration_IA.md)
- [Responsable Structuration et Documentation](docs/Responsable_Structuration_Documentation.md)
- [Responsable Suivi de Grossesse](docs/Responsable_Suivi_Grossesse.md)

Le protocole complet de contribution est detaille dans [CheckMe.md](CheckMe.md).

---

## Confidentialite et Ethique Medicale

- Principe de Confidentialite Native (Privacy by Design) : Les constantes de sante (date des dernieres regles, mensurations, symptomes) restent stockees exclusivement sur l'appareil de l'utilisatrice.
- Calculs autonomes : Toutes les estimations d'age gestationnel et les verifications de carnet s'effectuent sans dependance a un serveur distant.
- Avertissement : SaveBabe a une vocation d'accompagnement preventif et pedagogique. L'application ne se substitue a aucun moment a l'expertise, au diagnostic ou a la prescription d'un medecin ou d'une sage-femme qualifiee.

---

<div align="center">
  <sub>Projet SaveBabe -- Concu pour la sante maternelle et infantile.</sub>
</div>
