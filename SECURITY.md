# Security Policy

## Reporting Security Issues

**Please do NOT publicly report security issues.**

If you discover a security vulnerability in ca.dcloud.ICAClient, please email the maintainers privately at the GitHub email instead of using the public issue tracker.

Include in your report:
- Description of the vulnerability
- Steps to reproduce 
- Potential impact
- Any known mitigations

We will acknowledge receipt within 48 hours and provide an estimated timeline for a fix.

## Security Considerations

### Sandbox Isolation

ca.dcloud.ICAClient runs Citrix Workspace in a Flatpak sandbox with restricted permissions:

✅ **Restricted to:**
- Network access (required for Citrix)
- GPU access (for rendering)
- Audio/video devices (for communication)
- Persistent home directory (for user configuration)
- X11/Wayland display servers

❌ **NOT allowed:**
- USB device access
- Direct hardware access (with exceptions above)
- Unrestricted filesystem access
- System service communication
- Installation of additional packages

### Trust Model

**What you are trusting:**
1. **Citrix Systems Inc.** - The Citrix Workspace application itself
2. **Container Images** - GNOME Platform/SDK from Flathub
3. **Build Process** - Our CI/CD pipeline and build scripts
4. **This Repository** - Our overlay code (shell scripts, configuration)

**What is NOT trusted:**
- Only downloads from official Citrix sources
- Validates all build scripts through Git workflows
- Uses pinned dependency versions where possible

### Flatpak Security Features Used

- **Filesystem Sandbox**: Restricted to `/app` and `~/.var/app/ca.dcloud.ICAClient`
- **Network Sandbox**: Only TCP/UDP sockets exposed
- **Permission Model**: Explicit declaration of all required capabilities
- **Signature Verification**: Flatpak remote uses secure HTTPS

### Supply Chain Security

**Build Pipeline:**
- ✅ All builds run in GitHub Actions (auditable, reproducible)
- ✅ No external secrets stored in repository
- ✅ Code review required for all changes
- ✅ Automated security scanning (trufflehog) for secrets
- ✅ Signed releases with checksums

**Dependencies:**
- GNOME Platform/SDK v46 - Official distribution from Flathub
- Citrix Workspace - Downloaded directly from Citrix CDN (SSL verified)
- HDX RTME - Downloaded directly from Citrix CDN (SSL verified)
- Build dependencies - All from Ubuntu repos with checksum verification

### Known Security Limitations

1. **Citrix Workspace Security**
   - Subject to Citrix's own security practices
   - Some Citrix security features may not work in Flatpak
   - USB redirection disabled in this build (security improvement)

2. **Network Communication**
   - All traffic between you and Citrix server is handled by Citrix
   - Network access is not restricted by Flatpak (required)
   - Use VPN/firewall for additional security if needed

3. **Credential Storage**
   - Credentials are managed by Citrix Workspace
   - Stored in `~/.var/app/ca.dcloud.ICAClient/.ICAClient/`
   - Protected by user account permissions (standard Unix permissions)
   - Optional: Use GNOME Keyring for additional protection

### Recommendations

1. **Keep your system updated:**
   ```bash
   flatpak update
   sudo apt update && sudo apt upgrade  # or equivalent for your distro
   ```

2. **Regular backups:**
   ```bash
   # Backup Citrix configuration
   cp -r ~/.var/app/ca.dcloud.ICAClient ~/.var/app/ca.dcloud.ICAClient.backup
   ```

3. **Firewall configuration:**
   - Use UFW/firewalld to restrict outbound connections if needed
   - Citrix typically uses ports 1494 (ICA) and 2598 (Citrix gateway)

4. **Monitor permissions:**
   ```bash
   # Check current permissions
   flatpak info --show ca.dcloud.ICAClient
   ```

5. **Use strong credentials:**
   - Enable multi-factor authentication in Citrix cloud console
   - Use strong passwords
   - Consider using PIN+ physical authentication

### Security Updates

This project will:
- ✅ Update GNOME runtime regularly for security patches
- ✅ Patch shell scripts for identified vulnerabilities
- ✅ Update Citrix Workspace automatically (latest version on each build)
- ✅ Monitor CVE databases for relevant issues

Project maintainers will publish security advisories for:
- Critical vulnerabilities in build code
- Important misconfigurations in Flatpak permissions
- Supply chain security issues

## Reporting Vulnerabilities in Dependencies

If you find a vulnerability in upstream projects:
- **Citrix Workspace**: Report to Citrix (security@citrix.com)
- **GNOME/Flatpak**: Report to GNOME/Flatpak security teams
- **Ubuntu packages**: Report to Ubuntu security team

Please also notify us if the vulnerability affects this build.

## Audit Trail

### Build Security Audit

1. **Source Code**: Reviewed in Git history
2. **Build Manifest**: Validated by YAML linting
3. **Permissions**: Explicitly declared and minimal
4. **Secrets**: Scanned by trufflehog (no secrets should be committed)
5. **Build Reproducibility**: Same manifest produces same build

### Access Control

- Requires GitHub write access to approve/merge changes
- CI/CD has no persistent secrets (uses GitHub Actions tokens)
- No hardcoded credentials in code or manifests

## Contact

- **Security Reports**: Contact maintainers privately
- **General Issues**: GitHub Issues
- **Discussions**: GitHub Discussions

---

**Last Updated**: 2026-02-28  
**Maintained By**: ca.dcloud.ICAClient contributors  
**Security Policy Version**: 1.0
