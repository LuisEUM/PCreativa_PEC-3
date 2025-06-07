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
    this.maxLifeTime = 20000; // 20 segundos en milisegundos (no frames)
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
    
    // Dibujar icono según tipo
    fill(255, currentAlpha);
    textAlign(CENTER, CENTER);
    textSize(16);
    
    String icon = "";
    switch (type) {
      case ROCKS:
        icon = "■";
        fill(200, 200, 200, currentAlpha);
        break;
      case KOI:
        icon = "♦";
        fill(255, 150, 150, currentAlpha);
        break;
      case FOOD:
        icon = "◆";
        fill(150, 255, 150, currentAlpha);
        break;
    }
    
    text(icon, position.x, position.y - 8);
    
    // Dibujar cantidad
    textSize(14);
    fill(255, currentAlpha);
    text("+" + amount, position.x, position.y + 8);
    
    popStyle();
  }
} 