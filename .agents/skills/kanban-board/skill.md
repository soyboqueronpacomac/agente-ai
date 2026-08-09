---
name: kanban-board
description: Gestiona el tablero kanban del repositorio actual. Lista, lee, crea y cierra issues de GitHub.
---

# Tablero Kanban

Usa el repositorio de git actual: `gh` lo detecta automáticamente a partir del remoto `origin`, no hace falta indicar `--repo`. Si quieres apuntar a otro repositorio distinto del actual, añade `--repo <owner>/<repo>` a cualquiera de los comandos.

## Comandos

Listar issues abiertas:
```bash
gh issue list
```

Ver una issue concreta:
```bash
gh issue view <número>
```

Crear una issue nueva:
```bash
gh issue create --title <título> --body <descripción>
```

Cerrar una issue:
```bash
gh issue close <número>
```

## Comportamiento

### Sin argumentos

Lista todas las issues abiertas y muestra un resumen al usuario.

### Con un ID de issue como argumento (p. ej. `/kanban-board 42`)

1. **Lee** la issue con `gh issue view <id>`.
2. **Analiza** la descripción, los criterios de aceptación y las etiquetas.
3. **Presenta un plan de implementación** al usuario con:
   - Resumen de lo que pide la issue.
   - Posibles riesgos o preguntas abiertas.

### Al pedir crear una issue nueva

1. Redacta un título breve y una descripción (contexto, qué se pide, criterios de aceptación si aplica) a partir de lo que pida el usuario o de la conversación actual.
2. Propón el título y la descripción al usuario y pide confirmación explícita antes de crearla.
3. Tras la confirmación, ejecuta `gh issue create --title <título> --body <descripción>` (añade `--label`/`--assignee`/`--milestone` solo si el usuario los pidió).
4. Informa del número y la URL de la issue creada.

### Al terminar el trabajo de una issue

Cierra la issue con un comentario resumiendo lo hecho:
```bash
gh issue close <número> --comment "Hecho: <resumen breve>"
```
