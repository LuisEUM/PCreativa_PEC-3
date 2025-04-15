/**
 * Clase RippleManager
 * 
 * Gestiona las ondulaciones del agua en el estanque.
 * Maneja la creación, actualización y ciclo de vida de las ondulaciones.
 */
class RippleManager {
  ArrayList<Ripple> ripples = new ArrayList<Ripple>();
  
  /**
   * Crea una nueva ondulación en el agua
   * 
   * @param x Posición x del centro
   * @param y Posición y del centro
   * @param initialOpacity Opacidad inicial (0-1)
   * @param maxRadius Radio máximo antes de desaparecer
   */
  void createRipple(float x, float y, float initialOpacity, float maxRadius) {
    ripples.add(new Ripple(x, y, initialOpacity, maxRadius));
  }
  
  /**
   * Actualiza todas las ondulaciones en cada fotograma
   * 
   * @param deltaTime Tiempo transcurrido desde el último fotograma
   */
  void update(float deltaTime) {
    for (int i = ripples.size() - 1; i >= 0; i--) {
      Ripple ripple = ripples.get(i);
      
      ripple.update(deltaTime);
      
      // Elimina ondulaciones desvanecidas
      if (ripple.isFinished()) {
        ripples.remove(i);
      }
    }
  }
  
  /**
   * Obtiene todas las ondulaciones
   * 
   * @return ArrayList de ondulaciones
   */
  ArrayList<Ripple> getRipples() {
    return ripples;
  }
}

