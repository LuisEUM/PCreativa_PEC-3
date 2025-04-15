/**
 * Clase PetalManager
 * 
 * Gestiona los pétalos de flor de cerezo flotando en el estanque.
 * Maneja la creación, actualización y ciclo de vida de los pétalos.
 */
class PetalManager {
  ArrayList<Petal> petals = new ArrayList<Petal>();
  float canvasWidth;
  float canvasHeight;
  int petalCount;
  int maxActivePetals;
  float spawnTimer = 0;
  
  /**
   * Constructor
   * 
   * @param canvasWidth Ancho del lienzo
   * @param canvasHeight Alto del lienzo
   * @param petalCount Número máximo de pétalos
   * @param maxActivePetals Número máximo de pétalos activos simultáneamente
   */
  PetalManager(float canvasWidth, float canvasHeight, int petalCount, int maxActivePetals) {
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.petalCount = petalCount;
    this.maxActivePetals = maxActivePetals;
    initialize();
  }
  
  /**
   * Inicializa algunos pétalos como ya activos
   */
  void initialize() {
    // Inicializa algunos pétalos como ya activos (menos que antes)
    int initialPetals = floor(this.maxActivePetals * 0.7); // Solo el 70% del máximo al inicio
    for (int i = 0; i < initialPetals; i++) {
      Petal petal = createPetal();
      petal.state = "active";
      petal.animationProgress = 1;
      petal.scaleFactor = 1; // Ya está en tamaño normal
      petal.rippleCreated = true; // No es necesaria la ondulación de entrada
      petals.add(petal);
    }
  }
  
  /**
   * Crea un nuevo pétalo con propiedades aleatorias
   * 
   * @return Nuevo objeto Petal
   */
  Petal createPetal() {
    // Posición aleatoria en cualquier parte del lienzo
    float x = RandomUtils.randomFloat(0, canvasWidth);
    float y = RandomUtils.randomFloat(0, canvasHeight);
    
    return new Petal(x, y);
  }
  
  /**
   * Actualiza todos los pétalos en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   * @return ArrayList de nuevas ondulaciones a crear
   */
  ArrayList<RippleInfo> update(float deltaTime) {
    ArrayList<RippleInfo> newRipples = new ArrayList<RippleInfo>();
    
    // Genera nuevos pétalos ocasionalmente, pero con menos frecuencia
    spawnTimer -= deltaTime;
    if (spawnTimer <= 0 && petals.size() < petalCount) {
      petals.add(createPetal());
      // Más tiempo entre apariciones
      spawnTimer = RandomUtils.randomFloat(2000, 4000);
    }
    
    for (int i = petals.size() - 1; i >= 0; i--) {
      Petal petal = petals.get(i);
      
      // Estado anterior para detectar cambios
      String prevState = petal.state;
      boolean wasRippleCreated = petal.rippleCreated;
      
      // Actualiza el pétalo
      petal.update(deltaTime);
      
      // Comprueba si necesitamos crear una ondulación
      if (petal.state.equals("active") && prevState.equals("appearing") && !wasRippleCreated) {
        newRipples.add(new RippleInfo(petal.position.x, petal.position.y, 0.4, 15));
        petal.rippleCreated = true;
      }
      
      // Comprueba si el pétalo ha comenzado a hundirse
      if (petal.state.equals("sinking") && prevState.equals("active")) {
        newRipples.add(new RippleInfo(petal.position.x, petal.position.y, 0.3, 15));
      }
      
      // Reemplaza los pétalos completamente hundidos
      if (petal.shouldReset()) {
        petals.set(i, createPetal());
      }
    }
    
    return newRipples;
  }
  
  /**
   * Obtiene todos los pétalos
   * 
   * @return ArrayList de pétalos
   */
  ArrayList<Petal> getPetals() {
    return petals;
  }
}

/**
 * Clase RippleInfo
 * 
 * Clase de datos simple para almacenar información sobre ondulaciones a crear
 */
class RippleInfo {
  float x;
  float y;
  float opacity;
  float maxRadius;
  
  RippleInfo(float x, float y, float opacity, float maxRadius) {
    this.x = x;
    this.y = y;
    this.opacity = opacity;
    this.maxRadius = maxRadius;
  }
}

