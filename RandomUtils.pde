/**
 * Clase RandomUtils
 * 
 * Proporciona métodos estáticos para generar valores aleatorios de diferentes tipos.
 * Centraliza la generación de aleatoriedad para facilitar pruebas y modificaciones.
 */
static class RandomUtils {
  // Instancia estática de Random para generar números aleatorios
  private static java.util.Random rng = new java.util.Random();
  
  /**
   * Genera un número decimal aleatorio en un rango
   * 
   * @param min Valor mínimo (inclusive)
   * @param max Valor máximo (exclusive)
   * @return Número decimal aleatorio
   */
  static float randomFloat(float min, float max) {
    return min + rng.nextFloat() * (max - min);
  }
  
  /**
   * Genera un número entero aleatorio en un rango
   * 
   * @param min Valor mínimo (inclusive)
   * @param max Valor máximo (inclusive)
   * @return Entero aleatorio
   */
  static int randomInt(int min, int max) {
    return min + rng.nextInt((max - min) + 1);
  }
  
  /**
   * Genera un booleano aleatorio con probabilidad ajustable
   * 
   * @param probability Probabilidad de obtener true (0-1)
   * @return Booleano aleatorio
   */
  static boolean randomBool(float probability) {
    return rng.nextFloat() < probability;
  }
  
  /**
   * Selecciona un elemento aleatorio de un array
   * 
   * @param array Array de elementos
   * @return Elemento aleatorio del array
   */
  static Object randomItem(Object[] array) {
    return array[rng.nextInt(array.length)];
  }
  
  /**
   * Genera un ángulo aleatorio en radianes (0-2π)
   * 
   * @return Ángulo aleatorio en radianes
   */
  static float randomAngle() {
    return rng.nextFloat() * TWO_PI;
  }
  
  /**
   * Genera un color aleatorio
   * 
   * @return Color aleatorio
   */
  static color randomColor() {
    return ColorUtils.parseColor(
      rng.nextInt(256), 
      rng.nextInt(256), 
      rng.nextInt(256)
    );
  }
}
