# Applications Manifest

Documented applications and why each is installed.

## Tier 1: Essential

| App | Purpose | Alternative | Why This One |
|-----|---------|-------------|-------------|
| **Ghostty** | Terminal | iTerm2, Alacritty, Kitty | Best macOS integration, excellent theming, shell integration |
| **Zen** | Browser | Firefox, Safari, Chrome | Firefox-based, fast, customizable, no tracking |
| **Bitwarden** | Password Manager | 1Password, Keychain | Open-source, self-hostable, has SSH agent |
| **VS Code** | IDE | Neovim, Helix, Zed | Best ecosystem, extensions, debugger support |
| **Raycast** | Launcher | Alfred, Spotlight | Superior dev workflows, scriptable, fast |

## Tier 2: Development

| App | Purpose | Installation | Status |
|-----|---------|--------------|--------|
| **OrbStack** | Container runtime | Docker Desktop | Faster, lighter, better macOS integration |
| **Micro** | Text editor (CLI) | Nano, Vim, Neovim | Simple, intuitive, good defaults |
| **Git + Delta** | Version control | Included | Delta improves diff viewing |

## Tier 3: Optional/Utility

| App | Purpose | Install | Notes |
|-----|---------|---------|-------|
| **Discord** | Team chat | ✅ | Using for team communication |
| **Spotify** | Music | ✅ | Daily use |
| **GarageBand** | Audio | ✅ | Music production (occasional) |

## Tier 4: macOS Built-in

- Safari (backup browser)
- Finder (file manager)
- Mail (if needed)

## Development Languages/Runtimes

| Language | Status | Version | Use Case |
|----------|--------|---------|----------|
| **Node.js** | ✅ | Latest | Web dev, tooling |
| **Python** | ✅ | 3.14 | Scripts, data work |
| **Rust** | Optional | Via rustup | Systems programming |
| **Go** | Optional | Via Homebrew | CLI tools |

## Homebrew Packages (93 installed)

### Core Tools (Essential)
- `bat` - cat replacement with syntax highlighting
- `eza` - ls replacement with git status and icons
- `ripgrep` - grep replacement (faster)
- `fd` - find replacement (faster)
- `fzf` - Fuzzy finder for shell
- `zoxide` - Smart cd replacement
- `direnv` - Directory-specific env vars
- `tldr` - man pages with practical examples

### Development
- `git` - Version control
- `git-delta` - Enhanced diff viewer
- `node` - JavaScript runtime
- `python@3.14` - Python interpreter
- `neovim` - Vim replacement (optional)
- `gh` - GitHub CLI

### System
- `gnupg` - GPG encryption
- `jq` - JSON processor
- `starship` - Prompt
- `zsh-autosuggestions` - Shell completions
- `zsh-syntax-highlighting` - Shell syntax coloring

### Fonts
- `font-jetbrains-mono-nerd-font` - Nerd font for terminal

## Recommendations for Work Machine

**Add these:**
- AWS CLI (`aws-cli`)
- Kubernetes tools (`kubectl`, `helm`)
- Docker (or use OrbStack)
- Company VPN client
- Terraform (if infrastructure work)
- GraphQL client (`insomnia` or `postman`)

**Consider:**
- `lazygit` - Git UI for complex workflows
- `taskwarrior` - Task tracking from CLI
- `bottom` - System monitor (like htop)
- `navi` - Interactive cheatsheet

## System Performance Notes

- Total Homebrew packages: 93 formula, 4 cask
- Startup time with all plugins: ~200ms (acceptable)
- Memory usage: ~50MB idle (very light)
- Disk usage: ~300MB for all tools (manageable)

## Regular Maintenance

**Monthly:**
```bash
brew update
brew upgrade
brew cleanup --prune=30
```

**Quarterly:**
```bash
brew autoremove  # Remove unused dependencies
```

## Removal Candidates

Review these for unused status:
- `firefoxpwa` - PWA support (verify if used)
- Any old formula versions after cleanup

---

**Last updated:** 2026-09-24  
**System:** macOS (Apple Silicon / M1+)
