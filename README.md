# Flutter Backend App

## Description

Application Flutter Connected Data Explorer connectée à DummyJSON. Elle récupère
réellement des produits et le profil utilisateur via REST, authentifie la session
avec un token JWT, met les produits en cache avec Hive et affiche les dernières
données connues lorsque le réseau est indisponible.

## Fonctionnalités

- Login réel via `POST /auth/login`
- Register via `POST /users/add` (voir la limitation documentée ci-dessous)
- Session persistante avec `flutter_secure_storage`
- Logout et protection des routes
- Catalogue produits, recherche et pull-to-refresh
- Détail produit chargé avec son identifiant
- Profil utilisateur via `GET /auth/me`
- Cache Hive et fallback offline avec bannière explicite
- États loading, success, empty et error avec retry
- Interface responsive téléphone, tablette et écran large

## API

Backend: [DummyJSON](https://dummyjson.com/)

Endpoints utilisés:

- `POST /auth/login`: authentification et récupération de `accessToken`.
- `GET /auth/me`: profil de l’utilisateur authentifié.
- `GET /products?limit=30`: catalogue distant.
- `GET /products/{id}`: détail distant.
- `POST /users/add`: endpoint de démonstration pour le formulaire Register.

DummyJSON est une API de démonstration: `/users/add` accepte une création mais ne
crée pas un compte persistant utilisable pour un futur login. L’application ne
simule pas de connexion après Register: elle affiche la réponse de l’API puis
redirige vers Login. DummyJSON ne fournit pas non plus de refresh token; le
projet documente cette limite au lieu d’inventer un mécanisme.

## Architecture

```text
lib/
├── core/
│   ├── constants/app_constants.dart
│   ├── errors/app_exceptions.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── auth_interceptor.dart
│   ├── storage/
│   │   ├── token_storage.dart
│   │   └── local_storage.dart
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   └── local/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
├── presentation/
│   ├── controllers/
│   ├── screens/
│   └── widgets/
├── router/app_router.dart
└── main.dart
```

## Repository Pattern

Le flux de données est:

```text
UI -> AppController -> Repository -> DataSource -> Dio/Hive
```

La présentation ne connaît ni Dio ni Hive. `ProductRepositoryImpl` tente l’API,
met à jour le cache après succès et lit Hive en cas d’échec réseau. Les
repositories sont définis par des interfaces dans `domain/repositories`.

## Dio et interceptor

`core/network/dio_client.dart` centralise l’URL `https://dummyjson.com`, les
timeouts et les headers. `auth_interceptor.dart` lit le token depuis
`SecureTokenStorage` et ajoute automatiquement:

```text
Authorization: Bearer <token>
```

Les réponses 401 sont transformées en `UnauthorizedException`. Aucun token n’est
présent dans le code source.

## Authentication

- Login: token reçu depuis DummyJSON, stocké avec `flutter_secure_storage`.
- Session: token relu au démarrage puis validé via `/auth/me`.
- Logout: token supprimé et routes protégées redirigées vers `/login`.
- Register: formulaire et appel REST `/users/add`, sans prétendre rendre le compte persistant.
- Refresh: non applicable, car DummyJSON ne fournit pas de refresh token public.

## Cache et mode offline

`LocalStorage` encapsule Hive dans la box `products_cache`. Après un succès de
`GET /products`, les produits sont sauvegardés. Si l’appel suivant échoue,
`ProductRepositoryImpl` lit le cache et l’interface affiche les produits avec
la bannière « Mode hors ligne ». Si aucun cache n’existe, un message clair et un
bouton `Réessayer` sont présentés.

## Gestion des erreurs

Les erreurs réseau, serveur, authentification, 401 et cache sont représentées
par des exceptions métier dans `core/errors/app_exceptions.dart`. Les écrans
n’affichent pas de stack trace brute.

## Installation et lancement

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

`test/repository_test.dart` vérifie le succès API, le fallback Hive et l’erreur
lorsque l’API et le cache sont indisponibles.

## Analyse

```bash
flutter analyze
```

## Screenshots

Le dossier `screenshots/` est présent pour recevoir les captures réelles:

- `screenshots/login.png`
- `screenshots/home.png`
- `screenshots/detail.png`
- `screenshots/profile.png`
- `screenshots/offline.jpeg`

Aucune capture fictive n’est présentée comme générée.

## Configuration et sécurité

Aucune clé API ou credential n’est requis par DummyJSON. Les tokens utilisateur
sont stockés uniquement dans `flutter_secure_storage`. Ne committez jamais de
JWT, mot de passe ou secret.

## GitHub

Le projet est prêt à être initialisé ou publié dans un dépôt nommé
`flutter_backend_app`. Aucun `git push` n’est exécuté par cette implémentation.
