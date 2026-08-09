---
name: handoff
description: Compacta la conversación actual en un documento de traspaso para que un agente nuevo continúe el trabajo.
disable-model-invocation: true
argument-hint: "[foco de la siguiente sesión]"
---

# Skill: /handoff

Compacta la conversación actual en un documento de traspaso para que un agente nuevo pueda continuar sin perder contexto.

## Foco de la siguiente sesión

$ARGUMENTS

## Pasos

1. **Revisa qué existe ya**: busca artefactos ya capturados en otro sitio — PRDs, planes, ADRs, issues, commits, diffs. Referéncialos por ruta o URL; no dupliques su contenido.

2. **Escribe el documento de traspaso** con estas secciones:

```markdown
# Traspaso: [fecha] — [foco o "continuación"]

## Dónde lo dejamos
[1-3 frases sobre el estado actual y qué se acaba de completar o decidir]

## Hilos abiertos
- [Decisión o tarea aún sin resolver]
- [Elemento bloqueado y qué lo bloquea]

## Decisiones clave tomadas en esta sesión
- [Decisión] — [por qué, en una línea]

## Artefactos a leer primero
- `ruta/al/archivo.md` — [qué contiene]
- Issue #42 — [qué rastrea]

## Skills sugeridas para la siguiente sesión
- `/ak:plan` — [por qué es relevante]
- `/ak:debug` — [por qué es relevante]

## Contexto que necesita el siguiente agente pero no está en el código
[Cualquier cosa no evidente: restricciones, preferencias de stakeholders, cosas probadas y descartadas]
```

3. **Guárdalo en el directorio temporal del sistema operativo** — no en el workspace actual.
   - Windows: `%TEMP%\handoff-[timestamp].md`
   - macOS/Linux: `/tmp/handoff-[timestamp].md`

4. **Informa de la ruta** al usuario y, opcionalmente, copia las secciones clave a la conversación para uso inmediato.

## Reglas

- No dupliques contenido que ya esté en PRDs, issues o commits. Referéncialo.
- Redacta (oculta) secretos, claves de API y datos personales (PII).
- Si el usuario pasó argumentos, trátalos como el foco de la siguiente sesión y adapta el documento en consecuencia.
- El documento debe ser autocontenido: un agente nuevo que solo lea este archivo debe saber por dónde empezar.
