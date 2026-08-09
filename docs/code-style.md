🎯 Estilo de código

💡 Convención

El proyecto usa eslint-config-codely como preset base de ESLint. El modo estricto de TypeScript está habilitado junto con soporte de decoradores (experimentalDecorators + emitDecoratorMetadata).

Reglas clave aplicadas:

@typescript-eslint/explicit-function-return-type: error — toda función debe declarar su tipo de retorno.
TypeScript strict: true en tsconfig.json.
Los problemas de lint se corrigen con npm run lint:fix. La suite completa de comprobaciones se ejecuta con make checks (lint + build + test).

🏆 Beneficios

Los tipos de retorno explícitos dejan claros los contratos de las funciones y detectan cambios de tipo no intencionados en tiempo de compilación.
El modo estricto elimina categorías enteras de bugs en tiempo de ejecución (null/undefined, any implícito).
Un preset compartido garantiza que todos los miembros del equipo y los agentes de IA produzcan un estilo de código consistente.
👀 Ejemplos

✅ Correcto: Función con tipo de retorno explícito

async searchAll(): Promise<CookedDishPrimitives[]> {
	const dishes = await this.repository.searchAll();

	return dishes.map((dish) => dish.toPrimitives());
}
❌ Incorrecto: Función sin tipo de retorno

async searchAll() {
	const dishes = await this.repository.searchAll();

	return dishes.map((dish) => dish.toPrimitives());
}
🧐 Ejemplos reales

Configuración de ESLint: eslint.config.mjs
Configuración de TypeScript: tsconfig.json
Caso de uso con tipos de retorno explícitos: src/contexts/dishes/cooked-dishes/application/search-all/AllCookedDishesSearcher.ts
🔗 Acuerdos relacionados

Arquitectura Hexagonal
