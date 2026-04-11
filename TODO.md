# Aether IDE - Plan d'implémentation pour IDE compétitif

## Statut: En cours (0/18 étapes complétées)

### 1. PRIORITÉ 1: LSP complet ✅
Backend LSP implémenté (lib.rs spawn + pipe)
Frontend: workspacePath + Open Workspace button + startLsp + registerProviders + diagnostics markers
**Test: Open workspace → edit TS → test completion/hover/errors**


### 2. PRIORITÉ 2: Arborescence FS réelle ✅
FileTree: arbre récursif fs_read_dir, expand/load, icons, workspace, fallback buttons (no context menu yet)

### 3. PRIORITÉ 3: Éditeur split
- [ ] App.tsx: Panels éditeurs resizeables (react-resizable)

### 4. UX Native
- [ ] tauri.conf.json: Menus natifs (File/Edit/View) + systemTray
- [ ] Drag & drop fichiers HTML5
- [ ] tauri-plugin-notification pour toasts système

### 5. Thèmes + Settings persistants
- [ ] Nouveau SettingsPanel (sidebar)
- [ ] tauri-plugin-store pour persist
- [ ] Monaco theme switch + CSS themes

### 6. Multi-workspace + Watcher UI
- [ ] État workspaceRoot, fs_watch updates live tree

### 7. Optimisations
- [ ] vite.config.ts: Code splitting (lazy Monaco etc.)
- [ ] Vérif bundle size post-build

### 8. Paiement/subscription renforcé
- [ ] Backend license_validate: Vérif Stripe API réelle (reqwest)
- [ ] Trial/nag screens (LSP/Git Pro-only)
- [ ] Webhook Stripe pour updates auto

### 9. Polish
- [ ] Taskbar icon actions
- [ ] Vim support (PTY déjà OK)
- [ ] Test bundle <100KB JS
- [ ] Docs mise à jour

## Pricing confirmé: Pro 19€/mois, Team 49€/mois, Lifetime 199€ ✓

## Dépendances à installer après plan approval
```
src-tauri: cargo add reqwest serde_json tokio --features=process
frontend: npm i react-resizable @tauri-apps/plugin-store
tauri.conf: plugins notification store
```

