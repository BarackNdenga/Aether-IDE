#!/bin/bash
# install-macos.sh — Aether IDE installer for macOS
# Usage: curl -fsSL https://raw.githubusercontent.com/USERNAME/aether-ide/main/install-macos.sh | bash

set -e

REPO="USERNAME/aether-ide"
APP_NAME="Aether IDE"
INSTALL_DIR="/Applications"

echo "🚀 Aether IDE — Installation macOS"
echo ""

# Détecter l'architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    ASSET_PATTERN="aarch64.dmg"
    echo "✓ Architecture : Apple Silicon (M1/M2/M3)"
else
    ASSET_PATTERN="x64.dmg"
    echo "✓ Architecture : Intel x86_64"
fi

# Récupérer la dernière release
echo "→ Récupération de la dernière version..."
LATEST=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
echo "✓ Version : $LATEST"

# Trouver l'URL du DMG
DMG_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep "browser_download_url" \
    | grep "$ASSET_PATTERN" \
    | sed 's/.*"browser_download_url": "\(.*\)".*/\1/')

if [ -z "$DMG_URL" ]; then
    echo "✗ Impossible de trouver le DMG pour $ARCH"
    echo "  Téléchargez manuellement : https://github.com/$REPO/releases/latest"
    exit 1
fi

# Télécharger
TMP_DMG=$(mktemp /tmp/aether-ide-XXXXXX.dmg)
echo "→ Téléchargement..."
curl -fsSL -o "$TMP_DMG" "$DMG_URL"
echo "✓ Téléchargé"

# Monter le DMG
echo "→ Montage du DMG..."
MOUNT_POINT=$(hdiutil attach "$TMP_DMG" -nobrowse -quiet | tail -1 | awk '{print $NF}')

# Copier l'app
echo "→ Installation dans $INSTALL_DIR..."
if [ -d "$INSTALL_DIR/$APP_NAME.app" ]; then
    rm -rf "$INSTALL_DIR/$APP_NAME.app"
fi
cp -R "$MOUNT_POINT/$APP_NAME.app" "$INSTALL_DIR/"

# Démonter
hdiutil detach "$MOUNT_POINT" -quiet
rm -f "$TMP_DMG"

# Retirer la quarantaine Gatekeeper (clé pour les apps non signées)
echo "→ Configuration Gatekeeper..."
xattr -cr "$INSTALL_DIR/$APP_NAME.app"
echo "✓ Quarantaine retirée"

echo ""
echo "✅ Aether IDE installé avec succès !"
echo "   Lance-le depuis Applications ou avec : open -a 'Aether IDE'"
echo ""
echo "   IA locale : ollama pull llama3"
echo "   Debugger Python : pip3 install debugpy"
