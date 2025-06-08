/**
 * Clase RockManager
 * 
 * Gestiona las rocas decorativas en el estanque.
 * Maneja la creación y mantenimiento de las rocas.
 */
class RockManager {
  ArrayList<Rock> rocks = new ArrayList<Rock>();
  float canvasWidth;
  float canvasHeight;
  
  /**
   * Constructor
   * 
   * @param canvasWidth Ancho del lienzo
   * @param canvasHeight Alto del lienzo
   * @param plants Hojas de loto existentes
   * @param flowers Flores de loto existentes
   */
  RockManager(float canvasWidth, float canvasHeight, ArrayList<LotusLeaf> plants, ArrayList<LotusFlower> flowers) {
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    initialize(plants, flowers);
  }
  
  /**
   * Inicializa las rocas en el estanque
   * 
   * @param plants Hojas de loto existentes
   * @param flowers Flores de loto existentes
   */
  void initialize(ArrayList<LotusLeaf> plants, ArrayList<LotusFlower> flowers) {
    // Posiciones estratégicas para las rocas (máximo 5)
    // Con al menos 100px de distancia de los bordes (zona 500x500 en canvas 600x600)
    float margin = 100; // Margen mínimo desde los bordes
    float safeWidth = canvasWidth - (2 * margin);
    float safeHeight = canvasHeight - (2 * margin);
    
    PVector[] positions = {
      // Área superior izquierda
      new PVector(margin + safeWidth * 0.2, margin + safeHeight * 0.25),
      // Área superior derecha
      new PVector(margin + safeWidth * 0.8, margin + safeHeight * 0.3),
      // Área centro izquierda
      new PVector(margin + safeWidth * 0.15, margin + safeHeight * 0.6),
      // Área inferior derecha
      new PVector(margin + safeWidth * 0.75, margin + safeHeight * 0.8),
      // Área centro inferior
      new PVector(margin + safeWidth * 0.4, margin + safeHeight * 0.7)
    };
    
    // Crea rocas en posiciones estratégicas
    for (int i = 0; i < positions.length; i++) {
      // Intenta encontrar una posición sin colisiones
      boolean validPosition = false;
      float x = 0, y = 0;
      int attempts = 0;
      
      while (!validPosition && attempts < 20) {
        // Añade algo de aleatoriedad a las posiciones exactas
        float offsetX = RandomUtils.randomFloat(-30, 30);
        float offsetY = RandomUtils.randomFloat(-30, 30);
        
        x = positions[i].x + offsetX;
        y = positions[i].y + offsetY;
        
        // Comprueba colisiones con plantas
        validPosition = true;
        
        // Distancia mínima entre rocas y plantas/flores
        float minDistanceToPlants = 60;
        
        // Comprueba colisiones con hojas
        for (LotusLeaf plant : plants) {
          float dx = plant.position.x - x;
          float dy = plant.position.y - y;
          float distance = sqrt(dx * dx + dy * dy);
          
          if (distance < minDistanceToPlants) {
            validPosition = false;
            break;
          }
        }
        
        // Si no hay colisión con plantas, comprueba con flores
        if (validPosition) {
          for (LotusFlower flower : flowers) {
            float dx = flower.position.x - x;
            float dy = flower.position.y - y;
            float distance = sqrt(dx * dx + dy * dy);
            
            if (distance < minDistanceToPlants) {
              validPosition = false;
              break;
            }
          }
        }
        
        attempts++;
      }
      
      // Si encontramos una posición válida, creamos la roca
      if (validPosition) {
        rocks.add(new Rock(x, y));
      }
    }
  }
  
  /**
   * Obtiene todas las rocas
   * 
   * @return ArrayList de rocas
   */
  ArrayList<Rock> getRocks() {
    return rocks;
  }
}
