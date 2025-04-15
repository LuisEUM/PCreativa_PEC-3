/**
 * Clase FoodManager
 * 
 * Gestiona las partículas de comida en el estanque.
 * Maneja la creación, actualización y ciclo de vida de las partículas de comida.
 */
class FoodManager {
  ArrayList<FoodParticle> particles = new ArrayList<FoodParticle>();
  
  /**
   * Crea un grupo de partículas de comida
   * 
   * @param x Posición central x
   * @param y Posición central y
   * @param count Número de partículas a crear
   */
  void createFoodParticles(float x, float y, int count) {
    for (int i = 0; i < count; i++) {
      particles.add(new FoodParticle(x, y));
    }
  }
  
  /**
   * Actualiza todas las partículas de comida en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    for (int i = particles.size() - 1; i >= 0; i--) {
      FoodParticle particle = particles.get(i);
      
      particle.update(deltaTime);
      
      // Elimina las partículas muertas
      if (particle.isFinished()) {
        particles.remove(i);
      }
    }
  }
  
  /**
   * Obtiene todas las partículas de comida
   * 
   * @return ArrayList de partículas de comida
   */
  ArrayList<FoodParticle> getParticles() {
    return particles;
  }
}

