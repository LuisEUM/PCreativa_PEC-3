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

## Cómo usar

1. Ejecute el sketch en Processing
2. Para agregar un nuevo pez koi, haga clic en el botón "+" en la esquina superior derecha
3. Personalice su koi con las opciones disponibles
4. Haga clic en "Crear" para agregar el pez al estanque

## Requisitos

- Processing 3.0 o superior

## Estructura del proyecto

- `KoiManager.pde`: Gestiona la colección de peces y su comportamiento
- `KoiCreator.pde`: Maneja la interfaz para crear nuevos peces
- `UIManager.pde`: Gestiona los elementos de la interfaz
- `Vector2D.pde`: Implementación de vectores 2D para los cálculos de movimiento

## Instalación

1. Clone el repositorio

```
git clone https://github.com/su-usuario/estanque-koi.git
```

2. Abra el proyecto en Processing
3. Ejecute el sketch

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo LICENSE para más detalles.
