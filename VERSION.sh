#!/bin/bash
# Project version information
# Used for tracking releases and builds

PROJECT_NAME="ca.dcloud.ICAClient"
PROJECT_VERSION="2.0.0"
PROJECT_URL="https://github.com/dcloud-ca/ca.dcloud.ICAClient"

# Build information
GNOME_RUNTIME_VERSION="46"
FLATPAK_MANIFEST="ca.dcloud.ICAClient.yml"

# Release information
RELEASE_DATE="2026-02-28"
RELEASE_STATUS="stable"  # alpha, beta, stable

echo "Project: $PROJECT_NAME"
echo "Version: $PROJECT_VERSION"
echo "Status: $RELEASE_STATUS"
echo "GNOME Runtime: $GNOME_RUNTIME_VERSION"
