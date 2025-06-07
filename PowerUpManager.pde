/**
 * Clase PowerUpManager
 * 
 * Gestiona la generación y comportamiento de power-ups en el juego.
 * Los power-ups aparecen como burbujas que contienen diferentes beneficios:
 * - Rocas adicionales
 * - Koi adicionales
 * - Comida adicional
 */
class PowerUpManager {
  ArrayList<PowerUp> powerUps;
  float spawnTimer;
  float spawnInterval;
  float canvasWidth;
  float canvasHeight;
  ArrayList<Rock> rocks; // Referencia a las rocas para evitar spawn sobre ellas
  
  /**
   * Constructor
   */
  PowerUpManager(float canvasWidth, float canvasHeight, ArrayList<Rock> rocks) {
    this.powerUps = new ArrayList<PowerUp>();
    this.spawnTimer = 0;
    this.spawnInterval = 1200; // 20 segundos (60 frames * 20)
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.rocks = rocks;
  }
  
  /**
   * Actualiza todos los power-ups
   */
  void update(float deltaTime) {
    // Actualizar timer de spawn
    spawnTimer += deltaTime;
    
    // Generar nuevo power-up cada 20 segundos
    if (spawnTimer >= spawnInterval) {
      spawnPowerUp();
      spawnTimer = 0;
    }
    
    // Actualizar y eliminar power-ups expirados
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp powerUp = powerUps.get(i);
      powerUp.update(deltaTime);
      
      if (powerUp.isExpired()) {
        powerUps.remove(i);
      }
    }
  }
  
  /**
   * Genera un nuevo power-up en una posición válida
   */
  void spawnPowerUp() {
    // Determinar tipo y cantidad
    PowerUpType type = getRandomType();
    int amount = getRandomAmount();
    
    // Encontrar una posición válida
    Vector2D position = findValidPosition();
    
    // Crear y añadir el power-up
    PowerUp powerUp = new PowerUp(position.x, position.y, type, amount);
    powerUps.add(powerUp);
  }
  
  /**
   * Encuentra una posición válida para el power-up (lejos de rocas)
   */
  Vector2D findValidPosition() {
    Vector2D position = new Vector2D();
    boolean validPosition = false;
    int attempts = 0;
    float padding = 50;
    
    while (!validPosition && attempts < 20) {
      position.x = RandomUtils.randomFloat(padding, canvasWidth - padding);
      position.y = RandomUtils.randomFloat(padding, canvasHeight - padding);
      
      validPosition = true;
      
      // Verificar distancia a rocas
      for (Rock rock : rocks) {
        float distance = Vector2D.distance(position, rock.position);
        if (distance < rock.size + 30) {
          validPosition = false;
          break;
        }
      }
      
      attempts++;
    }
    
    // Si no encontramos posición válida, usar una posición aleatoria
    if (!validPosition) {
      position.x = RandomUtils.randomFloat(padding, canvasWidth - padding);
      position.y = RandomUtils.randomFloat(padding, canvasHeight - padding);
    }
    
    return position;
  }
  
  /**
   * Obtiene un tipo aleatorio de power-up
   */
  PowerUpType getRandomType() {
    float roll = random(1);
    if (roll < 0.33) return PowerUpType.ROCKS;
    if (roll < 0.66) return PowerUpType.KOI;
    return PowerUpType.FOOD;
  }
  
  /**
   * Obtiene una cantidad aleatoria para el power-up
   */
  int getRandomAmount() {
    float roll = random(1);
    if (roll < 0.5) return 5;
    if (roll < 0.8) return 10;
    return 20;
  }
  
  /**
   * Verifica colisiones con koi y aplica efectos
   */
  void checkCollisions(ArrayList<Koi> kois, KoiManager koiManager) {
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp powerUp = powerUps.get(i);
      
      for (Koi koi : kois) {
        if (powerUp.checkCollision(koi)) {
          // Aplicar efecto según tipo
          applyPowerUp(powerUp, koiManager);
          powerUps.remove(i);
          break;
        }
      }
    }
  }
  
  /**
   * Aplica el efecto del power-up
   */
  void applyPowerUp(PowerUp powerUp, KoiManager koiManager) {
    switch (powerUp.type) {
      case ROCKS:
        if (koiManager.getUIManager() instanceof WavesUIManager) {
          ((WavesUIManager)koiManager.getUIManager()).applyPowerUp(powerUp);
        }
        break;
      case KOI:
        // Añadir kois nuevos
        for (int i = 0; i < powerUp.amount; i++) {
          float x = powerUp.position.x + random(-20, 20);
          float y = powerUp.position.y + random(-20, 20);
          koiManager.addKoiForced(x, y, 15, getRandomKoiColor());
        }
        break;
      case FOOD:
        if (koiManager.getUIManager() instanceof WavesUIManager) {
          ((WavesUIManager)koiManager.getUIManager()).applyPowerUp(powerUp);
        }
        break;
    }
  }
  
  /**
   * Obtiene un color aleatorio para nuevos koi
   */
  String getRandomKoiColor() {
    float roll = random(1);
    if (roll < 0.4) return "#ff3333";
    if (roll < 0.8) return "#ffffff";
    return "#333333";
  }
  
  /**
   * Renderiza todos los power-ups
   */
  void render() {
    for (PowerUp powerUp : powerUps) {
      powerUp.render();
    }
  }
}

/**
 * Tipos de power-up disponibles
 */
enum PowerUpType {
  ROCKS,
  KOI,
  FOOD
} 