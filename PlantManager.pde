/**
 * Clase PlantManager
 * 
 * Gestiona todas las plantas acuáticas en el estanque.
 * Maneja la creación, actualización y comportamiento de
 * hojas y flores de loto.
 */
class PlantManager {
  ArrayList<LotusLeaf> leaves = new ArrayList<LotusLeaf>();
  ArrayList<LotusFlower> flowers = new ArrayList<LotusFlower>();
  float canvasWidth;
  float canvasHeight;
  
  /**
   * Constructor
   * 
   * @param canvasWidth Ancho del lienzo
   * @param canvasHeight Alto del lienzo
   */
  PlantManager(float canvasWidth, float canvasHeight) {
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    initialize();
  }
  
  /**
   * Inicializa las plantas en el estanque
   */
  void initialize() {
    // Posiciones estratégicas para grupos de plantas (10 hojas en total)
    PlantGroup[] plantGroups = {
      // Grupo 1: Esquina superior izquierda
      new PlantGroup(canvasWidth * 0.2, canvasHeight * 0.15, 80, 3, 1),
      // Grupo 2: Borde derecho, mitad superior
      new PlantGroup(canvasWidth * 0.85, canvasHeight * 0.35, 70, 2, 1),
      // Grupo 3: Borde izquierdo, mitad inferior
      new PlantGroup(canvasWidth * 0.15, canvasHeight * 0.65, 70, 2, 1),
      // Grupo 4: Esquina inferior derecha
      new PlantGroup(canvasWidth * 0.8, canvasHeight * 0.85, 80, 3, 2)
    };
    
    // Crea plantas en cada posición estratégica
    for (PlantGroup group : plantGroups) {
      createPlantGroup(group);
    }
  }
  
  /**
   * Crea un grupo de plantas en una posición específica
   * evitando superposiciones entre hojas
   * 
   * @param group Configuración del grupo de plantas
   */
  void createPlantGroup(PlantGroup group) {
    // Distancia mínima entre hojas (basada en el tamaño máximo de hoja)
    float minDistanceBetweenLeaves = 50; // Reducida para lienzo más pequeño
    
    // Crea hojas de loto con distancia mínima entre ellas
    for (int i = 0; i < group.leafCount; i++) {
      boolean validPosition = false;
      float x = 0, y = 0;
      int attempts = 0;
      int maxAttempts = 30; // Más intentos para encontrar posiciones válidas
      
      while (!validPosition && attempts < maxAttempts) {
        // Genera posición aleatoria dentro del radio del grupo
        // Usa distribución más uniforme para evitar agrupamiento
        float angle = RandomUtils.randomAngle();
        
        // Usa distribución no lineal para el radio para evitar agrupamiento en el centro
        float distanceFactor = sqrt(RandomUtils.randomFloat(0.1, 1.0)); // Raíz cuadrada para distribución más uniforme
        float distance = group.radius * distanceFactor;
        
        x = group.centerX + cos(angle) * distance;
        y = group.centerY + sin(angle) * distance;
        
        // Comprueba la distancia con todas las hojas existentes (incluyendo las de otros grupos)
        validPosition = true;
        for (LotusLeaf leaf : leaves) {
          float dx = x - leaf.position.x;
          float dy = y - leaf.position.y;
          float distance2 = sqrt(dx * dx + dy * dy);
          
          // Calcula la distancia mínima basada en los tamaños de ambas hojas
          // Esto asegura que las hojas más grandes tengan más espacio entre ellas
          float combinedSize = 50 + leaf.size; // Valor base + tamaño de hoja
          
          if (distance2 < combinedSize) {
            validPosition = false;
            break;
          }
        }
        
        attempts++;
      }
      
      // Si encontramos una posición válida, creamos la hoja
      if (validPosition) {
        leaves.add(new LotusLeaf(x, y));
      }
    }
    
    // Crea flores de loto (generalmente menos que hojas)
    for (int i = 0; i < group.flowerCount; i++) {
      // Posición aleatoria dentro del radio, pero más cerca del centro
      float angle = RandomUtils.randomAngle();
      float distance = RandomUtils.randomFloat(0, group.radius * 0.5); // Más cerca del centro
      float x = group.centerX + cos(angle) * distance;
      float y = group.centerY + sin(angle) * distance;
      
      // Comprueba que la flor no esté demasiado cerca de otras flores
      boolean validPosition = true;
      for (LotusFlower flower : flowers) {
        float dx = x - flower.position.x;
        float dy = y - flower.position.y;
        float dist = sqrt(dx * dx + dy * dy);
        
        if (dist < 40) { // Distancia mínima entre flores
          validPosition = false;
          break;
        }
      }
      
      if (validPosition) {
        flowers.add(new LotusFlower(x, y));
      }
    }
  }
  
  /**
   * Actualiza todas las plantas en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   * @param time Tiempo global para animaciones
   */
  void update(float deltaTime, float time) {
    // Actualiza hojas de loto
    for (LotusLeaf leaf : leaves) {
      leaf.update(deltaTime, time);
    }
    
    // Actualiza flores de loto
    for (LotusFlower flower : flowers) {
      flower.update(deltaTime);
    }
  }
  
  /**
   * Obtiene todas las hojas de loto
   * 
   * @return ArrayList de hojas de loto
   */
  ArrayList<LotusLeaf> getLeaves() {
    return leaves;
  }
  
  /**
   * Obtiene todas las flores de loto
   * 
   * @return ArrayList de flores de loto
   */
  ArrayList<LotusFlower> getFlowers() {
    return flowers;
  }
  
  /**
   * Renderiza todas las plantas
   */
  void render() {
    // Renderiza hojas de loto
    for (LotusLeaf leaf : leaves) {
      renderLotusLeaf(leaf);
    }
    
    // Renderiza flores de loto
    for (LotusFlower flower : flowers) {
      renderLotusFlower(flower);
    }
  }
  
  /**
   * Renderiza una hoja de loto
   */
  void renderLotusLeaf(LotusLeaf leaf) {
    pushMatrix();
    translate(leaf.position.x, leaf.position.y);
    rotate(leaf.rotation);
    
    // Dibuja primero la sombra
    pushMatrix();
    translate(leaf.shadowOffset, leaf.shadowOffset);
    noStroke();
    fill(0, 0, 0, 76); // Negro con 30% de opacidad
    drawLeafShape(leaf.size, leaf.variation);
    popMatrix();
    
    // Dibuja la hoja con color verde brillante
    noStroke();
    fill(34, 180, 34, leaf.opacity * 255); // Verde brillante
    drawLeafShape(leaf.size, leaf.variation);
    
    // Dibuja venas muy sutiles
    stroke(255, 255, 255, 25); // Blanco con 10% de opacidad
    strokeWeight(0.5);
    
    int veins = 8;
    for (int i = 0; i < veins; i++) {
      float angle = (TWO_PI / veins) * i;
      line(0, 0, cos(angle) * leaf.size * 0.9, sin(angle) * leaf.size * 0.9);
    }
    
    popMatrix();
  }
  
  /**
   * Renderiza una flor de loto
   */
  void renderLotusFlower(LotusFlower flower) {
    pushMatrix();
    translate(flower.position.x, flower.position.y);
    rotate(flower.rotation);
    
    // Dibuja primero la sombra
    pushMatrix();
    translate(flower.shadowOffset, flower.shadowOffset);
    noStroke();
    fill(0, 0, 0, 76); // Negro con 30% de opacidad
    ellipse(0, 0, flower.size * flower.bloomProgress * 2, flower.size * flower.bloomProgress * 2);
    popMatrix();
    
    // Calcula el factor de floración basado en el estado
    float bloomFactor = flower.bloomProgress;
    
    // Dibuja el centro de la flor
    noStroke();
    fill(255, 235, 59); // Amarillo para el centro
    ellipse(0, 0, flower.size * 0.6, flower.size * 0.6);
    
    // Dibuja los pétalos
    int petalCount = flower.petalCount;
    color baseColor = ColorUtils.hexToColor(flower.flowerColor);
    
    for (int i = 0; i < petalCount; i++) {
      float angle = (TWO_PI / petalCount) * i;
      float petalLength = flower.size * bloomFactor;
      
      pushMatrix();
      rotate(angle);
      
      // Dibuja la forma del pétalo
      noStroke();
      fill(baseColor);
      beginShape();
      vertex(0, 0);
      quadraticVertex(petalLength * 0.5, petalLength * 0.3, petalLength, 0);
      quadraticVertex(petalLength * 0.5, -petalLength * 0.3, 0, 0);
      endShape(CLOSE);
      
      popMatrix();
    }
    
    popMatrix();
  }
  
  /**
   * Dibuja la forma de una hoja de loto
   */
  void drawLeafShape(float size, float variation) {
    beginShape();
    
    // Dibuja un círculo casi completo con una pequeña muesca
    int segments = 36;
    for (int i = 0; i < segments; i++) {
      float angle = map(i, 0, segments, 0, TWO_PI * 0.9);
      float x = cos(angle) * size;
      float y = sin(angle) * size;
      vertex(x, y);
    }
    
    // Añade una pequeña muesca para hacer la hoja más realista
    quadraticVertex(size * 0.5, -size * 0.2 * variation, 0, 0);
    
    endShape(CLOSE);
  }
}

/**
 * Clase PlantGroup
 * 
 * Clase de datos simple para almacenar información sobre grupos de plantas
 */
class PlantGroup {
  float centerX;
  float centerY;
  float radius;
  int leafCount;
  int flowerCount;
  
  PlantGroup(float centerX, float centerY, float radius, int leafCount, int flowerCount) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.leafCount = leafCount;
    this.flowerCount = flowerCount;
  }
}
