# Contributing to ca.dcloud.ICAClient

First off, thank you for considering contributing to this project! It's people like you that make ca.dcloud.ICAClient such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our implicit Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [issue list](https://github.com/dcloud-ca/ca.dcloud.ICAClient/issues) as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

**Describe the bug:**
- A clear and concise description of what the bug is
- Steps to reproduce the behavior
- Expected behavior
- Actual behavior

**System Information:**
- OS and version: `uname -a`
- Flatpak version: `flatpak --version`
- GNOME version: `gnome-shell --version` (or check Settings)
- Citrix Workspace version (if known)
- Output of `flatpak info --show ca.dcloud.ICAClient`

**Build Information (if applicable):**
- Build command used
- Build log (use `DEBUG=1` for verbose output)
- Error messages (full output, not truncated)
- Last few lines of `/tmp/icaclient/setupwfc.log` if available

**Example:**
```
I'm unable to connect after building successfully.

Steps to reproduce:
1. Build with flatpak-builder
2. Launch Citrix Workspace
3. Try to connect to example.citrixcloud.com

Expected: Connection prompt
Actual: Segmentation fault

Environment:
- Ubuntu 24.04
- Flatpak 1.14.4
- GNOME 46
- Error in journal: [See attached]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Please provide:

- **Use case**: Why would this feature be useful?
- **Current workaround**: Is there a way to achieve this currently?
- **Implementation notes**: Any ideas on how to implement it?

### Pull Requests

The process described here has several goals:

- Maintain code quality
- Fix problems that are important to users
- Engage the community in working toward the best possible content

Please follow these steps for your contribution:

1. **Fork the repository** and create your branch from `main`
   ```bash
   git clone https://github.com/YOUR_USERNAME/ca.dcloud.ICAClient.git
   cd ca.dcloud.ICAClient
   git checkout -b my-feature-branch
   ```

2. **Set up development environment**
   ```bash
   # Install linting tools (optional but recommended)
   sudo apt-get install shellcheck yamllint desktop-file-utils
   ```

3. **Make your changes**
   - Follow the existing code style
   - Test your changes thoroughly
   - Update documentation if needed

4. **Validate your changes**
   ```bash
   # Lint shell scripts
   shellcheck install.sh run.sh
   
   # Lint YAML manifest
   yamllint ca.dcloud.ICAClient.yml
   
   # Validate desktop file
   desktop-file-validate ca.dcloud.ICAClient.desktop
   
   # Test build (optional - takes time)
   flatpak-builder --user --install --force-clean test-build ca.dcloud.ICAClient.yml
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin my-feature-branch
   ```

7. **Open a Pull Request**
   - Provide a clear description of what you changed and why
   - Reference any related issues: `Fixes #123`
   - Include screenshots for UI changes (if applicable)
   - Wait for CI/CD checks to pass

## Development Guidelines

### Commit Messages

- Use the present tense: "Add feature" not "Added feature"
- Use the imperative mood: "Move cursor to..." not "Moves cursor to..."
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

**Example:**
```
Add retry logic to download handling

Improves robustness when Citrix downloads fail temporarily.
Implements 3 automatic retry attempts with exponential backoff.

Fixes #42
```

### Shell Script Style

- Use `#!/bin/bash` with `set -euo pipefail`
- Quote all variables: `"$variable"` not `$variable`
- Add error traps: `trap 'echo "ERROR at line $LINENO"' ERR`
- Use meaningful variable names
- Add comments for complex logic

**Example:**
```bash
#!/bin/bash
set -euo pipefail

# Function with proper error handling
download_file() {
  local url="$1"
  local output="$2"
  
  if ! wget -q "$url" -O "$output"; then
    echo "ERROR: Failed to download from $url"
    return 1
  fi
}
```

### YAML Manifest Style

- Indent with 2 spaces (not tabs)
- Keep lines under 100 characters when possible
- Add comments explaining non-obvious sections
- Use consistent naming conventions

### Documentation

- Use clear, simple English
- Include examples where helpful
- Update README.md and CHANGELOG.md for significant changes
- Keep docs adjacent to code when possible

## Testing

### Manual Testing

Before submitting a PR, please test:

1. **Build succeeds**
   ```bash
   flatpak-builder --user --install --force-clean test ca.dcloud.ICAClient.yml
   ```

2. **Application launches**
   ```bash
   flatpak run ca.dcloud.ICAClient
   ```

3. **Lint checks pass**
   ```bash
   shellcheck install.sh run.sh
   yamllint ca.dcloud.ICAClient.yml
   desktop-file-validate ca.dcloud.ICAClient.desktop
   ```

### Automated Testing

Your PR will automatically be checked by:

- **shellcheck** - Shell script analysis
- **yamllint** - YAML syntax and style
- **desktop-file-validate** - Desktop entry validation
- **appstream-util** - AppData file validation
- **Flatpak build** - Actual build test (in container)

Ensure all checks pass before requesting review.

## Project Structure

```
ca.dcloud.ICAClient/
├── .github/
│   └── workflows/              # GitHub Actions CI/CD
│       ├── build-flatpak.yml   # Main build workflow
│       └── lint.yml            # Code quality checks
├── ca.dcloud.ICAClient.yml     # Flatpak manifest
├── ca.dcloud.ICAClient.desktop # Desktop entry
├── ca.dcloud.ICAClient.appdata.xml  # AppData
├── install.sh                  # Installation script
├── run.sh                       # Runtime script
├── README.md                    # Documentation
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md             # This file
└── LICENSE                      # MIT License
```

## Key Files

### `ca.dcloud.ICAClient.yml`
The Flatpak build manifest. Defines:
- Base runtime (GNOME 46)
- Build dependencies
- Sandbox permissions
- Build steps

### `install.sh`
Runs during build to:
- Configure Citrix installer
- Set up HDX RTME
- Install application

### `run.sh`
Runs when application starts:
- Sets up required directories
- Cleans temporary files
- Starts services
- Cleanup on exit

## Release Process

Releases are handled by maintainers. Current maintainers:
- @dcloud-ca (original author)
- Maintainer TBD

To get a release published:
1. Submit PR with your changes
2. Wait for review and merge to `main`
3. Create a GitHub issue requesting release #.#.#
4. Release will be created with automated builds

## Recognition

Contributors will be:
- Listed in release notes
- Thanked in commit messages
- Recognized in GitHub contributors page

## Questions?

Feel free to:
- Open an issue for questions
- Start a discussion in GitHub Discussions
- Check existing issues/PRs for answers

## Additional Resources

- [Flatpak Documentation](https://docs.flatpak.org/)
- [Flatpak Development Guide](https://docs.flatpak.org/en/latest/building-introduction.html)
- [YAML Specification](https://yaml.org/)
- [Shell Script Best Practices](https://mywiki.wooledge.org/BashGuide)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thanks for helping make ca.dcloud.ICAClient better!** 🎉
