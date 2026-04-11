# Aether IDE (Desktop)

Un IDE construit avec **Tauri 2 + Vite + React + Monaco**, ciblant le **bureau** sur **Linux / Windows / macOS (Intel + Apple Silicon)**.

## Fonctionnalités (actuelles)

- **Monaco Editor** : éditeur TypeScript avec thème sombre.
- **UI type IDE** : barre latérale (Fichiers / Recherche) + header.
- **Raccourci sauvegarde** : `⌘/Ctrl+S` (démo, log console).
- **Paywall IA (démo)** : bouton IA → popup “Pro”.
- **Ouverture d’URL Stripe** : en Tauri via `@tauri-apps/plugin-opener`, sinon via navigateur.

## Prérequis

- **Node.js 20+**
- **Rust** (toolchain stable) + dépendances Tauri (selon OS)

## Démarrage

Installer les dépendances :

```bash
npm ci
```

Mode web (UI uniquement) :

```bash
npm run dev
```

Mode bureau (Tauri) :

```bash
npm run tauri dev
```

## Tester le serveur WS Time‑Machine (Tauri)

Quand l’app Tauri est lancée, un serveur WebSocket écoute sur `ws://127.0.0.1:7878`.

Dans un second terminal :

```bash
npm run tm:ws
```

Démo (start/stop automatique) :

```bash
TM_DEMO=1 npm run tm:ws
```

## Releases GitHub (desktop Linux / Windows / macOS)

Un workflow GitHub Actions est fourni dans `.github/workflows/release.yml`.

- **Déclencheur** : push d’un tag `v*`
- **Matrice** :
  - Windows : **NSIS (.exe installer)** + **MSI**
  - Ubuntu : **.deb** + **AppImage**
  - macOS Intel (`x86_64-apple-darwin`)
  - macOS Apple Silicon (`aarch64-apple-darwin`)
- **Publication** : `tauri-apps/tauri-action@v0` crée automatiquement la **GitHub Release**.

Exemple :

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Signature (éviter Gatekeeper / SmartScreen)

Le workflow supporte la signature **macOS** (codesign + notarization) et **Windows** (Authenticode) via des **secrets GitHub**.

### macOS (Developer ID + notarization)

Secrets à ajouter dans GitHub → Settings → Secrets and variables → Actions :

- `APPLE_CERTIFICATE` : certificat `.p12` **encodé en base64**
- `APPLE_CERTIFICATE_PASSWORD` : mot de passe d’export du `.p12`
- `APPLE_SIGNING_IDENTITY` : ex. `Developer ID Application: Nom (TEAMID)`
- `APPLE_ID` : email Apple ID
- `APPLE_PASSWORD` : *app-specific password* Apple
- `APPLE_TEAM_ID` : Team ID (10 caractères)

### Windows (certificat .pfx)

Secrets :

- `WINDOWS_CERTIFICATE_PFX_BASE64` : `.pfx` encodé en base64
- `WINDOWS_CERTIFICATE_PASSWORD` : mot de passe du `.pfx`

Le workflow importe le certificat dans le store du runner Windows et injecte automatiquement le `thumbprint`
dans `src-tauri/tauri.windows.conf.json` pour que Tauri signe les bundles.


🤝 Contribution
Les contributions sont les bienvenues ! Voir CONTRIBUTING.md pour les détails.


🙏 Remerciements
Développé avec ❤️ par Barack Ndenga


## Roadmap “révolutionnaire”

- Brancher un **vrai modèle IA** (local Ollama ou API cloud) + contexte workspace.
- Diagnostics “projet” : ESLint + TypeScript + LSP.
- Filesystem + gestion workspace, terminal réel, Git intégré.
- RAG (embeddings + graphe) et “diff” assisté par IA.


