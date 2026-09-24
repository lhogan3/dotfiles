# Keep PATH entries unique (OrbStack etc. can add duplicates)
typeset -U path PATH

# uv
export PATH="/Users/liamhogan/.local/bin:$PATH"
. "$HOME/.cargo/env"
