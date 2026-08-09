---
name: commit
description: Genera un mensaje de commit semántico leyendo el diff real en staging. Úsalo cuando el usuario escriba /commit, "haz un commit" o "commitea los cambios". Nunca inventa — lee el diff real.
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Skill: /commit

Genera un mensaje de commit semántico leyendo el diff real. No inventes — lee el código.

## Contexto

- Archivos en staging: !`git diff --staged --name-only`
- Diff en staging: !`git diff --staged`
- Diff sin staging (si no hay nada en staging): !`git diff`

## Cuándo usarlo

Cuando el usuario escriba `/commit` o pida "haz un commit" / "commitea los cambios".

## Pasos

1. Lee el **Diff en staging** de arriba. Si está vacío, usa el **Diff sin staging** y avisa al usuario de que aún no hay nada en staging.
2. Lee el diff completo. Identifica:
   - **Qué cambió** (archivos, funciones, lógica)
   - **Por qué probablemente cambió** (nueva funcionalidad, fix, refactor, docs, etc.)
3. Clasifica el tipo de commit:
   - `feat:` — nueva funcionalidad
   - `fix:` — corrección de un bug
   - `refactor:` — cambio de código sin cambio de comportamiento
   - `chore:` — tareas de mantenimiento (dependencias, configuración, scripts)
   - `docs:` — solo documentación
   - `test:` — solo tests
   - `style:` — formato, espacios en blanco, punto y coma (sin lógica)
4. Redacta el mensaje con el formato: `tipo(alcance opcional): descripción en imperativo`
   - Máximo 72 caracteres en la primera línea
   - En inglés por defecto
   - Cuerpo opcional si el cambio necesita más contexto
5. Propón el mensaje y pregunta si está bien o necesita ajustes antes de ejecutar el commit.

## Ejemplo de salida

```
feat(auth): add JWT refresh token rotation

Tokens now rotate on each refresh request to reduce exposure window.
Invalidates old token immediately after issuing new one.
```

## Reglas

- NUNCA hagas commit de archivos `.env`, credenciales o secretos.
- Si ves archivos sensibles en staging, avisa antes de continuar.
- Si el diff es grande y mezcla asuntos distintos, sugiere dividirlo en varios commits.
