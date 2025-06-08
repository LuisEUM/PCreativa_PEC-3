/**
 * Clase PowerUp
 * 
 * Representa un power-up individual en el juego.
 * Aparece como una burbuja que contiene un beneficio específico.
 */
class PowerUp {
  Vector2D position;
  PowerUpType type;
  int amount;
  float size;
  float lifeTime;
  float maxLifeTime;
  float bobTimer;
  float bobAmplitude;
  float bobFrequency;
  float alpha;
  float bubbleRotation;
  
  /**
   * Constructor
   */
  PowerUp(float x, float y, PowerUpType type, int amount) {
    this.position = new Vector2D(x, y);
    this.type = type;
    this.amount = amount;
    this.size = 40;
    this.maxLifeTime = 15000; // 15 segundos en milisegundos
    this.lifeTime = maxLifeTime;
    this.bobTimer = 0;
    this.bobAmplitude = 3; // Reducido para movimiento más sutil
    this.bobFrequency = 0.002; // Reducido para movimiento más lento
    this.alpha = 255;
    this.bubbleRotation = random(TWO_PI);
  }
  
  /**
   * Actualiza el estado del power-up
   */
  void update(float deltaTime) {
    // Actualizar tiempo de vida (deltaTime ya está en milisegundos)
    lifeTime -= deltaTime;
    
    // Actualizar movimiento de flotación más sutil
    bobTimer += deltaTime * bobFrequency;
    position.y += sin(bobTimer) * bobAmplitude * (deltaTime / 1000.0);
    
    // Rotar burbuja más lentamente
    bubbleRotation += 0.0005 * deltaTime;
    
    // Fade out en últimos 4 segundos (4000 ms)
    if (lifeTime < 4000) {
      alpha = map(lifeTime, 0, 4000, 0, 255);
    }
  }
  
  /**
   * Verifica si el power-up ha expirado
   */
  boolean isExpired() {
    return lifeTime <= 0;
  }
  
  /**
   * Verifica colisión con un koi
   */
  boolean checkCollision(Koi koi) {
    float distance = Vector2D.distance(position, koi.position);
    return distance < (size + koi.length) * 0.5;
  }
  
  /**
   * Renderiza el power-up
   */
  void render() {
    pushStyle();
    
    // Configurar transparencia
    float currentAlpha = alpha;
    
    // Dibujar burbuja exterior
    noFill();
    stroke(200, 220, 255, currentAlpha * 0.7);
    strokeWeight(2);
    circle(position.x, position.y, size * 1.2);
    
    // Dibujar brillo de la burbuja
    pushMatrix();
    translate(position.x, position.y);
    rotate(bubbleRotation);
    
    noStroke();
    fill(255, currentAlpha * 0.3);
    ellipse(-size * 0.2, -size * 0.2, size * 0.3, size * 0.3);
    
    popMatrix();
    
    // Dibujar icono según tipo manualmente (sin IconRenderer por compatibilidad)
    float iconSize = size * 0.6;
    
    pushMatrix();
    translate(position.x, position.y);
    
    switch (type) {
      case ROCKS:
        // Dibujar icono de roca
        noStroke();
        fill(200, 200, 200, currentAlpha);
        
        // Forma de roca irregular
        beginShape();
        float[] angles = {0, 0.6, 1.4, 2.1, 3.5, 4.2, 5.0, 5.8};
        float[] radii = {0.9, 0.7, 1.0, 0.8, 0.9, 0.6, 0.8, 0.7};
        
        for (int i = 0; i < angles.length; i++) {
          float angle = angles[i];
          float radius = radii[i] * iconSize * 0.4;
          vertex(cos(angle) * radius, sin(angle) * radius);
        }
        endShape(CLOSE);
        break;
        
      case KOI:
        // Dibujar icono de pez
        noStroke();
        fill(255, 150, 150, currentAlpha);
        
        // Cuerpo principal del pez
        ellipse(0, 0, iconSize * 0.8, iconSize * 0.5);
        
        // Cola del pez
        beginShape();
        vertex(-iconSize * 0.4, 0);
        vertex(-iconSize * 0.7, -iconSize * 0.3);
        vertex(-iconSize * 0.7, iconSize * 0.3);
        endShape(CLOSE);
        
        // Ojo del pez
        fill(255, currentAlpha);
        ellipse(iconSize * 0.15, 0, iconSize * 0.15, iconSize * 0.15);
        fill(0, currentAlpha);
        ellipse(iconSize * 0.15, 0, iconSize * 0.08, iconSize * 0.08);
        break;
        
      case FOOD:
        // Dibujar icono de comida
        noStroke();
        fill(150, 255, 150, currentAlpha);
        
        float granuleSize = iconSize * 0.2;
        
        // Gránulo central más grande
        ellipse(0, 0, granuleSize * 1.5, granuleSize * 1.5);
        
        // Gránulos alrededor
        ellipse(-iconSize * 0.3, -iconSize * 0.2, granuleSize, granuleSize);
        ellipse(iconSize * 0.3, -iconSize * 0.1, granuleSize, granuleSize);
        ellipse(-iconSize * 0.1, iconSize * 0.3, granuleSize, granuleSize);
        ellipse(iconSize * 0.2, iconSize * 0.25, granuleSize, granuleSize);
        break;
    }
    
    popMatrix();
    
    // Dibujar cantidad
    textSize(14);
    fill(255, currentAlpha);
    textAlign(CENTER, CENTER);
    text("+" + amount, position.x, position.y + size * 0.4);
    
    popStyle();
  }
} 