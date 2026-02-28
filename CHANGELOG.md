# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-02-28

### Added
- **CI/CD Pipeline**: Comprehensive GitHub Actions workflow for automated building and publishing
  - Automatic builds on push, pull requests, and tags
  - Build validation and linting (shellcheck, yamllint, desktop-file-validate, appstream-util)
  - Automated GitHub Releases with checksums
  - Support for workflow dispatch (manual triggering)
  
- **Security Improvements**: Replaced overly permissive `--device=all` with specific device permissions
  - `--device=dri` - GPU access only
  - `--device=input` - Keyboard/mouse
  - `--device=videodev` - Webcam  
  - `--device=snd` - Audio device

- **Build Robustness**: Enhanced download reliability with retry logic
  - 3 automatic retry attempts for Citrix downloads
  - Better error messages and progress reporting
  - Graceful fallback when HDX RTME is unavailable
  - Improved SSL certificate handling

- **Shell Script Improvements**:
  - Added `set -e` and `set -u` for robust error handling
  - Error trap handlers that report line numbers
  - Debug mode support via `DEBUG=1` environment variable
  - Improved variable quoting for edge cases
  - Better error messages throughout

- **Documentation**:
  - Comprehensive README with troubleshooting section
  - Installation instructions per Linux distro
  - Technical details on sandbox permissions
  - Known limitations and feature status
  - Links to resources and support

- **New Files**:
  - `CONTRIBUTING.md` - Contribution guidelines
  - `CHANGELOG.md` - This file
  - `.github/workflows/build-flatpak.yml` - Main build and publish workflow
  - `.github/workflows/lint.yml` - Code quality validation workflow

### Changed
- **Runtime Upgrade**: Updated GNOME Platform/SDK from 41 → 46
  - Improved security patches
  - Better hardware support
  - Modern dependent library versions
  
- **Downloads**: Enhanced Citrix website scraping
  - Better error handling for website structure changes
  - Retry logic prevents transient failures
  - Timeout handling (60 seconds per download)
  - Better progress indication

- **Icon Handling**: Improved error handling when icons are missing
  - Build continues if icon extraction fails (with warning)
  - More informative error messages

- **Process Management in run.sh**:
  - Better cleanup of background processes
  - Improved UtilDaemon termination
  - Better handling of temporary directories

### Fixed
- Shell scripts now exit with proper error codes
- Variable quoting prevents issues with spaces and special characters
- Process cleanup more reliable (uses `|| true` to prevent failures)
- Directory existence checks before operations
- Improved tmpdir cleanup (uses `|| true` to prevent hanging)

### Deprecated
- Nothing formally deprecated yet

### Removed
- Removed overly permissive device access

### Security
- Restricted Flatpak sandbox permissions significantly
- Added CI/CD validation for security issues (via trufflehog)
- Better handling of sensitive operations

## [1.0.0] - 2021-08-22

### Added
- Initial release
- Flatpak build manifest for Citrix Workspace
- HDX RTME integration for Skype
- Installation and run scripts
- Desktop entry and AppData files
- Support for GNOME Platform 41

---

## Version Compatibility Matrix

| ca.dcloud.ICAClient | GNOME Runtime | Flatpak | Citrix Workspace | Status |
|---|---|---|---|---|
| 2.0.0+ | 46 | 1.14+ | Latest | ✅ Current |
| 1.0.0 | 41 | 1.0+ | Latest | ⚠️ Deprecated |

## Future Roadmap

### Planned for 2.1.0
- [ ] Multi-architecture support (ARM64)
- [ ] Optional USB support (privileged builds)
- [ ] AppChart repository integration
- [ ] Improved version pinning mechanism
- [ ] Automated testing framework

### Under Consideration
- [ ] Flathub submission
- [ ] Snap package support
- [ ] Desktop portal integration
- [ ] Automatic update checking
- [ ] Web proxy support

## Migration Guide

### From 1.0.0 to 2.0.0

**Key changes:**
1. GNOME runtime upgraded from 41 to 46
2. Device permissions now restricted (more secure)
3. Build requires updated tools

**Steps to upgrade:**
```bash
# Clean old build
rm -rf icaclient ~/.flatpak-builder

# Update dependencies
flatpak install --user --update org.gnome.Platform//46 org.gnome.Sdk//46

# Pull latest code
git pull

# Rebuild
flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml
```

## Notes

- **Build Time**: First build may take 30-60 minutes; rebuilds typically 10-20 minutes
- **Network**: Requires stable internet connection to download Citrix installers
- **Citrix Versions**: Application automatically grabs latest versions from Citrix CDN each build
- **Support**: This is a community project; not officially supported by Citrix

## See Also

- [README](README.md) - Full documentation
- [CONTRIBUTING](CONTRIBUTING.md) - How to contribute
- [Issues](https://github.com/dcloud-ca/ca.dcloud.ICAClient/issues) - Bug reports and feature requests
- [Releases](https://github.com/dcloud-ca/ca.dcloud.ICAClient/releases) - Release artifacts
