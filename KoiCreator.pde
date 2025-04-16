/**
 * Clase KoiCreator
 * 
 * Proporciona la interfaz de usuario para crear nuevos peces koi personalizados.
 * Permite seleccionar tamaño, color y patrón de manchas.
 */
class KoiCreator {
  Button addButton;
  boolean isOpen;
  
  // Opciones de personalización
  String[] sizeOptions = {"XS", "S", "M", "L", "XL"};
  float[] sizeLengths = {10, 15, 20, 28, 35};
  String[] colorOptions = {"Naranja", "Blanco", "Negro", "Dorado", "Plateado", "Rojo"};
  String[] colorHexCodes = {"#ff5500", "#ffffff", "#333333", "#ffd700", "#c0c0c0", "#ff0000"};
  String[] colorTextColors = {"#ffffff", "#000000", "#ff0000", "#000000", "#000000", "#ffffff"};
  
  String[] spotColorOptions = {"Naranja", "Blanco", "Negro", "Rojo"};
  String[] spotColorHexCodes = {"#ff5500", "#ffffff", "#333333", "#ff0000"};
  boolean[] selectedSpotColors = {false, false, false, false}; // Permite múltiples selecciones
  
  // Opciones de tamaño de manchas
  String[] spotSizeOptions = {"Pequeño", "Mediano", "Grande", "Aleatorio"};
  float[] spotSizeValues = {0.2, 0.35, 0.5, -1}; // -1 significa aleatorio
  int selectedSpotSizeIndex = 3; // Aleatorio por defecto
  
  // Selecciones actuales
  int selectedSizeIndex;
  int selectedColorIndex;
  int selectedSpotCount;
  
  // Referencia al gestor de peces
  KoiManager koiManager;
  
  /**
   * Constructor
   * 
   * @param koiManager Referencia al gestor de peces
   */
  KoiCreator(KoiManager koiManager) {
    this.koiManager = koiManager;
    
    // Crea el botón de añadir en la esquina superior derecha
    this.addButton = new Button(width - 50, 10, 40, 40, "+");
    this.isOpen = false;
    
    // Valores iniciales
    this.selectedSizeIndex = 2; // M (Mediano)
    this.selectedColorIndex = 0; // Naranja
    this.selectedSpotColors[1] = true; // Blanco seleccionado por defecto
    this.selectedSpotCount = 3; // 3 manchas
  }
  
  /**
   * Actualiza el estado de la interfaz
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   */
  void update(float mouseX, float mouseY) {
    this.addButton.update(mouseX, mouseY);
  }
  
  /**
   * Maneja los clics del ratón
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   * @return true si se ha consumido el clic
   */
  boolean handleClick(float mouseX, float mouseY) {
    // Si el panel está cerrado, solo comprueba el botón de añadir
    if (!isOpen) {
      // Aumentamos ligeramente el área de clic del botón añadir para mejor detección
      float extendedClickArea = 5; // 5 píxeles extras en cada dirección
      if (mouseX >= addButton.position.x - extendedClickArea && 
          mouseX <= addButton.position.x + addButton.width + extendedClickArea &&
          mouseY >= addButton.position.y - extendedClickArea && 
          mouseY <= addButton.position.y + addButton.height + extendedClickArea) {
        isOpen = true;
        return true;
      }
      return false;
    }
    
    // Si el panel está abierto, comprueba interacciones
    float panelWidth = 380;
    float panelHeight = 480; // Aumentada para incluir vista previa
    float panelX = width/2 - panelWidth/2;
    float panelY = height/2 - panelHeight/2;
    
    // Clic en el botón "Crear" con área ampliada
    float extendedArea = 8; // Pixels extra para mejor detección de clic
    if (mouseX >= panelX + panelWidth - 170 - extendedArea && 
        mouseX <= panelX + panelWidth - 90 + extendedArea &&
        mouseY >= panelY + panelHeight - 40 - extendedArea && 
        mouseY <= panelY + panelHeight - 15 + extendedArea) {
      createNewKoi();
      isOpen = false;
      return true;
    }
    
    // Clic en el botón "Cancelar" con área ampliada
    if (mouseX >= panelX + panelWidth - 80 - extendedArea && 
        mouseX <= panelX + panelWidth - 10 + extendedArea &&
        mouseY >= panelY + panelHeight - 40 - extendedArea && 
        mouseY <= panelY + panelHeight - 15 + extendedArea) {
      isOpen = false;
      return true;
    }
    
    // Clic en selección de tamaño con área ampliada
    float sizeY = panelY + 60;
    if (mouseY >= sizeY - extendedArea && mouseY <= sizeY + 25 + extendedArea) {
      for (int i = 0; i < sizeOptions.length; i++) {
        float btnX = width/2 - 160 + i * 65;
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + 60 + extendedArea) {
          selectedSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color con área ampliada
    float colorY = panelY + 120;
    if (mouseY >= colorY - extendedArea && mouseY <= colorY + 25 + extendedArea) {
      for (int i = 0; i < colorOptions.length; i++) {
        float btnX = width/2 - 170 + i * 60;
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + 50 + extendedArea) {
          selectedColorIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color de manchas con área ampliada
    float spotColorY = panelY + 180;
    if (mouseY >= spotColorY - extendedArea && mouseY <= spotColorY + 25 + extendedArea) {
      for (int i = 0; i < spotColorOptions.length; i++) {
        float btnX = width/2 - 140 + i * 70;
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + 65 + extendedArea) {
          // Toggle de selección
          selectedSpotColors[i] = !selectedSpotColors[i];
          return true;
        }
      }
    }
    
    // Clic en selección de tamaño de manchas con área ampliada
    float spotSizeY = panelY + 320;
    if (mouseY >= spotSizeY - extendedArea && mouseY <= spotSizeY + 25 + extendedArea) {
      for (int i = 0; i < spotSizeOptions.length; i++) {
        float btnX = width/2 - 140 + i * 70;
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + 65 + extendedArea) {
          selectedSpotSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de número de manchas con área ampliada
    float sliderY = panelY + 240;
    float sliderStart = width/2 - 140;
    float sliderWidth = 280;
    
    if (mouseY >= sliderY - 15 && mouseY <= sliderY + 25) {
      if (mouseX >= sliderStart - extendedArea && mouseX <= sliderStart + sliderWidth + extendedArea) {
        float percentage = (mouseX - sliderStart) / sliderWidth;
        percentage = constrain(percentage, 0, 1); // Asegurar que esté en el rango 0-1
        selectedSpotCount = floor(percentage * 11); // 0-10 (11 opciones)
        return true;
      }
    }
    
    // Verifica si el clic fue dentro del panel
    if (mouseX >= panelX && mouseX <= panelX + panelWidth &&
        mouseY >= panelY && mouseY <= panelY + panelHeight) {
      return true;
    }
    
    // Si el clic fue fuera del panel, lo cerramos
    isOpen = false;
    return true;
  }
  
  /**
   * Verifica si hay algún color de mancha seleccionado
   */
  boolean hasSelectedSpotColors() {
    for (boolean selected : selectedSpotColors) {
      if (selected) return true;
    }
    return false;
  }
  
  /**
   * Obtiene la lista de colores de manchas seleccionados
   */
  ArrayList<String> getSelectedSpotColors() {
    ArrayList<String> colors = new ArrayList<String>();
    for (int i = 0; i < selectedSpotColors.length; i++) {
      if (selectedSpotColors[i]) {
        colors.add(spotColorHexCodes[i]);
      }
    }
    return colors;
  }
  
  /**
   * Obtiene el tamaño de las manchas seleccionado
   */
  float getSelectedSpotSize() {
    return spotSizeValues[selectedSpotSizeIndex];
  }
  
  /**
   * Crea un nuevo pez koi con las opciones seleccionadas
   */
  void createNewKoi() {
    // Obtén los valores seleccionados
    float koiLength = sizeLengths[selectedSizeIndex];
    String koiColor = colorHexCodes[selectedColorIndex];
    ArrayList<String> spotColors = getSelectedSpotColors();
    int spotCount = selectedSpotCount;
    float spotSize = getSelectedSpotSize();
    
    // Si no hay colores de manchas seleccionados, no habrá manchas
    if (!hasSelectedSpotColors()) {
      spotCount = 0;
    }
    
    // Crea un nuevo koi en el centro del estanque
    koiManager.createCustomKoi(
      width/2, 
      height/2, 
      koiLength, 
      koiColor, 
      spotColors, 
      spotCount,
      spotSize
    );
  }
} 