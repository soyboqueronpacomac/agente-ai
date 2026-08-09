---
name: kanban-board
description: Gestiona el tablero kanban del repositorio actual. Lista, lee y cierra issues de GitHub.
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

### Al terminar el trabajo de una issue

Cierra la issue con un comentario resumiendo lo hecho:
```bash
gh issue close <número> --comment "Hecho: <resumen breve>"
```
