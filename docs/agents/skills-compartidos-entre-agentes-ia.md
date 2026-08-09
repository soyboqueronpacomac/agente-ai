# 🎯 Skills compartidos entre agentes de IA

## 💡 Convención

Cada skill reutilizable vive como fuente única de verdad en `.agents/skills/<nombre>/skill.md`, con frontmatter YAML (`name`, `description`, `disable-model-invocation`, `allowed-tools`, `argument-hint` opcional). `install.sh` instala automáticamente cada skill encontrado en `.agents/skills/` hacia el CLI de cada agente de IA presente en la máquina (detectado vía `command -v claude|codex|copilot`), sin duplicar el contenido a mano en cada configuración.

## 🏆 Beneficios

- Una sola fuente de verdad por skill: el contenido no se duplica entre agentes, así que no hay riesgo de que las copias diverjan con el tiempo.
- Añadir un skill nuevo es tan simple como crear una carpeta con un `skill.md` y volver a ejecutar `./install.sh`; no hay que tocar la lógica de instalación.
- La instalación es selectiva: si un agente no está presente en la máquina, `install.sh` no crea nada para él.
- Cada agente recibe el skill en el formato y ruta que realmente entiende (skill real, prompt personalizado, o archivo de referencia), en vez de forzar el mismo mecanismo en los tres.
- Puedes elegir por skill si permites invocación por el modelo (`disable-model-invocation` ausente) o si exiges que el usuario escriba el comando literal (`disable-model-invocation: true`), según cuán sensible sea la acción.

## 👀 Ejemplos

### ✅ Correcto: un skill con fuente única, instalado por `install.sh`

```markdown
---
name: commit
description: Genera un mensaje de commit semántico leyendo el diff real...
disable-model-invocation: true
allowed-tools: Bash(git *)
---
# Skill: /commit
...
```

`install.sh` symlinkea este archivo hacia `~/.claude/skills/commit/SKILL.md`, `~/.codex/prompts/commit.md` y `~/.copilot/skills/commit.md`, según qué agentes estén instalados.

### ❌ Incorrecto: copiar el contenido del skill a mano en cada agente

Pegar las instrucciones del skill directamente en la configuración de Claude, Codex y Copilot por separado. Cualquier corrección futura hay que repetirla tres veces, y es fácil que las copias diverjan entre sí.

## 🧐 Ejemplos del mundo real

Skills instalados hoy, su función, y cómo se comportan en cada agente:

| Skill | Función | Claude Code | Codex | Copilot CLI |
|---|---|---|---|---|
| `commit` | Genera un mensaje de commit semántico leyendo el diff real, con confirmación antes de ejecutar. | Skill real, invocación explícita | Prompt personalizado `/commit` | Archivo de referencia manual |
| `push` | Sube la rama actual al remoto tras revisar estado/upstream/divergencia, avisando si el destino es `main`/`master`. | Skill real, invocación explícita | Prompt personalizado `/push` | Archivo de referencia manual |
| `create-doc` | Crea o mejora documentación en `docs/` siguiendo la plantilla de `documentation-guidelines.md`. | Skill real, invocación explícita | Prompt personalizado `/create-doc` | Archivo de referencia manual |
| `handoff` | Compacta la conversación actual en un documento de traspaso para que un agente nuevo continúe el trabajo. | Skill real, invocación explícita | Prompt personalizado `/handoff` | Archivo de referencia manual |
| `ship` | Encadena `commit` y `push` en un solo flujo (mensaje de commit + push), pidiendo confirmación en cada fase por separado. | Skill real, auto-invocable por descripción | Prompt personalizado `/ship` | Archivo de referencia manual |
| `kanban-board` | Lista, lee, crea y cierra issues de GitHub del repositorio actual con `gh issue list/view/create/close`. | Skill real, auto-invocable por descripción | Prompt personalizado `/kanban-board` | Archivo de referencia manual |
| `informacion` | Resume el proyecto activo (README, dependencias, convenciones, estructura, estado) en el chat. Solo lectura, `allowed-tools` sin `Write`/`Edit`. | Skill real, auto-invocable por descripción | Prompt personalizado `/informacion` | Archivo de referencia manual |
| `planificacion` | Vuelca un plan ya discutido/aprobado a un documento persistente en `docs/` (`plan-issue-skill-<nombre>.md` o `plan-<tema>.md`). `allowed-tools` sin `Bash`. | Skill real, auto-invocable por descripción | Prompt personalizado `/planificacion` | Archivo de referencia manual |

`kanban-board` detecta el repositorio automáticamente a partir del remoto `origin` (vía `gh repo view`), así que funciona igual en cualquier proyecto donde se instale, sin editar el skill. Uso: `/kanban-board` sin argumentos lista las issues abiertas; `/kanban-board 42` lee la issue 42 y propone un plan de implementación; al pedir crear una issue, propone título/cuerpo y pide confirmación antes de `gh issue create`; al terminar el trabajo, cierra la issue con `gh issue close <número> --comment "Hecho: <resumen>"`. Si se quiere apuntar a un repositorio distinto del actual, se le puede pasar `--repo <owner>/<repo>` a mano.

Cómo se invoca cada uno según el agente:

- **Claude Code**: el skill queda en `~/.claude/skills/<nombre>/SKILL.md`. `commit`, `push`, `create-doc` y `handoff` tienen `disable-model-invocation: true`, así que solo se disparan si el usuario escribe `/<nombre>` literalmente como su mensaje. `ship`, `kanban-board`, `informacion` y `planificacion` no tienen ese campo, así que Claude puede invocarlos también cuando el usuario lo pide en lenguaje natural (p. ej. "sube esto", "qué issues hay abiertas" o "planifica un skill para X").
- **Codex**: el archivo queda en `~/.codex/prompts/<nombre>.md`. Codex no tiene sistema de auto-invocación por descripción; el prompt se dispara manualmente con `/<nombre>` en el TUI, para los ocho skills por igual.
- **Copilot CLI**: el archivo queda en `~/.copilot/skills/<nombre>.md`, pero Copilot CLI no tiene un mecanismo de invocación automática conocido — hay que indicarle manualmente al agente que lea ese archivo y siga sus instrucciones.

Archivos fuente:

- [`commit`](../../.agents/skills/commit/skill.md)
- [`push`](../../.agents/skills/push/skill.md)
- [`create-doc`](../../.agents/skills/create-doc/skill.md)
- [`handoff`](../../.agents/skills/handoff/skill.md)
- [`ship`](../../.agents/skills/ship/skill.md)
- [`kanban-board`](../../.agents/skills/kanban-board/skill.md)
- [`informacion`](../../.agents/skills/informacion/skill.md)
- [`planificacion`](../../.agents/skills/planificacion/skill.md)
- Lógica de instalación: [`install.sh`](../../install.sh)

## ☝️ Casos excepcionales: Cuándo no aplicar esta convención

- Cuando la seguridad del skill dependa del campo `allowed-tools`, ten en cuenta que esa restricción es específica de Claude Code: Codex y Copilot leen el mismo archivo como texto plano y no la interpretan.
- Cuando quieras que el agente pueda disparar el skill a partir de una petición en lenguaje natural (sin que el usuario escriba el comando literal), no le pongas `disable-model-invocation: true`.

### 🥽 Ejemplo de caso excepcional

El skill `push` está sandboxeado en Claude Code con `allowed-tools: Bash(git *)`, así que ahí Claude no puede ejecutar nada fuera de comandos `git`. Ese mismo archivo, corriendo como prompt personalizado en Codex, no tiene ese sandboxing — `allowed-tools` no es un campo que Codex interprete. Por eso las reglas de seguridad del skill (pedir confirmación, no forzar sin confirmar, avisar en ramas protegidas) están escritas también como texto explícito en el cuerpo del documento, no delegadas solo al campo `allowed-tools`.

### 🥽 `disable-model-invocation` bloquea también al propio agente

`disable-model-invocation: true` no solo impide la auto-invocación por descripción: en Claude Code, si el propio agente intenta invocar ese skill a través del Skill tool porque el usuario se lo pidió en lenguaje natural ("usa /commit"), la llamada puede fallar con `Skill <nombre> cannot be used with Skill tool due to disable-model-invocation`. La única invocación fiable en ese caso es que el usuario escriba `/<nombre>` literalmente como su mensaje. Por eso se creó `ship`: un skill sin ese campo, para los flujos que sí queremos poder disparar por lenguaje natural sin perder las confirmaciones internas.
