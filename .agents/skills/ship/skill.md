---
name: ship
description: Commitea los cambios actuales y los sube al remoto en un solo flujo, generando el mensaje de commit leyendo el diff real y pidiendo confirmación en cada paso. Úsalo cuando el usuario pida "sube esto", "commitea y sube", "haz commit y push" o escriba /ship. Nunca inventa el diff ni hace force-push sin confirmación explícita.
argument-hint: "[rama remota opcional]"
allowed-tools: Bash(git *)
---

# Skill: /ship

Combina `/commit` y `/push` en un solo flujo: primero genera y confirma el mensaje de commit leyendo el diff real, lo ejecuta, y después revisa el estado de la rama para proponer y confirmar el push.

## Contexto

- Archivos en staging: !`git diff --staged --name-only`
- Diff en staging: !`git diff --staged`
- Diff sin staging (si no hay nada en staging): !`git diff`
- Rama actual: !`git branch --show-current`
- Estado respecto al remoto: !`git status -sb`
- Upstream configurado: !`git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "sin upstream configurado"`

## Rama de destino (push)

$ARGUMENTS

## Cuándo usarlo

Cuando el usuario pida "sube esto", "commitea y sube", "haz commit y push", o escriba `/ship`.

## Fase 1: commit

1. Lee el **Diff en staging**. Si está vacío, usa el **Diff sin staging** y avisa de que aún no hay nada en staging.
2. Identifica qué cambió y por qué, y clasifica el tipo (`feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`).
3. Si el diff mezcla varios asuntos distintos, sugiere dividirlo en varios commits antes de continuar.
4. Redacta el mensaje: `tipo(alcance opcional): descripción en imperativo`, máximo 72 caracteres en la primera línea, en inglés por defecto, cuerpo opcional si hace falta más contexto.
5. Propón el mensaje y pide confirmación explícita antes de comitear.
6. Tras la confirmación, ejecuta `git add` de los archivos relevantes y `git commit`.

## Fase 2: push

7. Con el commit ya hecho, revisa la **Rama actual**, el **Estado respecto al remoto** y el **Upstream configurado**.
8. Si no hay upstream, propone `git push -u origin <rama>` en vez de un `git push` simple.
9. Si se pasó una rama remota en `$ARGUMENTS`, úsala como destino.
10. Si la rama de destino es `main` o `master`, avisa explícitamente de que es una rama protegida.
11. Si hay divergencia con el remoto, no fuerces: avisa y sugiere `git pull --rebase`.
12. Muestra un resumen (rama local, rama remota, commit(s) a subir) y pide confirmación explícita antes de ejecutar `git push`.
13. Ejecuta el push solo tras la confirmación. Informa del resultado.

## Reglas

- NUNCA hagas commit de archivos `.env`, credenciales o secretos; avisa si los ves en staging.
- NUNCA hagas `--force` ni `--force-with-lease` sin confirmación explícita.
- NUNCA hagas push directo a `main`/`master` sin avisar primero y pedir confirmación adicional.
- No saltes hooks (`--no-verify`) salvo petición explícita del usuario.
- No inventes el estado del repositorio: usa siempre el contexto real (`git status`, `git diff`, `git log`) antes de actuar.
- Cada fase pide su propia confirmación por separado: no encadenes commit y push sin que el usuario confirme cada uno.
