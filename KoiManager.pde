/**
 * Clase KoiManager
 * 
 * Gestiona la colección de peces koi en el estanque.
 * Maneja la creación, actualización y comportamiento colectivo de los peces.
 */
class KoiManager {
  ArrayList<Koi> kois = new ArrayList<Koi>();
  
  float canvasWidth;
  float canvasHeight;
  ArrayList<Rock> rocks = new ArrayList<Rock>(); // Referencia a las rocas a evitar
  final int MAX_FISH = 100; // Límite máximo de peces en el estanque
  
  /**
   * Constructor
   * 
   * @param canvasWidth Ancho del lienzo
   * @param canvasHeight Alto del lienzo
   * @param count Número de peces a crear
   */
  KoiManager(float canvasWidth, float canvasHeight, int count) {
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    
    // Solo inicializa los peces si se especifica una cantidad mayor que cero
    if (count > 0) {
      initialize(count);
    }
  }
  
  /**
   * Inicializa la colección de peces
   * 
   * @param count Número de peces a crear
   */
  void initialize(int count) {
    for (int i = 0; i < count; i++) {
      // Coordenadas iniciales del pez
      float x = 0;
      float y = 0;
      boolean validPosition = false;
      
      // Tamaño aleatorio (más pequeño para mejor vista aérea y lienzo más pequeño)
      float length = RandomUtils.randomFloat(12, 25);
      float koiWidth = length * 0.4; // Aproximadamente el ancho de un pez koi
      
      // Color aleatorio (rojo, blanco o negro)
      float colorRoll = random(1);
      String koiColor;
      
      if (colorRoll < 0.4) {
        koiColor = "#ff3333"; // Rojo más brillante
      } else if (colorRoll < 0.8) {
        koiColor = "#ffffff"; // Blanco
      } else {
        koiColor = "#333333"; // Gris oscuro en lugar de negro
      }
      
      // Intenta encontrar una posición válida (fuera de las rocas)
      int attempts = 0;
      while (!validPosition && attempts < 20) {
        x = RandomUtils.randomFloat(50, canvasWidth - 50);
        y = RandomUtils.randomFloat(50, canvasHeight - 50);
        
        // Comprueba que el pez no colisione con ninguna roca
        validPosition = true;
        for (Rock rock : rocks) {
          float dx = x - rock.position.x;
          float dy = y - rock.position.y;
          float distance = sqrt(dx * dx + dy * dy);
          
          // Si está demasiado cerca de una roca, la posición no es válida
          if (distance < rock.collisionRadius + koiWidth/2) {
            validPosition = false;
            break;
          }
        }
        
        attempts++;
      }
      
      // Si no se encontró una posición válida después de varios intentos,
      // coloca el pez en un lugar aleatorio de todas formas
      if (!validPosition) {
        x = RandomUtils.randomFloat(50, canvasWidth - 50);
        y = RandomUtils.randomFloat(50, canvasHeight - 50);
      }
      
      Koi koi = new Koi(x, y, length, koiColor);
      
      // Generar manchas
      generateSpots(koi);
      
      // Establecer objetivo inicial
      float padding = 50;
      
      // Intenta encontrar un objetivo lejos de las rocas
      float targetX, targetY;
      boolean validTarget = false;
      int targetAttempts = 0;
      
      do {
        targetX = RandomUtils.randomFloat(padding, canvasWidth - padding);
        targetY = RandomUtils.randomFloat(padding, canvasHeight - padding);
        
        // Comprueba si el objetivo está lejos de todas las rocas
        validTarget = true;
        for (Rock rock : rocks) {
          float dx = targetX - rock.position.x;
          float dy = targetY - rock.position.y;
          float distance = sqrt(dx * dx + dy * dy);
          
          // Si está demasiado cerca de una roca, rechaza este objetivo
          if (distance < rock.collisionRadius + koi.width) {
            validTarget = false;
            break;
          }
        }
        
        targetAttempts++;
      } while (!validTarget && targetAttempts < 10);
      
      koi.setTarget(targetX, targetY, RandomUtils.randomFloat(100, 300));
      
      kois.add(koi);
    }
  }
  
  /**
   * Crea un nuevo pez koi con propiedades personalizadas
   * 
   * @param x Posición x inicial
   * @param y Posición y inicial
   * @param length Longitud del pez
   * @param koiColor Color del pez en formato hexadecimal
   * @param spotColors Lista de colores de manchas seleccionados
   * @param spotCount Número de manchas (0-10)
   * @param spotSize Tamaño de las manchas (-1 para aleatorio)
   * @param seed Semilla para generación de patrones (0 para aleatorio)
   */
  void createCustomKoi(float x, float y, float length, String koiColor, ArrayList<String> spotColors, int spotCount, float spotSize, long seed) {
    // Verificar si ya alcanzamos el límite máximo de peces
    if (kois.size() >= MAX_FISH) {
      // Si ya llegamos al límite, no agregamos más peces
      return;
    }
    
    // Comprueba que la posición no colisione con rocas
    boolean validPosition = true;
    float koiWidth = length * 0.4;
    
    for (Rock rock : rocks) {
      float dx = x - rock.position.x;
      float dy = y - rock.position.y;
      float distance = sqrt(dx * dx + dy * dy);
      
      if (distance < rock.collisionRadius + koiWidth/2) {
        // Ajusta la posición para evitar la colisión
        float angle = atan2(dy, dx);
        float newDistance = rock.collisionRadius + koiWidth/2 + 10; // Añade margen
        x = rock.position.x + cos(angle) * newDistance;
        y = rock.position.y + sin(angle) * newDistance;
        break;
      }
    }
    
    // Asegura que el pez esté dentro del lienzo
    x = constrain(x, 50, canvasWidth - 50);
    y = constrain(y, 50, canvasHeight - 50);
    
    // Crea el nuevo pez koi
    Koi koi = new Koi(x, y, length, koiColor);
    
    // Limpia cualquier mancha generada automáticamente
    koi.spots.clear();
    
    // Solo añade manchas si spotCount > 0 y hay colores de mancha seleccionados
    if (spotCount > 0 && spotColors.size() > 0) {
      // Si se proporciona una semilla, la usamos para generar patrones idénticos
      if (seed != 0) {
        randomSeed(seed);
      }
      
      // Añade el número específico de manchas con distribución aleatoria
      for (int i = 0; i < spotCount; i++) {
        // Posición aleatoria para las manchas en todo el cuerpo
        float xPos = RandomUtils.randomFloat(0.0, 1.0);
        float yPos = RandomUtils.randomFloat(0.0, 1.0);
        
        // Selecciona un color aleatorio de la lista de colores seleccionados
        String spotColor = spotColors.get(RandomUtils.randomInt(0, spotColors.size() - 1));
        
        // Determina el tamaño de la mancha
        float actualSpotSize;
        if (spotSize < 0) { // Si es -1 (aleatorio)
          actualSpotSize = RandomUtils.randomFloat(0.2, 0.5);
        } else {
          // Aplica el tamaño especificado con una ligera variación para naturalidad
          actualSpotSize = spotSize * RandomUtils.randomFloat(0.9, 1.1);
        }
        
        // Añade la mancha
        Spot spot = new Spot(
          xPos,
          yPos,
          actualSpotSize,
          spotColor
        );
        koi.spots.add(spot);
      }
      
      // Restauramos la semilla aleatoria después de crear el patrón
      if (seed != 0) {
        randomSeed((long)millis());
      }
    }
    
    // Establece objetivo inicial (aleatorio pero lejos de rocas)
    float targetX = x + RandomUtils.randomFloat(-100, 100);
    float targetY = y + RandomUtils.randomFloat(-100, 100);
    
    // Asegura que el objetivo esté dentro del lienzo
    targetX = constrain(targetX, 50, canvasWidth - 50);
    targetY = constrain(targetY, 50, canvasHeight - 50);
    
    koi.setTarget(targetX, targetY, RandomUtils.randomFloat(100, 300));
    
    // Excita al pez cuando se crea
    koi.setExcited(60);
    
    // Añade el pez a la colección
    kois.add(koi);
  }
  
  /**
   * Sobrecarga del método createCustomKoi para mantener compatibilidad con código existente
   */
  void createCustomKoi(float x, float y, float length, String koiColor, ArrayList<String> spotColors, int spotCount, float spotSize) {
    createCustomKoi(x, y, length, koiColor, spotColors, spotCount, spotSize, 0); // Semilla 0 = patrones aleatorios
  }
  
  /**
   * Establece las rocas que los peces deben evitar
   * 
   * @param rocks Array de rocas en el estanque
   */
  void setRocks(ArrayList<Rock> rocks) {
    this.rocks = rocks;
  }
  
  /**
   * Genera manchas para un pez koi basándose en su color
   * 
   * @param koi Pez koi para el que generar manchas
   */
  void generateSpots(Koi koi) {
    int spotCount = 0;
    
    if (koi.koiColor.equals("#ffffff")) {
      // Koi blanco con manchas rojas/negras
      spotCount = RandomUtils.randomInt(2, 4);
      for (int i = 0; i < spotCount; i++) {
        Spot spot = new Spot(
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.2, 0.5),
          RandomUtils.randomBool(0.5) ? "#ff3333" : "#333333"
        );
        koi.spots.add(spot);
      }
    } else if (koi.koiColor.equals("#ff3333")) {
      // Koi rojo con manchas blancas
      spotCount = RandomUtils.randomInt(2, 4);
      for (int i = 0; i < spotCount; i++) {
        Spot spot = new Spot(
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.2, 0.5),
          "#ffffff"
        );
        koi.spots.add(spot);
      }
    } else {
      // Koi gris oscuro con manchas blancas/rojas
      spotCount = RandomUtils.randomInt(1, 3);
      for (int i = 0; i < spotCount; i++) {
        Spot spot = new Spot(
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.0, 1.0),
          RandomUtils.randomFloat(0.2, 0.5),
          RandomUtils.randomFloat(0, 1) > 0.7 ? "#ff3333" : "#ffffff"
        );
        koi.spots.add(spot);
      }
    }
  }
  
  /**
   * Actualiza todos los peces en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    // Elimina los peces que han terminado de hundirse
    for (int i = kois.size() - 1; i >= 0; i--) {
      Koi koi = kois.get(i);
      
      // Si el pez ha terminado de hundirse, lo eliminamos
      if (koi.isFinished()) {
        kois.remove(i);
        continue;
      }
      
      // Si el tiempo del objetivo ha terminado, establece un nuevo objetivo
      if (!koi.sinking && koi.targetTime <= 0) {
        float padding = 50;
        
        // Intenta encontrar un objetivo lejos de las rocas
        float targetX, targetY;
        boolean validTarget = false;
        int attempts = 0;
        
        do {
          targetX = RandomUtils.randomFloat(padding, canvasWidth - padding);
          targetY = RandomUtils.randomFloat(padding, canvasHeight - padding);
          
          // Comprueba si el objetivo está lejos de todas las rocas
          validTarget = true;
          for (Rock rock : rocks) {
            float dx = targetX - rock.position.x;
            float dy = targetY - rock.position.y;
            float distance = sqrt(dx * dx + dy * dy);
            
            // Si está demasiado cerca de una roca, rechaza este objetivo
            if (distance < rock.collisionRadius + koi.width) {
              validTarget = false;
              break;
            }
          }
          
          attempts++;
        } while (!validTarget && attempts < 10);
        
        // Establece el objetivo (válido o no después de los intentos máximos)
        koi.setTarget(targetX, targetY, RandomUtils.randomFloat(100, 300));
      }
      
      // Guarda la posición anterior antes de moverse
      Vector2D prevPosition = koi.position.clone();
      
      // Actualiza el pez normalmente
      koi.update(deltaTime, canvasWidth, canvasHeight);
      
      // Solo comprueba colisiones si el pez no está hundiéndose
      if (!koi.sinking) {
        // Comprueba colisiones con rocas después de moverse
        for (Rock rock : rocks) {
          float dx = koi.position.x - rock.position.x;
          float dy = koi.position.y - rock.position.y;
          float distance = sqrt(dx * dx + dy * dy);
          
          // Si hay colisión, vuelve a la posición anterior y cambia la dirección
          if (distance < rock.collisionRadius + koi.width / 2) {
            // Restaura la posición anterior
            koi.position.x = prevPosition.x;
            koi.position.y = prevPosition.y;
            
            // Calcula el ángulo de rebote (alejándose de la roca)
            float awayAngle = atan2(dy, dx);
            
            // Añade algo de aleatoriedad al ángulo de rebote
            float randomOffset = ((random(1) - 0.5) * PI) / 4;
            koi.angle = awayAngle + randomOffset;
            
            // Establece un nuevo objetivo lejos de la roca
            float newTargetDistance = 100 + random(100);
            float newTargetX = rock.position.x + cos(awayAngle) * newTargetDistance;
            float newTargetY = rock.position.y + sin(awayAngle) * newTargetDistance;
            
            // Asegura que el nuevo objetivo esté dentro del lienzo
            float targetX = max(50, min(canvasWidth - 50, newTargetX));
            float targetY = max(50, min(canvasHeight - 50, newTargetY));
            
            koi.setTarget(targetX, targetY, RandomUtils.randomFloat(50, 100));
            break;
          }
        }
      }
    }
  }
  
  /**
   * Atrae a los peces cercanos a un punto
   * 
   * @param x Coordenada X del punto de atracción
   * @param y Coordenada Y del punto de atracción
   * @param radius Radio de influencia
   */
  void attractToPoint(float x, float y, float radius) {
    Vector2D point = new Vector2D(x, y);
    
    for (Koi koi : kois) {
      float distance = Vector2D.distance(koi.position, point);
      
      if (distance < radius) {
        // Añade algo de aleatoriedad para evitar que todos los peces vayan al mismo punto exacto
        float randomOffset = 30;
        float targetX = x + (RandomUtils.randomFloat(0, 1) - 0.5) * randomOffset;
        float targetY = y + (RandomUtils.randomFloat(0, 1) - 0.5) * randomOffset;
        
        // Establece un tiempo de objetivo más largo para que los peces permanezcan en la zona
        koi.setTarget(targetX, targetY, RandomUtils.randomFloat(150, 250));
        
        // Pone al pez en estado de excitación
        koi.setExcited(RandomUtils.randomFloat(60, 120));
      }
    }
  }
  
  /**
   * Repele a los peces cercanos de un punto (efecto contrario a la atracción)
   * Si un pez está muy cerca del punto, será golpeado y se hundirá
   * 
   * @param x Coordenada X del punto de repulsión
   * @param y Coordenada Y del punto de repulsión
   * @param radius Radio de influencia
   */
  void repelFromPoint(float x, float y, float radius) {
    Vector2D point = new Vector2D(x, y);
    float directHitRadius = 15.0; // Radio para considerar un golpe directo
    
    for (Koi koi : kois) {
      float distance = Vector2D.distance(koi.position, point);
      
      // Si el pez ya está hundiéndose, lo ignoramos
      if (koi.sinking) {
        continue;
      }
      
      if (distance < directHitRadius) {
        // ¡Golpe directo! El pez comienza a hundirse
        koi.setSinking();
      }
      else if (distance < radius) {
        // Calcula el ángulo de alejamiento (dirección opuesta al punto)
        float dx = koi.position.x - x;
        float dy = koi.position.y - y;
        float angle = atan2(dy, dx);
        
        // Calcula un punto de destino en la dirección opuesta
        float escapeDistance = radius + RandomUtils.randomFloat(50, 150);
        float targetX = x + cos(angle) * escapeDistance;
        float targetY = y + sin(angle) * escapeDistance;
        
        // Asegura que el objetivo esté dentro del lienzo
        targetX = constrain(targetX, 50, canvasWidth - 50);
        targetY = constrain(targetY, 50, canvasHeight - 50);
        
        // Establece un tiempo de objetivo más corto para una reacción de huida rápida
        koi.setTarget(targetX, targetY, RandomUtils.randomFloat(50, 100));
        
        // Pone al pez en estado de excitación (representando el miedo)
        koi.setExcited(RandomUtils.randomFloat(30, 60));
      }
    }
  }
  
  /**
   * Obtiene todos los peces koi
   * 
   * @return ArrayList de peces koi
   */
  ArrayList<Koi> getKois() {
    return kois;
  }
  
  /**
   * Obtiene el número actual de peces koi en el estanque
   * 
   * @return Número de peces
   */
  int getKoiCount() {
    return kois.size();
  }
  
  /**
   * Elimina todos los peces koi del estanque con una animación de salida
   */
  void removeAllKoi() {
    // En lugar de eliminar los peces inmediatamente, les indicamos que salgan con animación
    for (Koi koi : kois) {
      // Solo marca para salir si el pez no está ya hundiéndose o saliendo
      if (!koi.sinking && !koi.exiting) {
        koi.setExiting(canvasWidth, canvasHeight);
      }
    }
  }
}

