🎯 Guía de documentación

Estructura

Cada archivo de documentación sigue esta plantilla:

# 🎯 [Categoría]: [Título]

## 💡 Convención

[Resumen de la convención - 1-2 frases explicando la regla.]

## 🏆 Beneficios

- [Beneficio 1.]
- [Beneficio 2.]
- [Beneficio 3.]

## 👀 Ejemplos

### ✅ Correcto: [Breve descripción de la buena práctica]

[Bloque de código o descripción.]

### ❌ Incorrecto: [Breve descripción de la mala práctica]

[Bloque de código o descripción.]

## 🧐 Ejemplos reales

- [`Nombre del Componente/Archivo`](./path/to/file.tsx)
- [`Otro Componente`](./path/to/another/file.ts)

## ☝️ Casos excepcionales: Cuándo no aplicar esta convención

[Lista de casos donde las excepciones son válidas.]

### 🥽 Ejemplo de caso excepcional

[Descripción del contexto del caso excepcional.]

[Bloque de código o descripción mostrando la excepción válida.]

## 🔗 Acuerdos relacionados

- [Título del acuerdo relacionado](./path-to-related-agreement.md).
- [Otro acuerdo relacionado](./path-to-another-agreement.md).
Título y nombre de archivo

El nombre del archivo es crítico: los agentes de IA lo usan para decidir si cargar el documento o no. Un nombre de archivo descriptivo garantiza que la convención sea descubierta y aplicada; uno vago hace que sea ignorada.

Usa kebab-case para el nombre del archivo, derivado del título. Refleja en el título y en el nombre del archivo la convención real en lugar de la categoría o el concepto genérico. Es decir, si la convención trata sobre "Comunicación entre frontend y backend", el título debería ser "Comunicación entre Frontend y Backend a través de Casos de Uso" en lugar de "Comunicación entre Frontend y Backend", y el nombre del archivo debería ser "frontend-backend-communication-via-use-cases.md" en lugar de "frontend-and-backend-communication.md".

Ejemplos:

"Comunicación entre frontend y backend a través de casos de uso" → frontend-backend-communication-via-use-cases.md.
"Usar NOT NULL en los campos" → not-null-fields.md.
"Evitar abstracciones prematuras" → avoid-premature-abstractions.md.
"Organización de hooks de React" → react-hooks-organization.md.
Ejemplos buenos y malos

Usa subtítulos H4 (####) solo cuando haya múltiples ejemplos dentro de una sección de buenas o malas prácticas.
Usa el lenguaje de código apropiado en los bloques de código delimitados.
Evita los comentarios de código en los fragmentos de ejemplo. Proporciona una breve descripción entre el título y el bloque de código solo si es realmente necesario. Es importante mantener los ejemplos lo más breves posible, así que intenta evitar añadir una descripción si ya puedes expresar la idea en el título del ejemplo.
Secciones opcionales

Si la convención no tiene casos excepcionales, omite por completo la sección "Casos excepcionales".
Si no hay ejemplos reales, omite por completo la sección "Ejemplos reales".
Si no hay acuerdos relacionados, omite por completo la sección "Acuerdos relacionados".
Estilo

Maximiza la densidad de información: transmite lo máximo posible con las mínimas palabras posibles.
Termina cada frase con un punto, incluidos los elementos de las listas.
Evita documentar con la frase completa en énfasis fuerte.
Ejemplo de referencia

Consulta docs/database/not-null-fields.md como ejemplo completo de documentación correctamente estructurada.
