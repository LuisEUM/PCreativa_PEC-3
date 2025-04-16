# Estanque de Peces Koi

Este proyecto es una simulación interactiva de un estanque de peces koi creado con Processing. Los usuarios pueden añadir peces koi personalizados y verlos nadar por el estanque evitando obstáculos.

## Características

- Simulación realista del movimiento de peces koi en un estanque
- Interfaz interactiva para agregar nuevos koi personalizados
- Opciones de personalización:
  - Diferentes tamaños (XS, S, M, L, XL)
  - Diversos colores base
  - Patrones de manchas personalizables (colores, cantidad y tamaño)
- Comportamiento de evasión de obstáculos
- Interacción entre peces
- Ciclo de tiempo del día:
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
3. Personalice su koi con las opciones disponibles
4. Haga clic en "Crear" para agregar el pez al estanque
5. Para cambiar el tiempo del día, haga clic en el botón circular a la izquierda del botón "+"
6. Interactúe con los peces:
   - Clic izquierdo: Alimentar a los peces (los atrae)
   - Clic derecho: Tirar rocas (los repele)
   - Para eliminar un pez, haga clic derecho muy cerca de él para golpearlo directamente con una roca

## Efectos visuales

- **Ondulaciones de agua**: Aparecen cuando se tira comida o rocas al estanque
- **Pétalos flotantes**: Caen lentamente sobre el agua, creando ondulaciones
- **Ciclo día/noche**: Cambia el color del agua según el momento del día
- **Animación de hundimiento**: Cuando un pez es golpeado por una roca, se detiene, disminuye su tamaño progresivamente mientras aparecen ondulaciones en el agua y burbujas, y finalmente desaparece

## Requisitos

- Processing 3.0 o superior

## Estructura del proyecto

- `KoiManager.pde`: Gestiona la colección de peces y su comportamiento
- `KoiCreator.pde`: Maneja la interfaz para crear nuevos peces
- `UIManager.pde`: Gestiona los elementos de la interfaz
- `Vector2D.pde`: Implementación de vectores 2D para los cálculos de movimiento
- `PondManager.pde`: Coordina todos los elementos del estanque
- `FoodManager.pde`: Gestiona las partículas de comida
- `RockManager.pde`: Gestiona las rocas decorativas

## Instalación

1. Clone el repositorio

```
git clone https://github.com/su-usuario/estanque-koi.git
```

2. Abra el proyecto en Processing
3. Ejecute el sketch

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo LICENSE para más detalles.
