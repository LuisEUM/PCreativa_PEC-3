/**
 * Clase ColorUtils
 * 
 * Funciones de utilidad para manejar colores en Processing
 */
static class ColorUtils {
  /**
   * Convierte una cadena de color hexadecimal a color de Processing
   * 
   * @param hexColor Cadena de color hexadecimal (p.ej., "#ff0000")
   * @return Color de Processing
   */
  static color hexToColor(String hexColor) {
    // Elimina # si está presente
    if (hexColor.startsWith("#")) {
      hexColor = hexColor.substring(1);
    }
    
    // Analiza los componentes RGB
    int r = unhex(hexColor.substring(0, 2));
    int g = unhex(hexColor.substring(2, 4));
    int b = unhex(hexColor.substring(4, 6));
    
    return parseColor(r, g, b);
  }
  
  /**
   * Crea un color con transparencia
   * 
   * @param hexColor Cadena de color hexadecimal
   * @param alpha Valor alpha (0-255)
   * @return Color de Processing con transparencia
   */
  static color hexToColorAlpha(String hexColor, float alpha) {
    color c = hexToColor(hexColor);
    return parseColor(getRed(c), getGreen(c), getBlue(c), int(alpha));
  }
  
  /**
   * Aclara un color por un porcentaje
   * 
   * @param c Color a aclarar
   * @param percent Porcentaje a aclarar (0-100)
   * @return Color aclarado
   */
  static color lightenColor(color c, float percent) {
    int r = getRed(c);
    int g = getGreen(c);
    int b = getBlue(c);
    
    r = int(min(255, r + (255 - r) * percent / 100));
    g = int(min(255, g + (255 - g) * percent / 100));
    b = int(min(255, b + (255 - b) * percent / 100));
    
    return parseColor(r, g, b);
  }
  
  /**
   * Oscurece un color por un porcentaje
   * 
   * @param c Color a oscurecer
   * @param percent Porcentaje a oscurecer (0-100)
   * @return Color oscurecido
   */
  static color darkenColor(color c, float percent) {
    int r = getRed(c);
    int g = getGreen(c);
    int b = getBlue(c);
    
    r = int(max(0, r - (r * percent / 100)));
    g = int(max(0, g - (g * percent / 100)));
    b = int(max(0, b - (b * percent / 100)));
    
    return parseColor(r, g, b);
  }
  
  /**
   * Extrae el componente rojo de un color
   * 
   * @param c Valor del color
   * @return Componente rojo (0-255)
   */
  static int getRed(color c) {
    return (c >> 16) & 0xFF;
  }
  
  /**
   * Extrae el componente verde de un color
   * 
   * @param c Valor del color
   * @return Componente verde (0-255)
   */
  static int getGreen(color c) {
    return (c >> 8) & 0xFF;
  }
  
  /**
   * Extrae el componente azul de un color
   * 
   * @param c Valor del color
   * @return Componente azul (0-255)
   */
  static int getBlue(color c) {
    return c & 0xFF;
  }
  
  /**
   * Extrae el componente alpha de un color
   * 
   * @param c Valor del color
   * @return Componente alpha (0-255)
   */
  static int getAlpha(color c) {
    return (c >> 24) & 0xFF;
  }
  
  /**
   * Convierte valores RGB a un color sin llamar directamente a color()
   * Esto funciona porque estamos haciendo desplazamiento de bits para crear el valor del color
   * 
   * @param r Componente rojo (0-255)
   * @param g Componente verde (0-255)
   * @param b Componente azul (0-255)
   * @return Color de Processing
   */
  static color parseColor(int r, int g, int b) {
    return parseColor(r, g, b, 255);
  }
  
  /**
   * Convierte valores RGBA a un color sin llamar directamente a color()
   * 
   * @param r Componente rojo (0-255)
   * @param g Componente verde (0-255)
   * @param b Componente azul (0-255)
   * @param a Componente alpha (0-255)
   * @return Color de Processing
   */
  static color parseColor(int r, int g, int b, int a) {
    return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
  }
}

