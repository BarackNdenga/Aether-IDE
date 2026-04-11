#!/bin/bash
# install-linux.sh — Aether IDE installer for Linux
# Usage: curl -fsSL https://raw.githubusercontent.com/USERNAME/aether-ide/main/install-linux.sh | bash

set -e

REPO="USERNAME/aether-ide"

echo "🚀 Aether IDE — Installation Linux"
echo ""

# Détecter la distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

echo "✓ Distribution : $DISTRO"

# Récupérer la dernière release
echo "→ Récupération de la dernière version..."
LATEST=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
echo "✓ Version : $LATEST"

BASE_URL="https://api.github.com/repos/$REPO/releases/latest"

install_deb() {
    URL=$(curl -fsSL "$BASE_URL" | grep "browser_download_url" | grep "amd64.deb" | sed 's/.*"\(.*\)".*/\1/')
    TMP=$(mktemp /tmp/aether-ide-XXXXXX.deb)
    echo "→ Téléchargement .deb..."
    curl -fsSL -o "$TMP" "$URL"
    sudo dpkg -i "$TMP"
    rm -f "$TMP"
}

install_rpm() {
    URL=$(curl -fsSL "$BASE_URL" | grep "browser_download_url" | grep "x86_64.rpm" | sed 's/.*"\(.*\)".*/\1/')
    TMP=$(mktemp /tmp/aether-ide-XXXXXX.rpm)
    echo "→ Téléchargement .rpm..."
    curl -fsSL -o "$TMP" "$URL"
    sudo rpm -i "$TMP" 2>/dev/null || sudo rpm -U "$TMP"
    rm -f "$TMP"
}

install_appimage() {
    URL=$(curl -fsSL "$BASE_URL" | grep "browser_download_url" | grep "AppImage" | sed 's/.*"\(.*\)".*/\1/')
    DEST="$HOME/.local/bin/aether-ide"
    mkdir -p "$HOME/.local/bin"
    echo "→ Téléchargement AppImage..."
    curl -fsSL -o "$DEST" "$URL"
    chmod +x "$DEST"
    # Créer un .desktop
    mkdir -p "$HOME/.local/share/applications"
    cat > "$HOME/.local/share/applications/aether-ide.desktop" << EOF
[Desktop Entry]
Name=Aether IDE
Comment=IDE professionnel avec IA locale
Exec=$DEST
Icon=aether-ide
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF
    echo "✓ AppImage installé dans $DEST"
    echo "  Lance avec : aether-ide"
}

case "$DISTRO" in
    ubuntu|debian|linuxmint|pop|elementary)
        install_deb
        ;;
    fedora|rhel|centos|rocky|almalinux)
        install_rpm
        ;;
    arch|manjaro|endeavouros)
        # AUR pas encore disponible — fallback AppImage
        install_appimage
        ;;
    *)
        echo "→ Distribution non reconnue, installation via AppImage..."
        install_appimage
        ;;
esac

echo ""
echo "✅ Aether IDE installé avec succès !"
echo ""
echo "   IA locale : curl -fsSL https://ollama.ai/install.sh | sh && ollama pull llama3"
echo "   Debugger Python : pip3 install debugpy"
echo "   Debugger Go : go install github.com/go-delve/delve/cmd/dlv@latest"
