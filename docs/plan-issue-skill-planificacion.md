# Plan: Issue #2 skill "planificacion"

## Contexto

Este documento planifica la futura construcción de una skill de Claude Code llamada **planificacion**. Todavía no se escribe código ni el `skill.md` final — es solo el plan de qué hará la skill y cómo se construirá más adelante.

- **Dominio de la skill**: generación de documentos de planificación para futuras issues, skills o features.
- **Salida al activarse**: un archivo `.md` nuevo dentro de `docs/`, con el contenido del plan. No modifica ni genera nada más.

## Objetivo de la skill

Cuando el usuario pida planificar algo (una issue, un skill, una feature) estando en Plan Mode, producir un documento de planificación persistente en `docs/`, en vez de (o además de) el plan efímero que el harness guarda por su cuenta en `~/.claude/plans/`. Es la misma mecánica ya usada manualmente para la issue #1: `docs/plan-issue-skill-informacion.md` planificó el skill `informacion`, y ese documento sirvió después de base para abrir la issue con `/kanban-board`.

## Triggers de activación propuestos

- "planifica..."
- "crea un plan para..."
- "documenta el plan de la issue #N"
- "quiero planificar [una skill / una feature]"

## Restricción crítica

- El skill **solo debe actuar cuando el Plan Mode del harness está activo**. Si se invoca fuera de Plan Mode, debe avisar de que hace falta activarlo primero y no generar nada.
- Su **única salida permitida** es crear el archivo `.md` de planificación en `docs/`. No debe escribir el código de la funcionalidad planificada, no debe modificar otros archivos del proyecto, y no debe ejecutar comandos con efectos secundarios.
- Esto es coherente con las propias restricciones que ya impone el Plan Mode del harness (mientras está activo, solo se puede editar el plan file designado y hacer lecturas): el volcado final a `docs/` ocurre como parte del contenido del plan ya aprobado, no como una acción paralela dentro del propio Plan Mode.

## Fuentes/formato a seguir

Estructura libre de "documento de planificación" — no la plantilla de convención de `docs/documentation-guidelines.md` (esa es para otro tipo de documento: convenciones de código, no planes). Se replica el formato ya validado en `docs/plan-issue-skill-informacion.md`: Contexto, Objetivo, Triggers, Restricciones/alcance, Formato futuro del `skill.md`, Próximos pasos.

## Formato futuro del `skill.md`

Cuando se implemente, seguirá el patrón de las skills existentes en `.agents/skills/`:

- Frontmatter con `name: planificacion` y `description` rica en keywords de activación, condicionada a Plan Mode.
- Cuerpo con secciones de comportamiento, la restricción de "solo Plan Mode + solo `.md` en `docs/`", y el patrón de nombrado de los archivos generados (`plan-issue-skill-<nombre>.md` para planes de skills, `plan-<tema>.md` para el resto).

## Próximos pasos (TODO)

- [ ] Decidir la ubicación final de la skill (`.agents/skills/planificacion/skill.md`, mismo patrón que el resto).
- [ ] Redactar el `skill.md` con la lógica de detección de "Plan Mode activo" y el volcado a `docs/`.
- [ ] Definir el patrón de nombrado de los archivos de planificación generados.
- [ ] Probar la skill planificando una issue real.
