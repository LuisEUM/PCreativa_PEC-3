/**
 * Clase Rock
 * 
 * Representa una roca decorativa circular en el estanque.
 * Las rocas añaden elementos naturales y puntos focales que
 * complementan las plantas y los peces.
 */
class Rock {
  Vector2D position; // Posición central
  float size; // Tamaño de la roca
  float rotation; // Rotación en radianes
  String rockColor; // Color base de la roca
  float roughness; // Factor de irregularidad (0-1)
  float shadowOffset; // Desplazamiento de sombra
  float collisionRadius; // Radio para colisiones con peces
  
  /**
   * Constructor
   * 
   * @param x Posición x del centro
   * @param y Posición y del centro
   */
  Rock(float x, float y) {
    this.position = new Vector2D(x, y);
    this.size = RandomUtils.randomFloat(15, 40); // Tamaño variable
    this.rotation = RandomUtils.randomAngle();
    
    // Colores de roca gris más claros para mejor visibilidad contra el fondo azul
    String[] rockColors = {
      "#BBBBBB", // Gris claro
      "#CCCCCC", // Gris más claro
      "#DDDDDD", // Gris muy claro
      "#AAAAAA", // Gris medio-claro
      "#C0C0C0"  // Gris plateado
    };
    this.rockColor = rockColors[floor(random(rockColors.length))];
    
    this.roughness = RandomUtils.randomFloat(0.2, 0.4);
    this.shadowOffset = RandomUtils.randomFloat(2, 3);
    
    // Radio de colisión ligeramente mayor que el tamaño visual
    this.collisionRadius = this.size * 0.8;
  }
}

