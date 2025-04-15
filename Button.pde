/**
 * Clase Button
 * 
 * Representa un botón interactivo para la interfaz de usuario.
 * Maneja la detección de clics y estados visuales.
 */
class Button {
  Vector2D position;
  float width;
  float height;
  String label;
  color buttonColor;
  color hoverColor;
  color textColor;
  boolean isHovered;
  
  /**
   * Constructor
   * 
   * @param x Posición x del botón
   * @param y Posición y del botón
   * @param width Ancho del botón
   * @param height Alto del botón
   * @param label Texto del botón
   */
  Button(float x, float y, float width, float height, String label) {
    this.position = new Vector2D(x, y);
    this.width = width;
    this.height = height;
    this.label = label;
    this.buttonColor = ColorUtils.hexToColor("#4CAF50");
    this.hoverColor = ColorUtils.hexToColor("#45a049");
    this.textColor = ColorUtils.hexToColor("#FFFFFF");
    this.isHovered = false;
  }
  
  /**
   * Actualiza el estado del botón
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   */
  void update(float mouseX, float mouseY) {
    this.isHovered = isMouseOver(mouseX, mouseY);
  }
  
  /**
   * Verifica si el ratón está sobre el botón
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   * @return true si el ratón está sobre el botón
   */
  boolean isMouseOver(float mouseX, float mouseY) {
    return (mouseX >= position.x && mouseX <= position.x + width &&
            mouseY >= position.y && mouseY <= position.y + height);
  }
  
  /**
   * Verifica si el botón ha sido clicado
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   * @return true si el botón ha sido clicado
   */
  boolean isClicked(float mouseX, float mouseY) {
    return isMouseOver(mouseX, mouseY);
  }
} 