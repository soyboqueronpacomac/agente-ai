# Plan: Issue #1 skill "informacion"

## Contexto

Este documento planifica la futura construcción de una skill de Claude Code llamada **informacion**. Todavía no se escribe código ni el `SKILL.md` final — es solo el plan de qué hará la skill y cómo se construirá más adelante.

- **Dominio de la skill**: información del proyecto/repo actual (estructura, arquitectura, dependencias, estado).
- **Salida al activarse**: un resumen conversacional en el chat, sin generar archivos nuevos.

## Objetivo de la skill

Responder preguntas sobre el proyecto activo: estructura de carpetas, stack tecnológico, dependencias, convenciones y estado general, devolviendo un resumen en el chat.

## Triggers de activación propuestos

- "qué es este proyecto"
- "dame información del repo"
- "resume la arquitectura"
- "qué dependencias usa esto"

## Fuentes de información a consultar

- `README`
- Manifiestos de dependencias (`package.json` o equivalentes)
- Archivos `CLAUDE.md`
- Estructura de directorios (`tree`/`fd`)
- `git log` si aplica

## Alcance y límites

- No debe modificar archivos.
- No debe generar reportes en disco.
- Solo lectura y resumen en conversación.

## Formato futuro del `SKILL.md`

Cuando se implemente, seguirá el patrón de las skills existentes en `~/.claude/skills/`:

- Frontmatter con `name: informacion` y `description` rica en keywords de activación.
- Cuerpo con secciones `## When to Use This Skill`, pasos y ejemplos.

## Próximos pasos (TODO)

- [ ] Decidir la ubicación final de la skill (`~/.claude/skills/informacion/`).
- [ ] Redactar el `SKILL.md` siguiendo el formato descrito arriba.
- [ ] Definir ejemplos de output esperado.
- [ ] Probar la skill con distintas preguntas sobre el proyecto.
