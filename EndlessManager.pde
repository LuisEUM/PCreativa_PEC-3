/**
 * Clase EndlessManager
 * 
 * Gestor principal que coordino para todos los elementos del estanque de koi en el Modo Endless.
 * He creado una copia del WavesManager pero con UI diferente.
 * Implemento el patrón Facade para proporcionar una interfaz simplificada
 * al subsistema complejo de gestores y renderizadores.
 */
class EndlessManager {
  // Referencia al PApplet principal
  PApplet sketch;
  
  // Gestores
  KoiManager koiManager;
  PetalManager petalManager;
  RippleManager rippleManager;
  FoodManager foodManager;
  PlantManager plantManager;
  RockManager rockManager;
  EndlessUIManager uiManager;
  PowerUpManager powerUpManager;
  EnemyManager enemyManager;
  
  // Seguimiento de tiempo
  float lastTimestamp = 0;
  float time = 0;
  
  // Ciclo de tiempo del día
  int timeOfDay = 0; // 0: día, 1: atardecer, 2: noche, 3: amanecer
  float timeOfDayStartTime = 0; // Tiempo cuando empezó el periodo actual
  float timeOfDayDuration = 120000; // 2 minutos por período
  color[] pondColors = {
    ColorUtils.hexToColor("#90A1D9"),    // DIA
    ColorUtils.hexToColor("#F1A7B4"),    // ATARDECER 
    ColorUtils.hexToColor("#026874"),    // NOCHE
    ColorUtils.hexToColor("#BDB1D9")     // AMANECER
  };
  
  /**
   * Constructor
   * 
   * @param sketch Referencia al PApplet principal
   */
  ScoreManager scoreManager;
  
  EndlessManager(PApplet sketch, ScoreManager scoreManager) {
    this.sketch = sketch;
    this.scoreManager = scoreManager;
    
    // Inicializar tiempo del día
    this.timeOfDayStartTime = millis();
    
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
    koiManager.initialize(20); // Ahora inicializa los peces con las rocas ya establecidas
    
    // Inicializa petalManager con cantidades reducidas
    petalManager = new PetalManager(sketch.width, sketch.height, 15, 8);
    
    // Inicializa el gestor de UI para Endless
    uiManager = new EndlessUIManager(sketch, koiManager);
    koiManager.setUIManager(uiManager); // Establece la referencia al UIManager
    koiManager.setScoreManager(scoreManager); // Establece la referencia al ScoreManager
    
    // Inicializa el gestor de power-ups
    powerUpManager = new PowerUpManager(sketch.width, sketch.height, rockManager.getRocks());
    
    // Inicializa el gestor de enemigos
    enemyManager = new EnemyManager(sketch.width, sketch.height);
    enemyManager.setRocks(rockManager.getRocks()); // Establecer rocas para colisiones
  }
  
  /**
   * Actualiza todos los elementos del estanque
   */
  void update() {
    update(false); // Llamar al método con parámetro de pausa por defecto
  }
  
  /**
   * Actualiza todos los elementos del estanque con estado de pausa
   */
  void update(boolean isPaused) {
    // Si está pausado, no actualizar nada
    if (isPaused) {
      return;
    }
    
    // Calcula el tiempo delta para una animación suave
    float currentTime = millis();
    float deltaTime = currentTime - lastTimestamp;
    lastTimestamp = currentTime;
    time += deltaTime * 0.001; // Convierte a segundos
    
    // Actualiza todos los gestores
    rippleManager.update(deltaTime);
    foodManager.update(deltaTime);
    koiManager.update(deltaTime, isPaused);
    plantManager.update(deltaTime, time);
    
    // Actualiza pétalos y obtiene nuevas ondulaciones
    ArrayList<RippleInfo> newRipples = petalManager.update(deltaTime);
    
    // Crea ondulaciones generadas por pétalos
    for (RippleInfo ripple : newRipples) {
      rippleManager.createRipple(ripple.x, ripple.y, ripple.opacity, ripple.maxRadius);
    }
    
    // Actualiza la UI
    uiManager.update();
    
    // Actualiza el ciclo de tiempo del día (cada 2 minutos)
    float timeUpdateTime = millis();
    if (timeUpdateTime - timeOfDayStartTime >= timeOfDayDuration) {
      timeOfDay = (timeOfDay + 1) % 4; // Ciclar entre 0, 1, 2, 3
      timeOfDayStartTime = timeUpdateTime;
      println("🌅 Endless Mode - Cambio de tiempo a: " + 
        (timeOfDay == 0 ? "DIA" : 
         timeOfDay == 1 ? "ATARDECER" : 
         timeOfDay == 2 ? "NOCHE" : "AMANECER"));
    }
    
    // Actualiza power-ups y verifica colisiones
    powerUpManager.update(deltaTime);
    powerUpManager.checkCollisions(koiManager.getKois(), koiManager);
    
    // Actualiza enemigos
    enemyManager.update(deltaTime, koiManager.getKois(), "endless", foodManager.getParticles(), isPaused);
    
    // Actualiza el sistema de alimentación
    koiManager.updateFoodAttraction(foodManager.getParticles());
    koiManager.checkFoodConsumption(foodManager.getParticles(), deltaTime);
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
    
    // CAPA 5.3: Renderiza enemigos (entre peces y power-ups)
    enemyManager.render();
    
    // CAPA 5.5: Renderiza power-ups (entre peces y plantas)
    powerUpManager.render();
    
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
    
    // Renderiza alerta de enemigos si está activa
    if (enemyManager.isShowingEndlessAlert()) {
      uiManager.renderEnemyAlert(true, enemyManager.getEndlessAlertTimeRemaining());
    }
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
    
    if (mouseButton == LEFT) {
      // Clic izquierdo: Alimentar a los peces (si hay comida disponible)
      if (uiManager.useFood()) {
        // Solo crear ondas y efectos si se usó comida exitosamente
        rippleManager.createRipple(x, y, 0.7, 50);
        foodManager.createFoodParticles(x, y, 12);
        koiManager.attractToPoint(x, y, 200);
        
        // Atraer enemigos que estén en modo WANDERING
        enemyManager.attractToPoint(x, y, 250);
      }
    } else if (mouseButton == RIGHT) {
      // Clic derecho: Tirar rocas (si hay rocas disponibles)
      if (uiManager.useRock()) {
        // Solo crear ondas y efectos si se usó roca exitosamente
        rippleManager.createRipple(x, y, 0.7, 50);
        rippleManager.createRipple(x, y, 0.9, 70); // Ondulación más grande para rocas
        koiManager.repelFromPoint(x, y, 250.0f);
        
        // Repeler enemigos que estén en modo WANDERING
        enemyManager.repelFromPoint(x, y, 200);
        
        // Verificar colisiones directas con enemigos
        enemyManager.checkRockCollisions(x, y, 15.0f, uiManager, scoreManager);
      }
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
      
      // Cambiar el color según el estado de la comida
      if (particle.consumed) {
        // Comida consumida: blanco brillante
        sketch.fill(255, 255, 255, particle.opacity * 255);
      } else if (!particle.canBeConsumed()) {
        // Comida que aún no puede ser comida: un poco más tenue
        sketch.fill(particle.particleColor, particle.opacity * 128);
      } else {
        // Comida que puede ser comida: color normal
        sketch.fill(particle.particleColor, particle.opacity * 255);
      }
      
      float renderSize = particle.size * 2;
      
      // Efecto de pulsación para comida que puede ser comida
      if (particle.canBeConsumed() && !particle.consumed) {
        float pulsation = 1.0 + sin(time * 8) * 0.2; // Pulsación sutil
        renderSize *= pulsation;
      }
      
      sketch.ellipse(
        particle.position.x + particle.offset.x, 
        particle.position.y + particle.offset.y, 
        renderSize, 
        renderSize
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
    
    // Obtiene las dimensiones actuales teniendo en cuenta todas las animaciones
    float currentLength = koi.getCurrentAnimatedLength();
    float currentWidth = koi.getCurrentAnimatedWidth();
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
    
    // Obtiene el color del koi
    color koiC;
    if (koi.excited) {
      if (koi.koiColor.equals("#333333")) {
        koiC = color(80, 80, 80, 255 * currentOpacity); // Aclara los peces gris oscuro
      } else {
        koiC = ColorUtils.hexToColor(koi.koiColor);
        koiC = color(red(koiC), green(koiC), blue(koiC), 255 * currentOpacity);
      }
    } else {
      koiC = ColorUtils.hexToColor(koi.koiColor);
      koiC = color(red(koiC), green(koiC), blue(koiC), 255 * currentOpacity);
    }
    
    // Declaramos el color de la cola una sola vez fuera de los bloques condicionales
    color koiTailColor = ColorUtils.darkenColor(koiC, 20);
    
    // Dibuja la cola con el mismo color que el cuerpo pero un poco más oscuro
    // Usar un color más oscuro para la cola (20% más oscuro)
    sketch.noStroke();
    sketch.fill(koiTailColor);
    
    // Posición base para la cola (en la parte trasera del pez)
    float tailBaseX = -currentLength/2;
    
    // Offset del movimiento de la cola
    float tailOffsetY = tailWag * currentWidth;
    
    // Tamaño de los óvalos (ajustados para mejor apariencia)
    float ovalWidth = currentLength/2.5;
    float ovalHeight = currentWidth/1.8;
    
    // Ajustar posición más cerca del cuerpo
    float tailDistance = currentLength/6;
    
    // Primer óvalo de la cola (el más cercano al cuerpo)
    sketch.ellipse(tailBaseX - tailDistance, tailOffsetY * 0.3, ovalWidth, ovalHeight * 0.8);
    
    // Segundo óvalo de la cola (más alejado y más pequeño)
    sketch.ellipse(tailBaseX - tailDistance*1.8, tailOffsetY * 0.7, ovalWidth * 0.7, ovalHeight * 0.6);
    
    // Aleta dorsal (parte superior del pez)
    float finX = 0;
    float finY = -currentWidth/2 * 0.9;
    float finWidth = currentLength/5;
    float finHeight = currentWidth/4;
    
    sketch.pushMatrix();
    sketch.translate(finX, finY);
    
    // Dibujar la aleta
    sketch.ellipse(0, finHeight/2, finWidth, finHeight);
    sketch.popMatrix();
    
    // Dibuja el cuerpo exterior (30% más grande)
    sketch.noStroke();
    sketch.fill(koiC);
    sketch.ellipse(0, 0, currentLength * 1.3, currentWidth * 1.3);
    
    // Dibuja el cuerpo base del koi
    sketch.fill(koiC);
    sketch.ellipse(0, 0, currentLength, currentWidth);
    
    // Si hay manchas, las dibujamos directamente sobre el cuerpo
    if (koi.spots.size() > 0) {
      for (Spot spot : koi.spots) {
        // Calculamos la posición y tamaño de la mancha
        float spotX = (spot.x - 0.5) * currentLength;
        float spotY = (spot.y - 0.5) * currentWidth;
        float spotSize = (spot.size * currentWidth);
        
        // Aseguramos que la mancha esté dentro del cuerpo
        // Calculamos la distancia desde el centro del cuerpo
        float distFromCenter = sqrt(spotX * spotX + spotY * spotY);
        float maxAllowedDist = (currentLength / 2) * 0.7; // 80% del radio
        
        // Si la mancha está fuera del límite permitido, la ajustamos
        if (distFromCenter > maxAllowedDist) {
          float angle = atan2(spotY, spotX);
          spotX = cos(angle) * maxAllowedDist;
          spotY = sin(angle) * maxAllowedDist;
        }
        
        // Ajustamos el tamaño para evitar desbordamiento
        float maxSize = min(currentLength, currentWidth) * 1.8; // 180% del tamaño más pequeño
        spotSize = min(spotSize, maxSize);
        
        // Dibujamos la mancha con menor opacidad para que se vea el color base
        color spotC = ColorUtils.hexToColor(spot.spotColor);
        sketch.noStroke();
        // Reducimos la opacidad para que se mezcle con el color base
        sketch.fill(red(spotC), green(spotC), blue(spotC), 180 * currentOpacity);
        sketch.ellipse(spotX, spotY, spotSize, spotSize);
      }
    }
    
    // Dibuja los ojos del pez
    sketch.fill(0, 0, 0, 255 * currentOpacity); // Color negro para los ojos
    sketch.noStroke();
    
    // Posición de los ojos en la parte delantera del pez
    float eyeX = currentLength/2 * 0.85; // Posición X en el 70% del camino hacia el frente
    float eyeY = currentWidth/2 * 0.35; // Posición Y a 30% del centro hacia arriba/abajo
    float eyeWidth = currentWidth * 0.15; // Ancho del ojo (ovalado)
    float eyeHeight = currentWidth * 0.09; // Alto del ojo (ovalado)
    
    // Ojos ovalados ligeramente rotados hacia fuera
    // Ojo izquierdo
    sketch.pushMatrix();
    sketch.translate(eyeX, -eyeY);
    sketch.rotate(PI/4); // Rotar 45 grados
    sketch.ellipse(0, 0, eyeWidth, eyeHeight);
    sketch.popMatrix();
    
    // Ojo derecho
    sketch.pushMatrix();
    sketch.translate(eyeX, eyeY);
    sketch.rotate(-PI/4); // Rotar -45 grados (en sentido contrario)
    sketch.ellipse(0, 0, eyeWidth, eyeHeight);
    sketch.popMatrix();
    
    // Si el pez se está hundiendo, dibuja burbujas ocasionales
    if (koi.sinking) {
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
    // Renderiza la superficie del agua con un efecto semitransparente
    // según el tiempo del día
    color surfaceColor = pondColors[timeOfDay];
    
    // Aplica una ligera transparencia para que se vea más realista
    surfaceColor = color(
      red(surfaceColor), 
      green(surfaceColor), 
      blue(surfaceColor), 
      30
    );
    
    sketch.noStroke();
    sketch.fill(surfaceColor);
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
    // Sin instrucciones en modo Endless simplificado
  }
} 