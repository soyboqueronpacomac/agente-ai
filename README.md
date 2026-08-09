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

### Skills

Cada carpeta en `.agents/skills/<nombre>/skill.md` se instala automáticamente, solo en los agentes que estén presentes en la máquina (detectados vía `command -v claude|codex|copilot`):

- **Claude Code**: symlink a `~/.claude/skills/<nombre>/SKILL.md`. Es un skill real, con auto-invocación por descripción, tal como espera Claude Code.
- **Codex**: symlink a `~/.codex/prompts/<nombre>.md`. Codex no tiene sistema de skills equivalente; queda como prompt personalizado invocable manualmente con `/<nombre>` en el TUI.
- **Copilot CLI**: symlink a `~/.copilot/skills/<nombre>.md`. No existe invocación automática conocida; queda solo como referencia que hay que apuntarle manualmente al agente.

Si añades un nuevo skill en `.agents/skills/`, basta con volver a ejecutar `./install.sh`.

Documentación detallada de cada skill (función y cómo se invoca en cada agente): [`docs/agents/skills-compartidos-entre-agentes-ia.md`](docs/agents/skills-compartidos-entre-agentes-ia.md).
