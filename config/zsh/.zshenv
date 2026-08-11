# GitHub MCP server auth. Read from the gh keyring so the token is never stored
# in a dotfile; consumed as ${GITHUB_PAT} by the Authorization header in
# ~/.claude.json -> mcpServers.github.
#
# This lives in .zshenv rather than .zshrc because zsh sources .zshrc only for
# interactive shells. Claude Code inherits the environment of whatever launched
# it -- often a tmux pane or a non-interactive shell -- so a .zshrc-only export
# leaves the header interpolating to a bare "Bearer " and GitHub rejects the
# request with HTTP 400. The guard keeps nested shells from paying the ~46ms
# keyring lookup again.
if [[ -z "$GITHUB_PAT" ]] && command -v gh >/dev/null 2>&1; then
  export GITHUB_PAT="$(gh auth token 2>/dev/null)"
fi
