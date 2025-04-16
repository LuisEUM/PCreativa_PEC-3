# Estanque de Peces Koi

Este proyecto es una simulación interactiva de un estanque de peces koi creado con Processing. Los usuarios pueden añadir peces koi personalizados y verlos nadar por el estanque evitando obstáculos.

## Características

- Simulación realista del movimiento de peces koi en un estanque
- Interfaz de usuario intuitiva y mejorada para personalizar y crear nuevos koi
- Amplio rango de opciones de personalización:
  - Diferentes tamaños (XS, S, M, L, XL)
  - Diversos colores base (Naranja, Blanco, Negro, Dorado, Plateado, Rojo)
  - Patrones de manchas completamente personalizables:
    - Múltiples colores de manchas seleccionables
    - Control preciso de cantidad de manchas (0-10) mediante botones
    - Varios tamaños de manchas (S, M, L o aleatorio)
    - Opción para generar koi con patrones idénticos o aleatorios
  - Creación de múltiples koi simultáneamente (1-99)
- Comportamiento de evasión de obstáculos
- Interacción entre peces con comportamiento de cardumen
- Gestión de población de peces:
  - Límite máximo de 100 peces en el estanque
  - Contador visual del número actual de peces
  - Botón de papelera para vaciar el estanque con animación de salida
- Ciclo de tiempo del día con cambios visuales:
  - Día (agua azul)
  - Atardecer (agua naranja)
  - Noche (agua azul oscuro)
  - Amanecer (agua azul claro)
- Interacción con el usuario:
  - Clic izquierdo: Alimentar a los peces (los atrae)
  - Clic derecho: Tirar rocas (los repele)
  - Golpe directo: Si una roca golpea directamente a un pez, este se hundirá gradualmente con una animación dramática

## Cómo usar

1. Ejecute el sketch en Processing
2. Para agregar un nuevo pez koi, haga clic en el botón "+" en la esquina superior derecha
3. Personalice su koi con las opciones disponibles:
   - Seleccione el tamaño, color base y colores de manchas deseados
   - Ajuste la cantidad de manchas usando los botones + y -
   - Elija el tamaño de las manchas
   - Vista previa en tiempo real de cómo se verá su koi
   - Especifique cuántos peces desea crear (1-99) y si todos tendrán patrones idénticos o aleatorios
4. Haga clic en "Crear" para añadir los peces al estanque, o en la X para cancelar
5. Para cambiar el ciclo de tiempo del día (día, atardecer, noche, amanecer), haga clic en el botón del sol/luna que está a la derecha del botón "+"
6. Para eliminar todos los peces del estanque, haga clic en el botón de papelera en la esquina inferior izquierda
7. Interactúe con los peces:
   - Clic izquierdo: Alimentar a los peces (los atrae)
   - Clic derecho: Tirar rocas (los repele)
   - Para eliminar un pez, haga clic derecho muy cerca de él para golpearlo directamente con una roca

## Efectos visuales

- **Ondulaciones de agua**: Aparecen cuando se tira comida o rocas al estanque
- **Pétalos flotantes**: Caen lentamente sobre el agua, creando ondulaciones
- **Ciclo día/noche**: Cambia el color del agua según el momento del día
- **Animación de hundimiento**: Cuando un pez es golpeado por una roca, se detiene, disminuye su tamaño progresivamente mientras aparecen ondulaciones en el agua y burbujas, y finalmente desaparece
- **Animación de salida**: Cuando se usa la papelera, los peces nadan rápidamente hacia los bordes del estanque y desaparecen
- **Vista previa interactiva**: Al personalizar los koi, se muestra una vista previa animada con movimiento de cola
- **Contador de peces**: Muestra la cantidad actual y el límite máximo de peces en el estanque

## Requisitos

- Processing 3.0 o superior

## Estructura del proyecto

- `lurdaneta_PEC2.pde`: Archivo principal que coordina todos los componentes de la simulación
- `PondManager.pde`: Actúa como fachada principal y coordina todos los gestores
- `KoiManager.pde`: Gestiona la colección de peces y su comportamiento
- `KoiCreator.pde`: Maneja la interfaz para crear nuevos peces
- `UIManager.pde`: Gestiona los elementos de la interfaz
- `PlantManager.pde`: Administra todas las plantas acuáticas del estanque
- `PetalManager.pde`: Gestiona los pétalos de flores que caen en el agua
- `RippleManager.pde`: Controla las ondulaciones en la superficie del agua
- `FoodManager.pde`: Gestiona las partículas de comida
- `RockManager.pde`: Gestiona las rocas decorativas
- `ColorUtils.pde`: Utilidades para el manejo de colores
- `RandomUtils.pde`: Funciones para generación de valores aleatorios
- `Vector2D.pde`: Implementación de vectores 2D para los cálculos de movimiento
- `Button.pde`: Clase para crear botones interactivos
- `Koi.pde`: Clase principal para los peces koi (incluye la clase interna Spot para las manchas)
- `LotusLeaf.pde`: Clase para las hojas de loto
- `LotusFlower.pde`: Clase para las flores de loto
- `Petal.pde`: Clase para los pétalos de flores
- `Ripple.pde`: Clase para las ondulaciones del agua
- `FoodParticle.pde`: Clase para las partículas de comida
- `Rock.pde`: Clase para las rocas del estanque

## Arquitectura del Proyecto

Este proyecto utiliza una arquitectura de Facade combinada con el patrón Manager. Cada elemento de la simulación (peces, plantas, rocas, etc.) se gestiona a través de su propio gestor especializado, y todos estos gestores están coordinados por un gestor principal (PondManager) que actúa como fachada para simplificar las interacciones entre los componentes.

### Gestores Principales:

- **PondManager**: Fachada principal que coordina todos los demás gestores e implementa el patrón Facade.
- **KoiManager**: Gestiona los peces koi, su comportamiento y movimiento.
- **PlantManager**: Administra plantas acuáticas (hojas y flores de loto).
- **RockManager**: Gestiona las rocas decorativas y proporciona obstáculos para los peces.
- **RippleManager**: Controla los efectos de ondulación en la superficie del agua.
- **PetalManager**: Gestiona los pétalos de flor que flotan en el estanque.
- **FoodManager**: Administra las partículas de comida.
- **UIManager**: Gestiona la interfaz de usuario para interacciones avanzadas.

## Instalación

1. Clone el repositorio
2. Abra el proyecto en Processing
3. Ejecute el sketch

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo LICENSE para más detalles.
