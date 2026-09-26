#!/usr/bin/env bash
# Enlaza cada skill de este repo en las carpetas que leen Codex y Claude Code.
# macOS / Linux / WSL. Es idempotente: vuelve a ejecutarlo tras añadir skills.
# No toca carpetas reales que ya existan con el mismo nombre (solo avisa).
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
TARGETS=("$HOME/.agents/skills" "$HOME/.claude/skills")

for t in "${TARGETS[@]}"; do
  mkdir -p "$t"
  # Quita enlaces rotos que apuntaban a este repo (skills borradas)
  for l in "$t"/*; do
    [ -L "$l" ] || continue
    case "$(readlink "$l")" in "$REPO"/*) [ -e "$l" ] || rm "$l" ;; esac
  done
  for s in "$REPO"/skills/*/; do
    name="$(basename "$s")"; dest="$t/$name"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      echo "AVISO: $dest ya existe y no es un enlace, lo dejo como está"; continue
    fi
    ln -sfn "${s%/}" "$dest"
  done
  echo "ok  $(ls "$REPO/skills" | wc -l | tr -d ' ') skills enlazadas en $t"
done

cat <<MSG

Hermes: añade esto a ~/.hermes/config.yaml (una sola vez):

  skills:
    external_dirs:
      - ~/.agents/skills

Reinicia Claude Code / Codex / Hermes para que carguen las skills nuevas.
MSG
