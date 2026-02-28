#!/bin/bash
# setup-dev.sh - Development environment setup script
# Usage: ./setup-dev.sh

set -euo pipefail

echo "🔧 Setting up development environment for ca.dcloud.ICAClient"
echo

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

echo "Detected OS: $OS"

# Install dependencies based on OS
case "$OS" in
    ubuntu|debian)
        echo "📦 Installing dependencies for Debian/Ubuntu..."
        sudo apt-get update
        sudo apt-get install -y \
            flatpak \
            flatpak-builder \
            elfutils \
            appstream \
            appstream-util \
            desktop-file-utils \
            yamllint \
            shellcheck \
            git
        ;;
    fedora|rhel|centos)
        echo "📦 Installing dependencies for Fedora/RHEL..."
        sudo dnf install -y \
            flatpak \
            flatpak-builder \
            elfutils \
            appstream \
            appstream-util \
            desktop-file-utils \
            yamllint \
            ShellCheck \
            git
        ;;
    arch|manjaro)
        echo "📦 Installing dependencies for Arch..."
        sudo pacman -S --noconfirm \
            flatpak \
            flatpak-builder \
            elfutils \
            appstream \
            appstream-util \
            desktop-file-utils \
            yamllint \
            shellcheck \
            git
        ;;
    *)
        echo "⚠️  Unknown OS: $OS"
        echo "Please install the following manually:"
        echo "  - flatpak, flatpak-builder"
        echo "  - elfutils, appstream, appstream-util"
        echo "  - desktop-file-utils, yamllint, shellcheck"
        ;;
esac

echo
echo "📚 Setting up Flatpak..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing GNOME 46 SDK and Runtime..."
flatpak install --user --noninteractive \
    org.gnome.Platform//46 \
    org.gnome.Sdk//46

echo
echo "✅ Development environment setup complete!"
echo
echo "Next steps:"
echo "  1. Read the CONTRIBUTING.md file"
echo "  2. Make your changes"
echo "  3. Test with: make lint && make build"
echo "  4. Submit a pull request"
