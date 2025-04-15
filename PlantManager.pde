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

