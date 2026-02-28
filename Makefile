#!/bin/bash
# Makefile equivalent for convenience
# Usage: make build, make lint, make clean, etc.

.PHONY: help lint build build-verbose build-clean test install uninstall setup-dev

help:
	@echo "ca.dcloud.ICAClient - Development Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  lint              - Run linting checks (yamllint, shellcheck)"
	@echo "  validate          - Validate desktop, appdata, and manifest files"
	@echo "  build             - Build the Flatpak"
	@echo "  build-verbose     - Build with verbose output"
	@echo "  build-clean       - Force clean build (removes cache)"
	@echo "  build-quick       - Build with existing cache"
	@echo "  install           - Build and install"
	@echo "  uninstall         - Uninstall the Flatpak"
	@echo "  run               - Run the application"
	@echo "  test              - Run all checks (lint + validate)"
	@echo "  clean             - Clean build artifacts"
	@echo "  debug             - Run with debug output"
	@echo "  setup-dev         - Setup development environment"
	@echo "  version           - Show version info"
	@echo ""

lint:
	@echo "🔍 Running linting checks..."
	@shellcheck install.sh run.sh setup-dev.sh || true
	@yamllint -d .yamllint ca.dcloud.ICAClient.yml || true
	@echo "✅ Linting complete"

validate:
	@echo "🔎 Validating project files..."
	@desktop-file-validate ca.dcloud.ICAClient.desktop
	@appstream-util validate-relax ca.dcloud.ICAClient.appdata.xml
	@echo "✅ Validation complete"

test: lint validate
	@echo "✅ All checks passed"

build:
	@echo "🏗️  Building Flatpak..."
	flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml

build-verbose:
	@echo "🏗️  Building Flatpak (verbose)..."
	DEBUG=1 flatpak-builder --user --install --verbose --verbose --force-clean icaclient ca.dcloud.ICAClient.yml

build-clean: clean build

build-quick:
	@echo "🏗️  Building Flatpak (quick rebuild)..."
	flatpak-builder --user --install icaclient ca.dcloud.ICAClient.yml

install: build

uninstall:
	@echo "🗑️  Uninstalling Flatpak..."
	flatpak uninstall ca.dcloud.ICAClient
	rm -rf ~/.var/app/ca.dcloud.ICAClient

run:
	@echo "🚀 Launching Citrix Workspace..."
	flatpak run ca.dcloud.ICAClient

debug:
	@echo "🐛 Launching with debug output..."
	DEBUG=1 flatpak run ca.dcloud.ICAClient

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf icaclient build.log build-report.md
	@echo "✅ Cleanup complete"

setup-dev:
	@bash ./setup-dev.sh

version:
	@bash ./VERSION.sh

.PHONY: help lint validate test build build-verbose build-clean build-quick install uninstall run debug clean setup-dev version
