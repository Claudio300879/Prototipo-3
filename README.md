Fundamentos y Estructura Básica
Máquina de Estados: Gestión de escenas con los estados "MENU", "REGLAS", "JUGANDO", "PAUSA", "GAME_OVER" y "VICTORIA".

Estructuras de Datos y Tablas: Control de entidades lógicas como mosca, comida, ventanas, pantalla y sonidos.

Ciclo de Vida de LÖVE2D y Gestión de Entradas: Uso de funciones principales como love.load(), love.update(dt), love.draw() y love.keypressed(key).

Sprites, Animaciones y Canvas Pixel-Art
Spritesheets y Quads: Recorte y renderizado eficiente mediante love.graphics.newQuad().

Procesamiento con ImageData: Manipulación de píxeles en tiempo de ejecución con imageData:mapPixel() para eliminar fondos y limpiar texturas.

Escalado Pixel-Art: Configuración de renderizado nítido con love.graphics.setDefaultFilter("nearest", "nearest") sobre un love.graphics.newCanvas() escalado.

Audio, Colisiones y Físicas
Colisiones AABB: Detección de superposición de cajas delimitadoras.

Hitboxes Ajustados y Física de Empuje: Márgenes personalizados para gestionar el bloqueo y empuje de obstáculos.

Sistema de Audio: Carga de efectos de sonido en modo "static" y música de fondo en bucle mediante "stream".

Arquitectura Avanzada y Patrones de Diseño 
Corrutinas (coroutine): Animaciones asíncronas fluidas para la variación orgánica de opacidad, escala y rotación de las nubes de gas tóxico (Raid).

Patrón Singleton: Instancia única centralizada mediante getInstance() para la gestión unificada de entidades y recursos globales.

Patrón Object Pool: Reutilización eficiente de partículas y nubes para optimizar el uso de memoria en tiempo de ejecución.

Diseño Orientado a Datos (Data Locality): Estructuración de arreglos planos y contiguos en memoria para acelerar el procesamiento secuencial de los elementos del humo.