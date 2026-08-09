---
name: informacion
description: Responde preguntas sobre el proyecto activo (estructura, stack, dependencias, convenciones, estado) con un resumen conversacional. Solo lectura, nunca modifica ni genera archivos. Úsalo cuando el usuario pregunte "qué es este proyecto", "dame información del repo", "resume la arquitectura" o "qué dependencias usa esto".
allowed-tools: Read, Bash(tree *), Bash(fd *), Bash(git log *)
---

# Skill: informacion

Da un resumen conversacional del proyecto activo a partir de sus fuentes reales. Nunca crea, edita ni borra archivos, ni genera reportes en disco — toda la salida va al chat.

## Cuándo usarlo

Cuando el usuario pregunte "qué es este proyecto", "dame información del repo", "resume la arquitectura", "qué dependencias usa esto", o similar.

## Fuentes a consultar

1. `README` (o `README.md`) en la raíz del proyecto.
2. Manifiestos de dependencias presentes: `package.json`, `requirements.txt`/`pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `composer.json`, etc. — busca **todos** los que existan, no solo el primero (proyectos monorepo pueden tener varios).
3. Archivos de instrucciones del agente: `CLAUDE.md`, `AGENTS.md`, `GLOBAL_AGENT.md`.
4. Estructura de directorios: `tree -L 2 -I node_modules` o `fd . --max-depth 2` si `tree` no está disponible.
5. Estado reciente: `git log --oneline -10` (si el directorio es un repositorio git).

Si alguna fuente no existe (p. ej. no hay `README`), continúa con las demás y menciona en el resumen qué falta, en vez de fallar.

## Pasos

1. Lee las fuentes disponibles según la lista de arriba.
2. Sintetiza en un resumen conversacional: qué es el proyecto, stack tecnológico, estructura principal, convenciones relevantes (si las hay documentadas), y estado reciente.
3. Si detectas varios manifiestos de dependencias (monorepo o proyecto multi-lenguaje), resume cada uno por separado.
4. Devuelve el resumen directamente en el chat. No escribas nada a disco.

## Reglas

- Nunca crees, edites ni borres archivos.
- Nunca generes reportes ni resúmenes en disco: la salida es siempre conversacional.
- No inventes información que no esté en las fuentes leídas; si algo no está documentado, dilo explícitamente en vez de asumir.
