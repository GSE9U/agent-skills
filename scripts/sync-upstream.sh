#!/usr/bin/env bash
# Vuelve a descargar las skills de terceros listadas en scripts/sources.txt
# y las copia en skills/. Tus skills propias (las que no estén en la lista) no se tocan.
# Uso: ./scripts/sync-upstream.sh   (luego revisa `git diff` antes de hacer commit)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
SOURCES_MD="$ROOT/SOURCES.md"
{
  echo "# Procedencia de las skills de terceros"
  echo
  echo "Generado por \`scripts/sync-upstream.sh\`. Todas son MIT; las licencias están en \`LICENSES/\`."
  echo
  echo "| Skill | Repo | Commit |"
  echo "|---|---|---|"
} > "$SOURCES_MD"
mkdir -p "$ROOT/skills" "$ROOT/LICENSES"
grep -vE '^\s*(#|$)' "$ROOT/scripts/sources.txt" | while read -r url path; do
  slug="$(basename "${url%.git}")"; owner="$(basename "$(dirname "$url")")"
  dir="$TMP/$owner-$slug"
  if [ ! -d "$dir" ]; then
    git clone -q --depth 1 "$url" "$dir"
  fi
  name="$(basename "$path")"
  # Licencia: la más cercana subiendo desde la carpeta de la skill hasta la raíz del repo
  lic_dir="$path"
  while :; do
    if [ -f "$dir/$lic_dir/LICENSE" ]; then cp "$dir/$lic_dir/LICENSE" "$ROOT/LICENSES/$owner-$slug.txt"; break; fi
    [ "$lic_dir" = "." ] && break
    lic_dir="$(dirname "$lic_dir")"
  done
  rm -rf "$ROOT/skills/$name"
  cp -R "$dir/$path" "$ROOT/skills/$name"
  echo "| \`$name\` | [$owner/$slug](${url%.git}/tree/HEAD/$path) | \`$(git -C "$dir" rev-parse --short HEAD)\` |" >> "$SOURCES_MD"
  echo "ok  $name  <- $owner/$slug"
done
