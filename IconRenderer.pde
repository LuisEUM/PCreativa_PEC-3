/**
 * Clase IconRenderer
 * 
 * Renderiza iconos vectoriales para la interfaz de usuario.
 * Incluye iconos para comida, rocas y peces.
 */
class IconRenderer {
  
  /**
   * Dibuja un icono de comida (gránulos flotantes)
   */
  void drawFoodIcon(PApplet applet, float x, float y, float size, color iconColor) {
    applet.pushStyle();
    applet.pushMatrix();
    applet.translate(x, y);
    
    // Dibujar varios círculos pequeños representando gránulos
    applet.noStroke();
    applet.fill(iconColor);
    
    float granuleSize = size * 0.2;
    
    // Gránulo central más grande
    applet.ellipse(0, 0, granuleSize * 1.5, granuleSize * 1.5);
    
    // Gránulos alrededor
    applet.ellipse(-size * 0.3, -size * 0.2, granuleSize, granuleSize);
    applet.ellipse(size * 0.3, -size * 0.1, granuleSize, granuleSize);
    applet.ellipse(-size * 0.1, size * 0.3, granuleSize, granuleSize);
    applet.ellipse(size * 0.2, size * 0.25, granuleSize, granuleSize);
    applet.ellipse(-size * 0.25, size * 0.1, granuleSize * 0.8, granuleSize * 0.8);
    
    applet.popMatrix();
    applet.popStyle();
  }
  
  /**
   * Dibuja un icono de roca (forma angular)
   */
  void drawRockIcon(PApplet applet, float x, float y, float size, color iconColor) {
    applet.pushStyle();
    applet.pushMatrix();
    applet.translate(x, y);
    
    applet.noStroke();
    applet.fill(iconColor);
    
    // Dibujar forma de roca irregular usando un octágono modificado
    applet.beginShape();
    
    float[] angles = {0, 0.6, 1.4, 2.1, 3.5, 4.2, 5.0, 5.8};
    float[] radii = {0.9, 0.7, 1.0, 0.8, 0.9, 0.6, 0.8, 0.7};
    
    for (int i = 0; i < angles.length; i++) {
      float angle = angles[i];
      float radius = radii[i] * size * 0.4;
      applet.vertex(cos(angle) * radius, sin(angle) * radius);
    }
    
    applet.endShape(CLOSE);
    
    // Añadir algunos detalles de textura
    applet.fill(red(iconColor) - 30, green(iconColor) - 30, blue(iconColor) - 30);
    applet.ellipse(-size * 0.1, -size * 0.1, size * 0.15, size * 0.15);
    applet.ellipse(size * 0.15, size * 0.05, size * 0.1, size * 0.1);
    
    applet.popMatrix();
    applet.popStyle();
  }
  
  /**
   * Dibuja un icono de pez koi (silueta simplificada)
   */
  void drawFishIcon(PApplet applet, float x, float y, float size, color iconColor) {
    applet.pushStyle();
    applet.pushMatrix();
    applet.translate(x, y);
    
    applet.noStroke();
    applet.fill(iconColor);
    
    // Cuerpo principal del pez (elipse)
    applet.ellipse(0, 0, size * 0.8, size * 0.5);
    
    // Cola del pez (triángulo)
    applet.beginShape();
    applet.vertex(-size * 0.4, 0);
    applet.vertex(-size * 0.7, -size * 0.3);
    applet.vertex(-size * 0.7, size * 0.3);
    applet.endShape(CLOSE);
    
    // Aleta dorsal
    applet.beginShape();
    applet.vertex(-size * 0.1, -size * 0.25);
    applet.vertex(size * 0.1, -size * 0.4);
    applet.vertex(size * 0.2, -size * 0.2);
    applet.endShape(CLOSE);
    
    // Ojo del pez
    applet.fill(255);
    applet.ellipse(size * 0.15, 0, size * 0.15, size * 0.15);
    applet.fill(0);
    applet.ellipse(size * 0.15, 0, size * 0.08, size * 0.08);
    
    applet.popMatrix();
    applet.popStyle();
  }
} 