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
  
  // Ciclo de tiempo del día
  int timeOfDay = 0; // 0: día, 1: atardecer, 2: noche, 3: amanecer
  color[] pondColors = {
    color(25, 118, 210),    // Azul día
    color(245, 164, 52),    // Naranja atardecer
    color(10, 30, 80),      // Azul oscuro noche
    color(70, 150, 230)     // Azul claro amanecer
  };
  Button timeButton;
  
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
    
    // Inicializa el botón de tiempo (a la izquierda del botón de añadir)
    timeButton = new Button(sketch.width - 100, 10, 40, 40, "");
    updateTimeButtonColor();
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
    
    // Renderiza el botón de tiempo
    renderTimeButton();
  }
  
  /**
   * Maneja el evento de clic del ratón
   * 
   * @param x Posición x del ratón
   * @param y Posición y del ratón
   */
  void handleClick(float x, float y) {
    // Comprobar si se hizo clic en el botón de tiempo
    if (timeButton.isClicked(x, y)) {
      // Cambiar al siguiente estado de tiempo
      timeOfDay = (timeOfDay + 1) % 4;
      updateTimeButtonColor();
      return;
    }
    
    // Primero comprueba si la UI consume el clic
    if (uiManager.handleClick(x, y)) {
      return; // Si la UI consumió el clic, no seguimos procesándolo
    }
    
    // Si la UI no consumió el clic, lo procesamos normalmente
    
    // Crea una ondulación más grande en el punto de clic
    rippleManager.createRipple(x, y, 0.7, 50);
    
    if (mouseButton == LEFT) {
      // Clic izquierdo: Alimentar a los peces
      // Crea partículas de comida
      foodManager.createFoodParticles(x, y, 12);
      
      // Atrae a los peces cercanos
      koiManager.attractToPoint(x, y, 200);
    } else if (mouseButton == RIGHT) {
      // Clic derecho: Tirar rocas
      // Crea un efecto visual de una piedra cayendo
      rippleManager.createRipple(x, y, 0.9, 70); // Ondulación más grande
      
      // Repele a los peces cercanos
      koiManager.repelFromPoint(x, y, 250.0f);
    }
  }
  
  /**
   * Actualiza el color del botón de tiempo según el estado actual
   */
  void updateTimeButtonColor() {
    switch(timeOfDay) {
      case 0: // Día - Amarillo
        timeButton.buttonColor = ColorUtils.hexToColor("#FFEB3B");
        timeButton.hoverColor = ColorUtils.hexToColor("#FDD835");
        break;
      case 1: // Atardecer - Naranja
        timeButton.buttonColor = ColorUtils.hexToColor("#FF9800");
        timeButton.hoverColor = ColorUtils.hexToColor("#F57C00");
        break;
      case 2: // Noche - Gris
        timeButton.buttonColor = ColorUtils.hexToColor("#9E9E9E");
        timeButton.hoverColor = ColorUtils.hexToColor("#757575");
        break;
      case 3: // Amanecer - Azul claro
        timeButton.buttonColor = ColorUtils.hexToColor("#81D4FA");
        timeButton.hoverColor = ColorUtils.hexToColor("#4FC3F7");
        break;
    }
  }
  
  // Métodos de renderizado para cada capa
  
  void renderDeepWater() {
    sketch.background(pondColors[timeOfDay]); // Color del estanque según el tiempo del día
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
    
    // Obtiene las dimensiones actuales teniendo en cuenta la animación de hundimiento
    float currentLength = koi.getCurrentLength();
    float currentWidth = koi.getCurrentWidth();
    float currentOpacity = koi.sinking ? koi.opacity : 1.0;
    
    // Dibuja primero la sombra (no dibuja sombra si se está hundiendo)
    if (!koi.sinking) {
      sketch.pushMatrix();
      sketch.translate(koi.shadowOffset, koi.shadowOffset);
      sketch.noStroke();
      sketch.fill(0, 0, 0, 51 * currentOpacity); // Negro con 20% de opacidad
      sketch.ellipse(0, 0, currentLength, currentWidth);
      sketch.popMatrix();
    }
    
    // Dibuja el cuerpo del koi
    sketch.noStroke();
    
    // Si está excitado, añade un ligero efecto de brillo
    if (koi.excited) {
      if (koi.koiColor.equals("#333333")) {
        sketch.fill(80, 80, 80, 255 * currentOpacity); // Aclara los peces gris oscuro
      } else {
        color koiC = ColorUtils.hexToColor(koi.koiColor);
        sketch.fill(red(koiC), green(koiC), blue(koiC), 255 * currentOpacity);
      }
    } else {
      color koiC = ColorUtils.hexToColor(koi.koiColor);
      sketch.fill(red(koiC), green(koiC), blue(koiC), 255 * currentOpacity);
    }
    
    sketch.ellipse(0, 0, currentLength, currentWidth);
    
    // Dibuja la cola (solo si no está hundiéndose o al principio de la animación)
    if (!koi.sinking || koi.sinkingProgress < 0.5) {
      sketch.beginShape();
      sketch.vertex(-currentLength/2, 0);
      sketch.quadraticVertex(
        -currentLength/2 - currentLength/4, tailWag * currentWidth,
        -currentLength/2 - currentLength/3, tailWag * currentWidth * 1.5
      );
      sketch.quadraticVertex(
        -currentLength/2 - currentLength/4, tailWag * currentWidth,
        -currentLength/2, 0
      );
      sketch.endShape(CLOSE);
    }
    
    // Dibuja las manchas
    for (Spot spot : koi.spots) {
      float spotX = -currentLength/4 + (spot.x * currentLength/2);
      float spotY = -currentWidth/4 + (spot.y * currentWidth/2);
      float spotSize = (spot.size * currentWidth/2);
      
      color spotC = ColorUtils.hexToColor(spot.spotColor);
      sketch.fill(red(spotC), green(spotC), blue(spotC), 255 * currentOpacity);
      sketch.ellipse(spotX, spotY, spotSize, spotSize);
    }
    
    // Dibuja un efecto de ondulación cuando el pez se está hundiendo
    if (koi.sinking) {
      // Calculamos el número de ondas basado en el progreso del hundimiento
      int numRipples = 3;
      
      for (int i = 0; i < numRipples; i++) {
        // Cada onda tiene un tamaño y opacidad diferente
        float progress = koi.sinkingProgress + (i * 0.15);
        
        // Aseguramos que solo dibujamos ondas que están en fase visible (0-1)
        if (progress > 0 && progress < 1.0) {
          // El tamaño aumenta con el tiempo
          float rippleSize = currentLength * (1.0 + progress * 2.0);
          
          // La opacidad sigue una curva que primero aumenta y luego disminuye
          float rippleOpacity;
          if (progress < 0.3) {
            // Fase inicial: aumenta la opacidad
            rippleOpacity = 100 * (progress / 0.3);
          } else {
            // Fase final: disminuye la opacidad
            rippleOpacity = 100 * (1.0 - ((progress - 0.3) / 0.7));
          }
          
          // Aplicamos la opacidad del pez a la onda
          rippleOpacity *= koi.opacity * 0.8;
          
          // Dibujamos la onda
          sketch.noFill();
          sketch.stroke(255, 255, 255, rippleOpacity);
          sketch.strokeWeight(1.5 - progress); // Línea más gruesa al principio
          sketch.ellipse(0, 0, rippleSize, rippleSize);
        }
      }
      
      // Efecto de burbujas cuando el pez se está hundiendo
      if (random(1) < 0.2 * koi.sinkingProgress) {
        float bubbleX = random(-currentLength/2, currentLength/2);
        float bubbleY = random(-currentWidth/2, currentWidth/2);
        float bubbleSize = random(1, 3);
        
        sketch.fill(255, 255, 255, 150 * koi.opacity);
        sketch.noStroke();
        sketch.ellipse(bubbleX, bubbleY, bubbleSize, bubbleSize);
      }
    }
    // Si está excitado, dibuja pequeñas burbujas cerca de la boca
    else if (koi.excited && random(1) < 0.2) {
      float bubbleX = currentLength/2 + random(5);
      float bubbleY = (random(1) - 0.5) * 5;
      
      sketch.fill(255, 255, 255, 153 * currentOpacity); // Blanco con 60% de opacidad
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
    sketch.rect(sketch.width - 425, sketch.height - 35, 415, 25, 5);
    sketch.fill(255);
    sketch.text("Clic izquierdo: Alimentar | Clic derecho: Tirar rocas (pueden golpear a los peces)", sketch.width - 20, sketch.height - 17);
  }
  
  /**
   * Renderiza el botón de tiempo
   */
  void renderTimeButton() {
    Button btn = timeButton;
    
    // Actualizar el estado del botón
    btn.update(sketch.mouseX, sketch.mouseY);
    
    // Dibuja el fondo del botón
    sketch.noStroke();
    sketch.fill(btn.isHovered ? btn.hoverColor : btn.buttonColor);
    
    // Dibujar medio círculo o círculo completo según el estado
    if (timeOfDay == 1) { // Atardecer - Medio círculo derecho
      sketch.arc(btn.position.x + btn.width/2, btn.position.y + btn.height/2, 
                btn.width, btn.height, -HALF_PI, HALF_PI, sketch.PIE);
    } else if (timeOfDay == 3) { // Amanecer - Medio círculo izquierdo
      sketch.arc(btn.position.x + btn.width/2, btn.position.y + btn.height/2, 
                btn.width, btn.height, HALF_PI, PI + HALF_PI, sketch.PIE);
    } else { // Día o noche - Círculo completo
      sketch.ellipse(btn.position.x + btn.width/2, btn.position.y + btn.height/2, 
                    btn.width, btn.height);
    }
  }
}

