# Dotfiles

Personal dotfiles and configuration files for macOS development environment.

Includes configuration for:
- **Terminal:** Ghostty with TokyoNight theme
- **Shell:** Zsh with Starship prompt, fzf-tab, zoxide, direnv
- **Editor:** Micro (CLI) + VS Code
- **Git:** Delta diff viewer with smart rebasing
- **Claude Code:** GitHub MCP, custom statusline
- **Tools:** ripgrep, bat, eza, fd, and other modern replacements

## Quick Setup

**Estimated time:** ~5 minutes

### 1. Clone this repo
```bash
git clone https://github.com/lhogan3/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
```

### 2. Install Homebrew packages
```bash
brew bundle install --file=Brewfile
```

### 3. Link configuration files
```bash
./install.sh
```

This will symlink configs to their system locations. Existing files are backed up with `.backup` extension.

### 4. Configure machine-specific overrides
```bash
cp config/zsh/.zshrc.local.example ~/.zshrc.local
# Edit ~/.zshrc.local with machine-specific settings
```

### 5. Restart terminal
```bash
exec zsh
```

## Directory Structure

```
dotfiles/
├── config/                          # Configuration files
│   ├── zsh/                        # Shell config
│   │   ├── .zshrc                 # Main shell config
│   │   ├── .zshrc.local.example   # Machine-specific template
│   │   ├── .zprofile              # Login shell init
│   │   └── .zshenv                # Environment variables
│   ├── ghostty/                    # Terminal config
│   ├── starship/                   # Prompt config
│   ├── git/                        # Git config
│   ├── micro/                      # Micro editor config
│   └── claude-code/                # Claude Code settings
│
├── bin/                            # Custom scripts
│   └── (scripts go here)
│
├── docs/                           # Documentation
│   ├── INSTALLATION.md
│   ├── APPS_MANIFEST.md
│   └── MCP_REFERENCE.md
│
├── Brewfile                        # Homebrew dependencies
├── .gitignore
├── README.md
└── install.sh                      # Bootstrap script
```

## Key Features

### Shell Aliases & Functions
- `ls` → `eza --icons --group-directories-first`
- `cat` → `bat` (syntax highlighting)
- `grep` → `rg` (ripgrep - faster)
- `cd` → `zoxide` (smart directory jumping)
- `help` → `tldr` (practical examples vs. manpages)

**Git shortcuts:**
- `gs` - git status with short format
- `gl` - git log with graph (last 20)
- `gco` - switch branches with fzf preview

### Completions & Previews
- **fzf-tab:** Smart completions with file/directory/env previews
- **Syntax highlighting:** zsh-syntax-highlighting
- **Auto-suggestions:** zsh-autosuggestions with history fallback

### Git Workflow
- **Delta:** Better diff viewer with line numbers
- **Rebasing:** Set as default for pulls
- **Rerere:** Reuse recorded resolution for merge conflicts
- **Zdiff3:** Conflict style for clarity

### Claude Code
- **GitHub MCP:** Access repos, issues, PRs directly
- **Custom statusline:** Shows model, dir, branch, context%, rate limits
- **Rust analyzer:** LSP support for Rust projects
- **Permissions:** Granular control in `settings.local.json`

## Machine-Specific Setup

### Personal Machine
Already configured. Just run `install.sh`.

### Work Machine
1. Clone this repo
2. Run `install.sh`
3. Create work-specific overrides in `~/.zshrc.local`:
   ```bash
   # Example work machine additions:
   export AWS_PROFILE=work
   export WORK_MODE=1
   # Add work-specific functions/aliases
   ```
4. Update `~/.claude/settings.local.json` for work permissions

## Customization

**Shell aliases:** Edit `config/zsh/.zshrc` (reload with `exec zsh`)

**Terminal theme:** Edit `config/ghostty/config` (supports light/dark mode switching)

**Prompt:** Edit `config/starship/config.toml` (Tokyo Night theme)

**Git workflow:** Edit `config/git/config` (currently uses delta + rebase)

**Claude Code:** Edit `config/claude-code/settings.json` (add/remove MCPs)

## Updating

Pull latest changes:
```bash
cd ~/projects/dotfiles && git pull
./install.sh  # Re-symlink if configs changed
exec zsh      # Reload shell
```

## Troubleshooting

**Symbols not showing in prompt?**
- Ensure JetBrainsMono Nerd Font is installed: `brew install font-jetbrains-mono-nerd-font`
- Set your terminal font to JetBrainsMono Nerd Font

**fzf not working?**
- Verify fzf is installed: `brew install fzf`
- Rebuild fzf key bindings: `exec zsh`

**GitHub MCP not connecting?**
- Verify `GITHUB_PERSONAL_ACCESS_TOKEN` is set: `echo $GITHUB_PERSONAL_ACCESS_TOKEN`
- Check Keychain entry: `security find-generic-password -s github-pat`
- Restart Claude Code

**Zsh plugins not loading?**
- Check plugin paths in `.zshrc` match Homebrew install location
- Current paths: `/opt/homebrew/share/` (Apple Silicon)

## References

- [Ghostty docs](https://ghostty.org/)
- [Starship prompt](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [direnv](https://direnv.net/)
- [Delta](https://github.com/dandavison/delta)
- [Claude Code docs](https://claude.com/claude-code)

## License

MIT - Feel free to use and modify for your own setup
