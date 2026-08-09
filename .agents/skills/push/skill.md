---
name: push
description: Sube la rama actual al remoto tras revisar el estado real del repositorio y pedir confirmación. Úsalo cuando el usuario escriba /push, "haz push" o "sube los cambios". Nunca hace force-push sin confirmación explícita.
disable-model-invocation: true
argument-hint: "[rama remota opcional]"
allowed-tools: Bash(git *)
---

# Skill: /push

Sube la rama actual al remoto, revisando primero el estado real del repositorio y pidiendo confirmación antes de ejecutar el push.

## Contexto

- Rama actual: !`git branch --show-current`
- Estado respecto al remoto: !`git status -sb`
- Upstream configurado: !`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "sin upstream configurado"`
- Commits sin subir: !`git log @{u}.. --oneline 2>/dev/null || git log --oneline -10`

## Rama de destino

$ARGUMENTS

## Cuándo usarlo

Cuando el usuario escriba `/push`, pida "haz push", "sube los cambios" o "push the changes".

## Pasos

1. Lee el **Contexto** de arriba. Si no hay commits sin subir, avisa al usuario y no hagas nada más.
2. Si la rama no tiene upstream configurado, proponer `git push -u origin <rama>` en vez de un `git push` simple.
3. Si se pasó una rama remota en `$ARGUMENTS`, úsala como destino en vez de la rama con upstream por defecto.
4. Si la rama de destino es `main` o `master`, avisa explícitamente de que es una rama protegida antes de continuar.
5. Comprueba si el remoto tiene commits que no están en local (divergencia). Si los hay, avisa y sugiere `git pull --rebase` en vez de forzar el push.
6. Muestra un resumen claro: rama local, rama remota de destino, y lista de commits que se van a subir.
7. Pide confirmación explícita al usuario antes de ejecutar `git push`.
8. Ejecuta el push solo tras la confirmación. Informa del resultado (éxito, error, o el enlace para abrir un PR si el remoto lo sugiere).

## Ejemplo de salida

```
Rama local:  feature/auth-refresh
Rama remota: origin/feature/auth-refresh (sin upstream, se creará con -u)

Commits a subir:
  a1b2c3d feat(auth): add JWT refresh token rotation
  e4f5g6h test(auth): cover refresh token expiry

¿Confirmas el push? (s/n)
```

## Reglas

- NUNCA hagas `--force` ni `--force-with-lease` sin confirmación explícita del usuario.
- NUNCA hagas push directo a `main`/`master` sin avisar primero y pedir confirmación adicional.
- Si hay divergencia con el remoto, no fuerces: avisa y sugiere `git pull --rebase`.
- No inventes el estado del repositorio: usa siempre el contexto real (`git status`, `git log`) antes de actuar.
- No saltes hooks (`--no-verify`) salvo petición explícita del usuario.
