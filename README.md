# ca.dcloud.ICAClient

Build and install the Citrix Workspace app (ICAClient) + HDX RealTime Media Engine for Skype as a Flatpak application for Linux.

**Current Status**: ✅ Actively maintained with CI/CD automation  
**Supported Platform**: GNOME 46 / Flatpak  
**Build Status**: [![Build](https://github.com/dcloud-ca/ca.dcloud.ICAClient/workflows/Build%20and%20Publish%20Flatpak/badge.svg)](https://github.com/dcloud-ca/ca.dcloud.ICAClient/actions)

## Disclaimer

This project and its maintainers are not affiliated with Citrix. This repository does not contain any Citrix software. When you build the Flatpak application using this template, the required packages are obtained from Citrix's website, where Citrix has made the installers available for download.

## Requirements

### System Requirements
- **OS**: Linux (any distribution with Flatpak support)
- **Architecture**: x86_64
- **Memory**: 2GB minimum (4GB recommended)
- **Disk Space**: 2GB for Flatpak installation + 500MB for Workspace
- **Network**: Stable internet connection (for downloading Citrix installers)

### Dependencies

Install these through your distro's package manager:

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y flatpak flatpak-builder elfutils appstream-util
```

**Fedora/RHEL:**
```bash
sudo dnf install -y flatpak flatpak-builder elfutils appstream-util
```

**Arch:**
```bash
sudo pacman -S flatpak flatpak-builder elfutils appstream
```

## Installation Instructions

### Quick Start

1. **Setup Flatpak and install GNOME SDKs:**
   ```bash
   flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46
   ```

2. **Clone and build:**
   ```bash
   git clone https://github.com/dcloud-ca/ca.dcloud.ICAClient.git
   cd ca.dcloud.ICAClient
   flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml
   ```

3. **Launch:**
   - From app launcher: Search for "Citrix Workspace"
   - Or from command line: `flatpak run ca.dcloud.ICAClient`

### Advanced Build Options

**Verbose build with debugging:**
```bash
DEBUG=1 flatpak-builder --user --install --verbose --verbose icaclient ca.dcloud.ICAClient.yml
```

**For musl-based systems** (Alpine, etc.):
```bash
flatpak-builder --user --install --force-clean --disable-rofiles-fuse icaclient ca.dcloud.ICAClient.yml
```

**Build without cleaning cache** (faster, uses cached sources):
```bash
flatpak-builder --user --install icaclient ca.dcloud.ICAClient.yml
```

## Updating

When Citrix publishes new versions:

```bash
cd ca.dcloud.ICAClient
git pull
flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml
```

The `--force-clean` flag ensures you get the latest Citrix installers.

### Version Information

- **Flatpak Runtime**: GNOME 46
- **Citrix Workspace**: Latest version from Citrix downloads
- **HDX RTME**: Latest version from Citrix downloads
- **Version History**: See [CHANGELOG.md](CHANGELOG.md)

## Troubleshooting

### Build Issues

**"Platform not found" error**
```bash
# Install the correct GNOME SDK
flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46
```

**Download from Citrix fails**
- The build script has automatic retry logic (3 attempts)
- Citrix website may be temporarily unavailable
- Check network connectivity: `curl -I https://www.citrix.com/downloads/`
- Enable debug mode: `DEBUG=1 flatpak-builder ...`

**Build takes too long / times out**
- First build: 30-60+ minutes (normal)
- Rebuild: 10-20 minutes (with caching)
- Slow networks: Consider running overnight

**"UtilDaemon hangs"**
- Known Citrix issue; run script has cleanup
- Manual cleanup: `pkill --signal 9 UtilDaemon`

### Runtime Issues

**Cannot connect to session**
```bash
# 1. Check network
ping 8.8.8.8

# 2. Check Citrix ports (usually 1494, 2598)
netstat -tan | grep -E '1494|2598'

# 3. Launch with debug output
DEBUG=1 flatpak run ca.dcloud.ICAClient
```

**Audio/Video not working**
```bash
# Rebuild with latest SDK
flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml

# Check audio system
pactl info              # PulseAudio
pw-status              # PipeWire
flatpak info --show ca.dcloud.ICAClient  # Check permissions
```

**Application crashes**
```bash
# Run with debug logging
DEBUG=1 flatpak run ca.dcloud.ICAClient

# Check application logs
cat ~/.var/app/ca.dcloud.ICAClient/.ICAClient/logs/*

# Check system journal
journalctl -xe | grep -i icaclient
```

**Permission denied errors**
- Verify persistent storage is enabled: `--persist=.`
- Check directory permissions:
  ```bash
  ls -la ~/.var/app/ca.dcloud.ICAClient/
  ```

### Uninstall

```bash
# Remove the app
flatpak uninstall ca.dcloud.ICAClient

# Remove SDKs (optional, if not used by other apps)
flatpak uninstall org.gnome.Platform//46 org.gnome.Sdk//46

# Remove all app data
rm -rf ~/.var/app/ca.dcloud.ICAClient

# Clean build artifacts
rm -rf icaclient ~/.cache/flatpak/
```

## Technical Details

### Sandbox Permissions

This Flatpak uses a restricted sandbox with only necessary permissions:

```yaml
finish-args:
  --device=dri         # GPU rendering
  --device=input       # Keyboard/mouse
  --device=videodev    # Webcam
  --device=snd         # Audio
  --share=network      # Network access
  --socket=x11         # X11 display
  --socket=wayland     # Wayland display
  --socket=pulseaudio  # Audio output
  --share=ipc          # X11 IPC
  --persist=.          # Home directory access
```

### Build Dependencies

- **gtk2** - Legacy GUI toolkit (Citrix requirement)
- **libjson-c** - JSON parsing
- **libxerces-c** - XML parsing (Self-Service UI)
- **gst-plugins-ugly** - GStreamer multimedia plugins
- **gnome-keyring** - Service continuity

### File Locations

Inside the Flatpak container:
- **Installation**: `/app/ICAClient/linuxx64/`
- **Configuration**: `~/.var/app/ca.dcloud.ICAClient/.ICAClient/`
- **Caches**: `~/.var/app/ca.dcloud.ICAClient/.cache/`
- **Logs**: `~/.var/app/ca.dcloud.ICAClient/.ICAClient/logs/`

## Project Status

✅ **Actively Maintained**

### Known Limitations

Tested and working:
- ✅ Remote PC connectivity
- ✅ Skype for Business (via HDX RTME)
- ✅ Basic session management
- ✅ Self-Service catalog

May not work:
- ❌ USB device passthrough
- ❌ Some accessibility features (AT-SPI)
- ❌ Advanced corporate features
- ❌ Some webcam configurations

### Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to report issues
- Development setup
- Submission guidelines

### Automation

This project uses GitHub Actions for:
- **Building** on every push to main and pull requests
- **Linting** code quality checks (shellcheck, yamllint, etc.)
- **Publishing** releases with checksums
- **Validation** of desktop/appdata files

See [.github/workflows/](.github/workflows/) for automation details.

## Performance Tips

- **First build**: 30-60 minutes on average hardware
- **Rebuild**: 10-20 minutes (benefits from caching)
- **Slow systems**: Consider overnight builds or `--disable-download`

## Resources

- [Flatpak Documentation](https://docs.flatpak.org/)
- [Citrix Workspace for Linux Docs](https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/)
- [GitHub Issues](https://github.com/dcloud-ca/ca.dcloud.ICAClient/issues)
- [Releases](https://github.com/dcloud-ca/ca.dcloud.ICAClient/releases)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).

**Citrix Workspace** is proprietary software licensed separately by Citrix Systems Inc.
