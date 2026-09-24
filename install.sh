#!/bin/bash
# Bootstrap script for dotfiles setup
# Symlinks configuration files to their system locations
# Backs up existing files with .backup extension

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backups/$(date +%Y-%m-%d_%H-%M-%S)"
SYMLINKS=()

echo "🔗 Installing dotfiles..."
echo "📁 Dotfiles directory: $DOTFILES_DIR"
echo "💾 Backups will go to: $BACKUP_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
symlink() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    echo "⚠️  Skipping (not found): $source"
    return
  fi

  # Create target directory if needed
  mkdir -p "$(dirname "$target")"

  # Backup existing file/symlink
  if [[ -e "$target" ]] || [[ -L "$target" ]]; then
    echo "💾 Backing up: $target"
    mv "$target" "$BACKUP_DIR/$(basename $target).backup"
  fi

  # Create symlink
  ln -s "$source" "$target"
  echo "✅ Linked: $target → $source"
  SYMLINKS+=("$target")
}

# Zsh config
symlink "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES_DIR/config/zsh/.zshenv" "$HOME/.zshenv"
symlink "$DOTFILES_DIR/config/zsh/.zprofile" "$HOME/.zprofile"

# Ghostty
symlink "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

# Starship
symlink "$DOTFILES_DIR/config/starship/config.toml" "$HOME/.config/starship/config.toml"

# Git
symlink "$DOTFILES_DIR/config/git/config" "$HOME/.gitconfig"

# Micro editor
symlink "$DOTFILES_DIR/config/micro/settings.json" "$HOME/.config/micro/settings.json"

# Claude Code
symlink "$DOTFILES_DIR/config/claude-code/settings.json" "$HOME/.claude/settings.json"
symlink "$DOTFILES_DIR/config/claude-code/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Copy machine-specific config: cp $DOTFILES_DIR/config/zsh/.zshrc.local.example ~/.zshrc.local"
echo "  2. Edit ~/.zshrc.local with your environment"
echo "  3. Reload shell: exec zsh"
echo ""
echo "💾 Backups saved to: $BACKUP_DIR"
echo ""
