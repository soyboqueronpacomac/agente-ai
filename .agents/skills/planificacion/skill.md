---
name: planificacion
description: Genera documentos de planificación persistentes en docs/ (plan-issue-skill-<nombre>.md o plan-<tema>.md) a partir de un plan ya discutido y aprobado en la conversación. Úsalo cuando el usuario pida "planifica...", "crea un plan para...", "documenta el plan de la issue #N", o "quiero planificar [una skill/feature]".
allowed-tools: Read, Write
---

# Skill: planificacion

Convierte un plan ya discutido y aprobado en la conversación (típicamente en Plan Mode) en un documento de planificación persistente dentro de `docs/`, en vez de dejarlo solo en el plan efímero del harness (`~/.claude/plans/*.md`).

## Cuándo usarlo

Cuando el usuario pida "planifica...", "crea un plan para...", "documenta el plan de la issue #N", o "quiero planificar [una skill / una feature]".

## Restricción crítica

- Este skill **no puede detectar técnicamente si el Plan Mode del harness está activo** — es un límite de la plataforma, no de este documento. Por eso:
  - Si no existe todavía un plan claro, discutido y aprobado en la conversación, dile al usuario que primero hace falta acordar el plan (idealmente en Plan Mode) antes de generar el documento. No inventes el contenido.
  - Si ya hay un plan aprobado en la conversación, úsalo como base directamente para redactar el documento.
- Su única salida permitida es **crear un archivo `.md` nuevo en `docs/`**. No escribas código de la funcionalidad planificada, no modifiques otros archivos, y no ejecutes comandos — por eso este skill solo tiene acceso a `Read`/`Write`, sin `Bash`.

## Patrón de nombrado

- Si el plan es de un skill futuro: `docs/plan-issue-skill-<nombre-del-skill>.md`.
- Si el plan es de otra cosa (feature, refactor, decisión de arquitectura no ligada a un skill): `docs/plan-<tema>.md`.

## Estructura del documento generado

Formato libre de "documento de planificación" — no la plantilla de convención de `docs/documentation-guidelines.md`, que es para otro tipo de documento (convenciones de código). Referencia: `docs/plan-issue-skill-informacion.md` y `docs/plan-issue-skill-planificacion.md`.

```markdown
# Plan: <título del plan>

## Contexto
<qué se planifica, por qué, y qué NO se hace todavía (solo plan, sin código)>

## Objetivo
<qué debe lograr lo planificado>

## Triggers de activación propuestos
(si el plan es de un skill)
- ...

## Restricciones / alcance
<qué debe y no debe hacer>

## Formato futuro (si aplica)
<estructura que tendrá el resultado final: skill.md, código, etc.>

## Próximos pasos (TODO)
- [ ] ...
```

## Pasos

1. Reúne el plan ya discutido/aprobado en la conversación actual. No inventes contenido nuevo que no se haya acordado.
2. Elige el nombre de archivo según el patrón de nombrado.
3. Redacta el documento siguiendo la estructura de arriba.
4. Escríbelo en `docs/`.
5. Informa al usuario de la ruta del archivo creado y sugiere el siguiente paso habitual (p. ej. usar `/kanban-board` para abrir una issue a partir de él, y luego `/ship`).

## Reglas

- No escribas código de la funcionalidad planificada — solo el documento de plan.
- No modifiques archivos existentes salvo que el propio plan indique mejorar un documento de planificación anterior.
- No ejecutes comandos con efectos secundarios (este skill no tiene `Bash` en `allowed-tools`).
- No inventes contenido del plan que no se haya discutido y acordado con el usuario.
