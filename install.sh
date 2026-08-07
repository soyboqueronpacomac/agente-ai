#!/bin/bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/GLOBAL_AGENT.md"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: no se encontró $SOURCE_FILE" >&2
  exit 1
fi

TARGETS=(
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.copilot/AGENTS.md"
)

for target in "${TARGETS[@]}"; do
  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$SOURCE_FILE" ]; then
    echo "OK (ya configurado): $target"
    continue
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="$target.bak.$(date +%s)"
    mv "$target" "$backup"
    echo "Aviso: se encontró configuración previa, respaldada en $backup"
  fi

  if ln -sf "$SOURCE_FILE" "$target" 2>/dev/null; then
    echo "OK (symlink): $target -> $SOURCE_FILE"
  elif cp "$SOURCE_FILE" "$target" 2>/dev/null; then
    echo "OK (copia, no se pudo symlinkar): $target"
  else
    echo "Error: no se pudo instalar en $target" >&2
  fi
done

LOCAL_BIN="$HOME/.local/bin"

detect_os() {
  local kernel
  kernel="$(uname -s)"
  case "$kernel" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      if uname -r | grep -qi "microsoft"; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "windows"
      ;;
    *)
      echo "desconocido"
      ;;
  esac
}

ensure_local_bin_on_path() {
  mkdir -p "$LOCAL_BIN"

  case ":$PATH:" in
    *":$LOCAL_BIN:"*)
      return 0
      ;;
  esac

  local linea='export PATH="$HOME/.local/bin:$PATH"'
  local rc
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ] && ! grep -qF "$linea" "$rc"; then
      printf '\n%s\n' "$linea" >> "$rc"
      echo "Aviso: se añadió $LOCAL_BIN al PATH en $rc (abre un shell nuevo o haz 'source $rc')"
    fi
  done

  export PATH="$LOCAL_BIN:$PATH"
}

map_arch() {
  case "$(uname -m)" in
    x86_64|amd64)
      echo "amd64"
      ;;
    arm64|aarch64)
      echo "arm64"
      ;;
    *)
      uname -m
      ;;
  esac
}

install_from_github_release() {
  local repo="$1" binario="$2" patron="$3"
  local arch os_tag
  arch="$(map_arch)"
  os_tag="$(uname -s | tr '[:upper:]' '[:lower:]')"

  local asset_url
  asset_url="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*"' \
    | cut -d'"' -f4 \
    | grep -i "$os_tag" \
    | grep -i "$arch" \
    | grep -E "$patron" \
    | head -n1)"

  if [ -z "$asset_url" ]; then
    echo "Aviso: no se encontró release de $repo para $os_tag/$arch, omitiendo $binario" >&2
    return 1
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local archivo="$tmp_dir/$(basename "$asset_url")"

  if ! curl -fsSL "$asset_url" -o "$archivo"; then
    echo "Error: no se pudo descargar $asset_url" >&2
    rm -rf "$tmp_dir"
    return 1
  fi

  case "$archivo" in
    *.tar.gz|*.tgz)
      tar -xzf "$archivo" -C "$tmp_dir"
      ;;
    *.zip)
      unzip -q "$archivo" -d "$tmp_dir"
      ;;
  esac

  local encontrado
  encontrado="$(find "$tmp_dir" -type f -name "$binario" -perm -u+x | head -n1)"
  if [ -z "$encontrado" ]; then
    encontrado="$(find "$tmp_dir" -type f -name "$binario" | head -n1)"
  fi

  if [ -z "$encontrado" ]; then
    echo "Error: no se encontró el binario $binario dentro de $asset_url" >&2
    rm -rf "$tmp_dir"
    return 1
  fi

  mkdir -p "$LOCAL_BIN"
  cp "$encontrado" "$LOCAL_BIN/$binario"
  chmod +x "$LOCAL_BIN/$binario"
  rm -rf "$tmp_dir"
  echo "OK (binario GitHub): $binario -> $LOCAL_BIN/$binario"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  echo "Homebrew no encontrado, instalando..."
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    echo "Error: no se pudo instalar Homebrew" >&2
    return 1
  fi
}

install_macos() {
  ensure_homebrew || return 1
  brew install ast-grep fd ripgrep tree jq yq
}

install_linux() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y ripgrep tree jq fd-find || true
    if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
      mkdir -p "$LOCAL_BIN"
      ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
    fi
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y ripgrep tree jq fd-find || true
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y ripgrep tree jq fd-find || true
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm ripgrep tree jq fd || true
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y ripgrep tree jq fd || true
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add --no-cache ripgrep tree jq fd || true
  else
    echo "Aviso: no se detectó un gestor de paquetes conocido" >&2
  fi

  command -v ast-grep >/dev/null 2>&1 || \
    install_from_github_release "ast-grep/ast-grep" "ast-grep" "linux.*musl.*tar\.gz|linux.*gnu.*tar\.gz"
  command -v yq >/dev/null 2>&1 || \
    install_from_github_release "mikefarah/yq" "yq" "linux.*(?!\.tar\.gz)$|linux$"
  command -v fd >/dev/null 2>&1 || \
    install_from_github_release "sharkdp/fd" "fd" "linux.*gnu.*tar\.gz"
  command -v rg >/dev/null 2>&1 || \
    install_from_github_release "BurntSushi/ripgrep" "rg" "linux.*gnu.*tar\.gz"
}

install_windows() {
  if command -v scoop >/dev/null 2>&1; then
    scoop install ripgrep fd jq yq tree ast-grep
  elif command -v choco >/dev/null 2>&1; then
    choco install ripgrep fd jq yq tree ast-grep -y
  elif command -v winget >/dev/null 2>&1; then
    winget install --id BurntSushi.ripgrep -e
    winget install --id sharkdp.fd -e
    winget install --id jqlang.jq -e
    winget install --id MikeFarah.yq -e
    winget install --id ast-grep.ast-grep -e
  else
    cat <<'EOF'
Aviso: no se encontró scoop, choco ni winget en Git Bash.
Instala Scoop (no requiere privilegios de administrador) con este comando en PowerShell:
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  irm get.scoop.sh | iex
Y vuelve a ejecutar este script desde Git Bash.
EOF
  fi
}

resumen_herramientas() {
  echo ""
  echo "Resumen de herramientas:"
  local herramienta
  for herramienta in ast-grep fd rg tree jq yq; do
    if command -v "$herramienta" >/dev/null 2>&1; then
      echo "  OK: $herramienta"
    else
      echo "  FALTA: $herramienta"
    fi
  done
}

install_dev_tools() {
  ensure_local_bin_on_path

  local os
  os="$(detect_os)"

  case "$os" in
    macos)
      install_macos
      ;;
    linux|wsl)
      install_linux
      ;;
    windows)
      install_windows
      ;;
    *)
      echo "Aviso: sistema operativo no soportado para instalar herramientas ($os)" >&2
      ;;
  esac

  resumen_herramientas
}

install_dev_tools

echo "Listo."
