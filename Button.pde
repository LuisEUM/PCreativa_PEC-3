/**
 * Jardín Koi - Button
 * 
 * Clase para botones interactivos con hover y click.
 * Utilizada en todas las interfaces del juego.
 * 
 * CARACTERÍSTICAS:
 * - Detección de hover y click
 * - Colores personalizables
 * - Texto centrado automáticamente
 * - Bordes redondeados
 * 
 * CÓDIGO ORIGINAL: 100% (nueva implementación para el sistema de UI)
 */

class Button {
  // Posición y tamaño
  PVector position;
  float width;
  float height;
  
  // Texto
  String label;
  
  // Colores
  color buttonColor;
  color hoverColor;
  color textColor;
  
  // Estado
  boolean isHovered;
  boolean isPressed;
  
  /**
   * Constructor
   */
  Button(float x, float y, float w, float h, String label) {
    this.position = new PVector(x, y);
    this.width = w;
    this.height = h;
    this.label = label;
    this.isHovered = false;
    this.isPressed = false;
    
    // Colores por defecto
    this.buttonColor = color(80, 120, 160);
    this.hoverColor = color(100, 140, 180);
    this.textColor = color(255, 255, 255);
  }
  
  /**
   * Actualiza el estado del botón
   */
  void update(float mouseX, float mouseY) {
    // Verificar si el mouse está sobre el botón
    this.isHovered = mouseX >= position.x && 
                     mouseX <= position.x + width && 
                     mouseY >= position.y && 
                     mouseY <= position.y + height;
  }
  
  /**
   * Verifica si el botón fue clickeado
   */
  boolean isClicked(float mouseX, float mouseY) {
    return mouseX >= position.x && 
           mouseX <= position.x + width && 
           mouseY >= position.y && 
           mouseY <= position.y + height;
  }
  
  /**
   * Verifica si el mouse está sobre el botón
   */
  boolean isMouseOver() {
    return isHovered;
  }
  
  /**
   * Renderiza el botón
   */
  void render() {
    // Dibujar el rectángulo del botón
    fill(getCurrentColor());
    stroke(255, 255, 255, 100);
    strokeWeight(1);
    rect(position.x, position.y, width, height, 5); // Bordes redondeados
    
    // Dibujar el texto
    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(label, position.x + width/2, position.y + height/2);
  }
  
  /**
   * Establece los colores del botón
   */
  void setColors(color buttonColor, color hoverColor, color textColor) {
    this.buttonColor = buttonColor;
    this.hoverColor = hoverColor;
    this.textColor = textColor;
  }
  
  /**
   * Obtiene el color actual del botón
   */
  color getCurrentColor() {
    return isHovered ? hoverColor : buttonColor;
  }
} 