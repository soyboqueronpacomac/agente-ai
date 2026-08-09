---

name: create-doc
description: Crea o mejora la documentación según la conversación actual. Utiliza esto cuando se haya creado un plan y se hayan requerido cambios porque no seguía las convenciones del repositorio.

---

Con base en la conversación actual, crea archivos de documentación nuevos o mejora los existentes dentro de la carpeta 'docs/'.

## Fases

 1. Identifica las convenciones, patrones o decisiones discutidas en la conversación que deban ser documentadas.

 2. Comprueba si ya existe un documento relevante en docs/ (organizado por área: backend/, frontend/, database/, etc.).
    - Si existe, mejóralo manteniendo la estructura requerida.
    - Si no existe, crea un nuevo archivo en la subcarpeta correspondiente.
 3. Lee @docs/documentation-guidelines.md y sigue su estructura exactamente. Cada documento DEBE incluir estas secciones en orden:

 ```
 # 🎯 Nombre de la convención
  ## 💡 Convención
  ## 🏆 Beneficios
  ## 👀 Ejemplos (con subsecciones de ✅ Bueno y ❌ Malo)
  ## 🧐 Ejemplos del mundo real
  ## 🔗 Acuerdos relacionados
 ```

 4. Pide confirmación al usuario sobre la ruta del archivo de destino antes de escribir.
 5. Actualiza el índice AGENTS.md con el nuevo documento.

## Reglas
- Cada convención va en su propio archivo Markdown independiente; nunca agrupes varias convenciones en un solo documento.
- Coloca los archivos en la subcarpeta del área correcta (backend/, frontend/, database/, testing/, etc.).
- Incluye ejemplos concretos de buenas y malas prácticas con bloques de código cuando sea aplicable.
- Enlaza a archivos reales del código fuente que sigan la convención en la sección 'Ejemplos del mundo real'.