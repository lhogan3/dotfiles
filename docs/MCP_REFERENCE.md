# Claude Code MCP (Model Context Protocol) Reference

## Currently Enabled MCPs

| MCP | Purpose | Status | Auth |
|-----|---------|--------|------|
| **GitHub** | Repos, issues, PRs, code search | ✅ Active | GitHub PAT (Keychain) |
| **Rust Analyzer** | Rust LSP support | ✅ Active | N/A |
| **Sleeper** | Fantasy football league management | ✅ Active | API key |

## Setup

### GitHub MCP

**Why:** Access repos, issues, PRs, code search directly in Claude Code without leaving the terminal.

**Setup:**
1. GitHub PAT stored in Keychain (loaded via `GITHUB_PERSONAL_ACCESS_TOKEN` env var)
2. Enabled in `~/.claude/settings.json`
3. Permissions granted in `~/.claude/settings.local.json`

**Env var setup** (in `~/.zshrc`):
```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -s github-pat -w 2>/dev/null)"
export GITHUB_PAT="$GITHUB_PERSONAL_ACCESS_TOKEN"  # Alias for CLI tools
```

**Available commands:**
- List repos, branches, issues, PRs
- Search code across repos
- Get file contents
- Create/update issues and PRs
- Merge PRs
- Create branches

### Rust Analyzer LSP

**Why:** Type checking, completions, goto definition in Rust projects.

**Setup:** Automatically loaded via Claude plugins marketplace.

**Works with:** Any Rust project (Cargo.toml present).

### Sleeper Fantasy Football MCP

**Why:** Manage fantasy football leagues directly.

**League IDs:** Stored in project memory (see `reference_sleeper_league_ids.md`)

**Commands:** Analyze lineups, get matchups, research players, waiver suggestions.

---

## Recommended MCPs to Add

### 1. **Google Drive MCP** (High Value)

**Use:** Read/write Google Docs, Sheets, Files from Claude Code.

**Setup:**
```json
"google-drive@claude-plugins-official": true
```

**Auth:** Google OAuth (Claude Code handles the flow)

**Use cases:**
- Read documentation from Docs
- Update project sheets
- Access shared files

### 2. **Linear MCP** (If using Linear for issues)

**Use:** Access Linear workspace issues and projects.

**Setup:**
```json
"linear@claude-plugins-official": true
```

**Auth:** Linear API key

**Use cases:**
- List issues by status
- Create issues
- Search for related work
- Update issue status

### 3. **Discord MCP** (For team comms)

**Use:** Read/send messages in team Discord.

**Setup:**
```json
"discord@claude-plugins-official": true
```

**Auth:** Discord bot token

**Use cases:**
- Read team discussions
- Post updates
- Cross-reference decisions

### 4. **Slack MCP** (For workplace)

**Use:** Integrate with Slack workspace.

**Setup:**
```json
"slack@claude-plugins-official": true
```

**Auth:** Slack API token

**Use cases:**
- Read channel history
- Post announcements
- Search conversations

---

## Environment Variables Strategy

Store sensitive tokens in macOS Keychain (never plain text):

```bash
# Add to Keychain
security add-generic-password -s github-pat -a github -w "ghp_..."
security add-generic-password -s linear-api-key -a linear -w "lin_..."
security add-generic-password -s discord-token -a discord -w "..."

# Retrieve in .zshrc
export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -s github-pat -w 2>/dev/null)"
export LINEAR_API_KEY="$(security find-generic-password -s linear-api-key -w 2>/dev/null)"
export DISCORD_TOKEN="$(security find-generic-password -s discord-token -w 2>/dev/null)"
```

**Advantages:**
- Secure (OS-level encryption)
- Survives terminal restarts
- Easily shareable between machines
- Works with Bitwarden backup

---

## Permissions Setup

In `~/.claude/settings.local.json`, grant permissions to MCPs:

```json
{
  "permissions": {
    "allow": [
      "mcp__github__*",
      "mcp__google_drive__*",
      "mcp__linear__*",
      "mcp__discord__*",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:linear.app)",
      "WebSearch"
    ]
  }
}
```

**Alternative:** Let Claude Code ask for permission each time (less intrusive).

---

## Testing MCPs

Ask Claude Code:

**GitHub:**
```
"What GitHub repositories do I have? Show me the top 5."
"List my open issues."
"Search for 'TODO' in my repos."
```

**Google Drive:**
```
"Read my project roadmap from Google Docs."
"List my Google Drive folders."
```

**Linear:**
```
"Show me my in-progress issues."
"Create a Linear issue for..."
```

---

## Troubleshooting

### GitHub MCP Not Connecting

**Check 1: Verify PAT in Keychain**
```bash
security find-generic-password -s github-pat -w
# Should print your PAT (ghp_...)
```

**Check 2: Verify env var is exported**
```bash
echo $GITHUB_PERSONAL_ACCESS_TOKEN
# Should be non-empty
```

**Check 3: Restart Claude Code**
- New env vars require app restart
- After modifying .zshrc, close and reopen

**Check 4: Check settings.json**
- Ensure `"github@claude-plugins-official": true` is set
- Ensure `enabledPlugins` section exists

### Any MCP Not Loading

1. **Restart Claude Code** (most common fix)
2. **Check env var is set:** `echo $VARNAME`
3. **Verify permission granted:** Check `settings.local.json`
4. **Check internet connection:** MCPs require network access
5. **Test with simpler query:** MCPs sometimes fail on complex requests

---

## MCP Development (Advanced)

If building custom MCPs:

- **Location:** `~/.claude/plugins/`
- **Marketplace:** Plugins are downloaded from official marketplace
- **Local development:** Use local file system path in config

Example local MCP config:
```json
{
  "my-mcp": {
    "type": "stdio",
    "command": "/usr/local/bin/my-mcp-binary"
  }
}
```

---

## Future Additions

Consider for work machine:

- **AWS MCP** - Manage AWS resources
- **Kubernetes MCP** - kubectl integration
- **Datadog MCP** - Monitoring and logs
- **PagerDuty MCP** - Incident management
- **Jira MCP** - Jira issue tracking
- **GitLab MCP** - GitLab alternative to GitHub MCP

---

**Last updated:** 2026-09-24  
**Tested on:** Claude Code + Haiku model
