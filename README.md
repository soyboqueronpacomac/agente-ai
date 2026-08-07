# agente-ai

## Instalación

```
git clone https://github.com/soyboqueronpacomac/agente-ai.git
cd agente-ai
chmod +x install.sh
./install.sh
```

Esto crea symlinks de `GLOBAL_AGENT.md` hacia la configuración global de Claude, Codex y Copilot (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/AGENTS.md`).

Además instala las herramientas CLI que exige `GLOBAL_AGENT.md`: `ast-grep`, `fd`, `rg` (ripgrep), `tree`, `jq` y `yq`.

- **macOS**: usa Homebrew (lo instala automáticamente si falta).
- **Linux**: usa el gestor de paquetes disponible (`apt`, `dnf`, `yum`, `pacman`, `zypper` o `apk`) y, para lo que no esté en los repos (típicamente `ast-grep` y `yq`), descarga el binario oficial desde GitHub Releases a `~/.local/bin`.
- **Windows**: ejecutar desde Git Bash o WSL. En WSL se comporta como Linux; en Git Bash usa `scoop`, `choco` o `winget` (el primero disponible).

Si el script añade `~/.local/bin` al `PATH`, abre un shell nuevo (o haz `source ~/.bashrc`/`~/.zshrc`) para que quede disponible.
