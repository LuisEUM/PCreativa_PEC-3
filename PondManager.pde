/**
 * Clase PondManager
 * 
 * Gestor principal que coordina todos los elementos del estanque de koi.
 * Implementa el patrón Facade para proporcionar una interfaz simplificada
 * al subsistema complejo de gestores y renderizadores.
 */
class PondManager {
  // Referencia al PApplet principal
  PApplet sketch;
  
  // Gestores
  KoiManager koiManager;
  PetalManager petalManager;
  RippleManager rippleManager;
  FoodManager foodManager;
  PlantManager plantManager;
  RockManager rockManager;
  UIManager uiManager;
  
  // Seguimiento de tiempo
  float lastTimestamp = 0;
  float time = 0;
  
  /**
   * Constructor
   * 
   * @param sketch Referencia al PApplet principal
   */
  PondManager(PApplet sketch) {
    this.sketch = sketch;
    
    // Inicializa gestores
    rippleManager = new RippleManager();
    foodManager = new FoodManager();
    plantManager = new PlantManager(sketch.width, sketch.height);
    
    // Inicializa rockManager después de plantManager para evitar colisiones
    rockManager = new RockManager(
      sketch.width, 
      sketch.height, 
      plantManager.getLeaves(), 
      plantManager.getFlowers()
    );
    
    // Modifica el orden de inicialización para que el KoiManager tenga las rocas
    // antes de inicializar los peces koi
    koiManager = new KoiManager(sketch.width, sketch.height, 0); // Inicializa sin peces
    koiManager.setRocks(rockManager.getRocks());
    koiManager.initialize(25); // Ahora inicializa los peces con las rocas ya establecidas
    
    // Inicializa petalManager con cantidades reducidas
    petalManager = new PetalManager(sketch.width, sketch.height, 15, 8);
    
    // Inicializa el gestor de UI
    uiManager = new UIManager(sketch, koiManager);
  }
  
  /**
   * Actualiza todos los elementos del estanque
   */
  void update() {
    // Calcula el tiempo delta para una animación suave
    float currentTime = millis();
    float deltaTime = currentTime - lastTimestamp;
    lastTimestamp = currentTime;
    time += deltaTime * 0.001; // Convierte a segundos
    
    // Actualiza todos los gestores
    rippleManager.update(deltaTime);
    foodManager.update(deltaTime);
    koiManager.update(deltaTime);
    plantManager.update(deltaTime, time);
    
    // Actualiza pétalos y obtiene nuevas ondulaciones
    ArrayList<RippleInfo> newRipples = petalManager.update(deltaTime);
    
    // Crea ondulaciones generadas por pétalos
    for (RippleInfo ripple : newRipples) {
      rippleManager.createRipple(ripple.x, ripple.y, ripple.opacity, ripple.maxRadius);
    }
    
    // Actualiza la UI
    uiManager.update();
  }
  
  /**
   * Renderiza todos los elementos del estanque
   */
  void render() {
    // CAPA 1: Agua profunda (fondo azul oscuro)
    renderDeepWater();
    
    // CAPA 2: Renderiza ondulaciones
    renderRipples();
    
    // CAPA 3: Renderiza partículas de comida
    renderFoodParticles();
    
    // CAPA 4: Renderiza rocas (en el fondo)
    renderRocks();
    
    // CAPA 5: Renderiza peces koi (entre rocas y plantas)
    renderKoiFish();
    
    // CAPA 6: Renderiza hojas de loto (sobre los peces)
    renderLotusLeaves();
    
    // CAPA 7: Renderiza superficie del agua
    renderWaterSurface();
    
    // CAPA 8: Renderiza flores de loto (sobre la superficie del agua)
    renderLotusFlowers();
    
    // CAPA 9: Renderiza pétalos de flor de cerezo (capa superior)
    renderPetals();
    
    // Renderiza texto de interfaz
    renderUI();
    
    // Renderiza los elementos de la UI
    uiManager.render();
  }
  
  /**
   * Maneja el evento de clic del ratón
   * 
   * @param x Posición x del ratón
   * @param y Posición y del ratón
   */
  void handleClick(float x, float y) {
    // Primero comprueba si la UI consume el clic
    if (uiManager.handleClick(x, y)) {
      return; // Si la UI consumió el clic, no seguimos procesándolo
    }
    
    // Si la UI no consumió el clic, lo procesamos normalmente
    
    // Crea una ondulación más grande en el punto de clic
    rippleManager.createRipple(x, y, 0.7, 50);
    
    // Crea partículas de comida
    foodManager.createFoodParticles(x, y, 12);
    
    // Atrae a los peces cercanos
    koiManager.attractToPoint(x, y, 200);
  }
  
  // Métodos de renderizado para cada capa
  
  void renderDeepWater() {
    sketch.background(25, 118, 210); // Azul más profundo para agua profunda
  }
  
  void renderRipples() {
    ArrayList<Ripple> ripples = rippleManager.getRipples();
    for (Ripple ripple : ripples) {
      sketch.noFill();
      sketch.stroke(255, 255, 255, ripple.opacity * 255);
      sketch.strokeWeight(1);
      sketch.ellipse(ripple.position.x, ripple.position.y, ripple.radius * 2, ripple.radius * 2);
    }
  }
  
  void renderFoodParticles() {
    ArrayList<FoodParticle> particles = foodManager.getParticles();
    for (FoodParticle particle : particles) {
      sketch.noStroke();
      sketch.fill(particle.particleColor, particle.opacity * 255);
      sketch.ellipse(
        particle.position.x + particle.offset.x, 
        particle.position.y + particle.offset.y, 
        particle.size * 2, 
        particle.size * 2
      );
    }
  }
  
  void renderRocks() {
    ArrayList<Rock> rocks = rockManager.getRocks();
    for (Rock rock : rocks) {
      renderRock(rock);
    }
  }
  
  void renderRock(Rock rock) {
    sketch.pushMatrix();
    sketch.translate(rock.position.x, rock.position.y);
    sketch.rotate(rock.rotation);
    
    // Dibuja primero la sombra
    sketch.pushMatrix();
    sketch.translate(rock.shadowOffset, rock.shadowOffset);
    sketch.noStroke();
    sketch.fill(0, 0, 0, 76); // Negro con 30% de opacidad
    drawRockShape(rock, true);
    sketch.popMatrix();
    
    // Dibuja la roca
    drawRockShape(rock, false);
    
    sketch.popMatrix();
  }
  
  void drawRockShape(Rock rock, boolean isShadow) {
    if (isShadow) {
      sketch.fill(0, 0, 0, 76); // Negro con 30% de opacidad
    } else {
      // Usa el color de la roca
      sketch.fill(ColorUtils.hexToColor(rock.rockColor));
    }
    
    // Usa una forma de octágono simple para las rocas
    sketch.beginShape();
    int points = 8;
    float angleStep = TWO_PI / points;
    
    for (int i = 0; i < points; i++) {
      float angle = i * angleStep;
      float x = cos(angle) * rock.size;
      float y = sin(angle) * rock.size;
      sketch.vertex(x, y);
    }
    
    sketch.endShape(CLOSE);
  }
  
  void renderKoiFish() {
    ArrayList<Koi> kois = koiManager.getKois();
    for (Koi koi : kois) {
      renderKoi(koi);
    }
  }
  
  void renderKoi(Koi koi) {
    // Calcula el movimiento de la cola - más rápido cuando está excitado
    float tailFrequency = koi.excited ? koi.tailFrequency * 2 : koi.tailFrequency;
    float tailWag = sin(time * 5 * tailFrequency) * koi.tailAmplitude;
    
    sketch.pushMatrix();
    sketch.translate(koi.position.x, koi.position.y);
    sketch.rotate(koi.angle);
    
    // Dibuja primero la sombra
    sketch.pushMatrix();
    sketch.translate(koi.shadowOffset, koi.shadowOffset);
    sketch.noStroke();
    sketch.fill(0, 0, 0, 51); // Negro con 20% de opacidad
    sketch.ellipse(0, 0, koi.length, koi.width);
    sketch.popMatrix();
    
    // Dibuja el cuerpo del koi
    sketch.noStroke();
    
    // Si está excitado, añade un ligero efecto de brillo
    if (koi.excited) {
      if (koi.koiColor.equals("#333333")) {
        sketch.fill(80, 80, 80); // Aclara los peces gris oscuro
      } else {
        sketch.fill(ColorUtils.hexToColor(koi.koiColor));
      }
    } else {
      sketch.fill(ColorUtils.hexToColor(koi.koiColor));
    }
    
    sketch.ellipse(0, 0, koi.length, koi.width);
    
    // Dibuja la cola
    sketch.beginShape();
    sketch.vertex(-koi.length/2, 0);
    sketch.quadraticVertex(
      -koi.length/2 - koi.length/4, tailWag * koi.width,
      -koi.length/2 - koi.length/3, tailWag * koi.width * 1.5
    );
    sketch.quadraticVertex(
      -koi.length/2 - koi.length/4, tailWag * koi.width,
      -koi.length/2, 0
    );
    sketch.endShape(CLOSE);
    
    // Dibuja las manchas
    for (Spot spot : koi.spots) {
      float spotX = -koi.length/4 + (spot.x * koi.length/2);
      float spotY = -koi.width/4 + (spot.y * koi.width/2);
      float spotSize = (spot.size * koi.width/2);
      
      sketch.fill(ColorUtils.hexToColor(spot.spotColor));
      sketch.ellipse(spotX, spotY, spotSize, spotSize);
    }
    
    // Si está excitado, dibuja pequeñas burbujas cerca de la boca
    if (koi.excited && random(1) < 0.2) {
      float bubbleX = koi.length/2 + random(5);
      float bubbleY = (random(1) - 0.5) * 5;
      
      sketch.fill(255, 255, 255, 153); // Blanco con 60% de opacidad
      sketch.ellipse(bubbleX, bubbleY, random(1.5) + 0.5, random(1.5) + 0.5);
    }
    
    sketch.popMatrix();
  }
  
  void renderLotusLeaves() {
    ArrayList<LotusLeaf> leaves = plantManager.getLeaves();
    for (LotusLeaf leaf : leaves) {
      renderLotusLeaf(leaf);
    }
  }
  
  void renderLotusLeaf(LotusLeaf leaf) {
    // Aplica un suave movimiento ondulante
    float waveOffset = leaf.getWaveOffset(time);
    
    sketch.pushMatrix();
    sketch.translate(leaf.position.x, leaf.position.y);
    sketch.rotate(leaf.rotation + waveOffset * 0.05);
    
    // Dibuja primero la sombra
    sketch.pushMatrix();
    sketch.translate(leaf.shadowOffset, leaf.shadowOffset);
    sketch.noStroke();
    sketch.fill(0, 0, 0, 76); // Negro con 30% de opacidad
    drawLeafShape(leaf.size, leaf.variation);
    sketch.popMatrix();
    
    // Dibuja la hoja con color verde brillante
    sketch.noStroke();
    sketch.fill(34, 180, 34, leaf.opacity * 255); // Verde brillante
    drawLeafShape(leaf.size, leaf.variation);
    
    // Dibuja venas muy sutiles
    sketch.stroke(255, 255, 255, 25); // Blanco con 10% de opacidad
    sketch.strokeWeight(0.5);
    
    int veins = 8;
    for (int i = 0; i < veins; i++) {
      float angle = (TWO_PI / veins) * i;
      sketch.line(0, 0, cos(angle) * leaf.size * 0.9, sin(angle) * leaf.size * 0.9);
    }
    
    sketch.popMatrix();
  }
  
  void drawLeafShape(float size, float variation) {
    sketch.beginShape();
    
    // Dibuja un círculo casi completo con una pequeña muesca
    int segments = 36;
    for (int i = 0; i < segments; i++) {
      float angle = map(i, 0, segments, 0, TWO_PI * 0.9);
      float x = cos(angle) * size;
      float y = sin(angle) * size;
      sketch.vertex(x, y);
    }
    
    // Añade una pequeña muesca para hacer la hoja más realista
    sketch.quadraticVertex(size * 0.5, -size * 0.2 * variation, 0, 0);
    
    sketch.endShape(CLOSE);
  }
  
  void renderWaterSurface() {
    sketch.noStroke();
    sketch.fill(144, 202, 249, 25); // Azul claro con menor opacidad
    sketch.rect(0, 0, sketch.width, sketch.height);
  }
  
  void renderLotusFlowers() {
    ArrayList<LotusFlower> flowers = plantManager.getFlowers();
    for (LotusFlower flower : flowers) {
      renderLotusFlower(flower);
    }
  }
  
  void renderLotusFlower(LotusFlower flower) {
    // Aplica un suave movimiento ondulante
    float waveOffset = flower.getWaveOffset(time);
    
    sketch.pushMatrix();
    sketch.translate(flower.position.x, flower.position.y);
    sketch.rotate(flower.rotation + waveOffset * 0.05);
    
    // Dibuja primero la sombra
    sketch.pushMatrix();
    sketch.translate(flower.shadowOffset, flower.shadowOffset);
    sketch.noStroke();
    sketch.fill(0, 0, 0, 76); // Negro con 30% de opacidad
    sketch.ellipse(0, 0, flower.size * flower.bloomProgress * 2, flower.size * flower.bloomProgress * 2);
    sketch.popMatrix();
    
    // Calcula el factor de floración basado en el estado
    float bloomFactor = flower.bloomProgress;
    
    // Dibuja el centro de la flor
    sketch.noStroke();
    sketch.fill(255, 235, 59); // Amarillo para el centro
    sketch.ellipse(0, 0, flower.size * 0.6, flower.size * 0.6);
    
    // Dibuja los pétalos
    int petalCount = flower.petalCount;
    color baseColor = ColorUtils.hexToColor(flower.flowerColor);
    
    for (int i = 0; i < petalCount; i++) {
      float angle = (TWO_PI / petalCount) * i;
      float petalLength = flower.size * bloomFactor;
      
      sketch.pushMatrix();
      sketch.rotate(angle);
      
      // Dibuja la forma del pétalo
      sketch.noStroke();
      sketch.fill(baseColor);
      sketch.beginShape();
      sketch.vertex(0, 0);
      sketch.quadraticVertex(petalLength * 0.5, petalLength * 0.3, petalLength, 0);
      sketch.quadraticVertex(petalLength * 0.5, -petalLength * 0.3, 0, 0);
      sketch.endShape(CLOSE);
      
      sketch.popMatrix();
    }
    
    sketch.popMatrix();
  }
  
  void renderPetals() {
    ArrayList<Petal> petals = petalManager.getPetals();
    for (Petal petal : petals) {
      renderPetal(petal);
    }
  }
  
  void renderPetal(Petal petal) {
    sketch.pushMatrix();
    sketch.translate(petal.position.x, petal.position.y);
    sketch.rotate(petal.rotation);
    
    // Establece la opacidad basada en el estado de la animación
    sketch.noStroke();
    sketch.fill(255, 183, 197, petal.opacity * 255); // Rosa claro
    
    // Calcula el tamaño actual basado en el estado de la animación
    float currentSize = petal.getCurrentSize();
    
    // Dibuja el pétalo como un pequeño óvalo
    sketch.ellipse(0, 0, currentSize * 2, currentSize * 3);
    
    sketch.popMatrix();
  }
  
  void renderUI() {
    sketch.textAlign(RIGHT, BOTTOM);
    sketch.textSize(12);
    sketch.fill(0, 0, 0, 150);
    sketch.noStroke();
    sketch.rect(sketch.width - 210, sketch.height - 35, 200, 25, 5);
    sketch.fill(255);
    sketch.text("Haz clic para alimentar a los peces", sketch.width - 20, sketch.height - 17);
  }
}

