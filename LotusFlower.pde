/**
 * Clase LotusFlower
 * 
 * Representa una flor de loto en el estanque. Las flores de loto
 * tienen un ciclo de vida que incluye abrirse y cerrarse, y añaden
 * un importante elemento estético al estanque.
 */
class LotusFlower {
  Vector2D position; // Posición central
  float size; // Tamaño base de la flor
  String flowerColor; // Color principal
  String state; // Estado actual: "bud", "opening", "bloom", "closing"
  float bloomProgress; // Progreso de apertura (0-1)
  float bloomSpeed; // Velocidad de apertura/cierre
  float rotation; // Rotación en radianes
  float shadowOffset; // Desplazamiento de sombra
  int petalCount; // Número de pétalos
  float stateTime; // Tiempo en estado actual
  float wavePhase; // Fase de onda
  float waveSpeed; // Velocidad de onda
  
  /**
   * Constructor
   * 
   * @param x Posición x del centro
   * @param y Posición y del centro
   */
  LotusFlower(float x, float y) {
    this.position = new Vector2D(x, y);
    this.size = RandomUtils.randomFloat(15, 25);
    
    // Posibles colores para las flores de loto
    String[] colors = {
      "#FFD1DC", // Rosa brillante
      "#ffffff", // Blanco
      "#FF80AB", // Rosa vibrante
      "#FFECEF"  // Rosa muy claro
    };
    this.flowerColor = colors[floor(random(colors.length))];
    
    // Comienza como capullo con probabilidad de estar en otro estado
    float stateRoll = random(1);
    if (stateRoll < 0.6) {
      this.state = "bud";
      this.bloomProgress = 0;
    } else if (stateRoll < 0.8) {
      this.state = "opening";
      this.bloomProgress = RandomUtils.randomFloat(0.1, 0.7);
    } else {
      this.state = "bloom";
      this.bloomProgress = 1;
    }
    
    this.bloomSpeed = RandomUtils.randomFloat(0.0001, 0.0005);
    this.rotation = RandomUtils.randomAngle();
    this.shadowOffset = RandomUtils.randomFloat(2, 4);
    this.petalCount = RandomUtils.randomInt(8, 12);
    this.stateTime = 0;
    this.wavePhase = RandomUtils.randomFloat(0, TWO_PI);
    this.waveSpeed = RandomUtils.randomFloat(0.001, 0.002);
  }
  
  /**
   * Actualiza el estado de la flor en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    // Actualiza la fase de onda
    this.wavePhase += this.waveSpeed * deltaTime;
    if (this.wavePhase > TWO_PI) {
      this.wavePhase -= TWO_PI;
    }
    
    // Aumenta el tiempo en el estado actual
    this.stateTime += deltaTime;
    
    // Actualiza según el estado
    if (this.state.equals("bud")) {
      // Permanece como capullo por un tiempo
      if (this.stateTime > RandomUtils.randomFloat(10000, 30000)) {
        this.state = "opening";
        this.stateTime = 0;
      }
    } 
    else if (this.state.equals("opening")) {
      // Se abre gradualmente
      this.bloomProgress += this.bloomSpeed * deltaTime;
      if (this.bloomProgress >= 1) {
        this.bloomProgress = 1;
        this.state = "bloom";
        this.stateTime = 0;
      }
    } 
    else if (this.state.equals("bloom")) {
      // Permanece abierta por un tiempo
      if (this.stateTime > RandomUtils.randomFloat(20000, 40000)) {
        this.state = "closing";
        this.stateTime = 0;
      }
    } 
    else if (this.state.equals("closing")) {
      // Se cierra gradualmente
      this.bloomProgress -= this.bloomSpeed * deltaTime;
      if (this.bloomProgress <= 0) {
        this.bloomProgress = 0;
        this.state = "bud";
        this.stateTime = 0;
      }
    }
  }
  
  /**
   * Calcula el desplazamiento actual de la onda
   * 
   * @param time Tiempo global para animaciones
   * @return Desplazamiento de onda
   */
  float getWaveOffset(float time) {
    return sin(time * 0.5 + this.wavePhase) * 0.5;
  }
}

