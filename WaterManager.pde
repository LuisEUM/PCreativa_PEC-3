/**
 * KOI SURVIVAL - WaterManager
 * 
 * Gestor de efectos de agua como ondas y salpicaduras.
 * Maneja la simulación de efectos visuales en el agua del estanque.
 */

class WaterManager {
  RippleManager rippleManager;
  ArrayList<Splash> splashes;
  
  /**
   * Constructor
   */
  WaterManager() {
    rippleManager = new RippleManager();
    splashes = new ArrayList<Splash>();
  }
  
  /**
   * Actualiza todos los efectos de agua
   */
  void update(float deltaTime) {
    // Actualizar ondas con RippleManager
    rippleManager.update(deltaTime);
    
    // Actualizar y limpiar salpicaduras
    for (int i = splashes.size() - 1; i >= 0; i--) {
      Splash splash = splashes.get(i);
      splash.update();
      if (splash.isDead()) {
        splashes.remove(i);
      }
    }
  }
  
  /**
   * Renderiza todos los efectos de agua
   */
  void render() {
    // Renderizar ondas con RippleManager
    ArrayList<Ripple> ripples = rippleManager.getRipples();
    for (Ripple ripple : ripples) {
      noFill();
      stroke(255, 255, 255, ripple.opacity * 255);
      strokeWeight(1);
      ellipse(ripple.position.x, ripple.position.y, ripple.radius * 2, ripple.radius * 2);
    }
    
    // Renderizar salpicaduras
    for (Splash splash : splashes) {
      splash.render();
    }
  }
  
  /**
   * Crea una nueva onda en la posición especificada
   */
  void createRipple(float x, float y) {
    rippleManager.createRipple(x, y, 0.5, 50);
  }
  
  /**
   * Crea una nueva salpicadura en la posición especificada
   */
  void createSplash(float x, float y) {
    splashes.add(new Splash(x, y));
  }
}



/**
 * Clase para efecto de salpicadura en el agua
 */
class Splash {
  float x, y;              // Posición
  ArrayList<Particle> particles;
  float lifespan;
  
  Splash(float x, float y) {
    this.x = x;
    this.y = y;
    this.lifespan = 255;
    
    // Crear partículas
    particles = new ArrayList<Particle>();
    for (int i = 0; i < 8; i++) {
      float angle = map(i, 0, 8, 0, TWO_PI);
      particles.add(new Particle(x, y, angle));
    }
  }
  
  void update() {
    lifespan -= 5;
    for (Particle p : particles) {
      p.update();
    }
  }
  
  void render() {
    for (Particle p : particles) {
      p.render(lifespan);
    }
  }
  
  boolean isDead() {
    return lifespan <= 0;
  }
}

/**
 * Clase para partículas de salpicadura
 */
class Particle {
  PVector position;
  PVector velocity;
  
  Particle(float x, float y, float angle) {
    position = new PVector(x, y);
    velocity = PVector.fromAngle(angle);
    velocity.mult(random(2, 4));
  }
  
  void update() {
    velocity.mult(0.95);  // Fricción
    position.add(velocity);
  }
  
  void render(float alpha) {
    noStroke();
    fill(255, alpha);
    ellipse(position.x, position.y, 4, 4);
  }
} 