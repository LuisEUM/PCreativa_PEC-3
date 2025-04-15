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
  float[] spotSizeValues = {0.08, 0.15, 0.25, -1}; // -1 significa aleatorio
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
      if (addButton.isClicked(mouseX, mouseY)) {
        isOpen = true;
        return true;
      }
      return false;
    }
    
    // Si el panel está abierto, comprueba interacciones
    float panelWidth = 380;
    float panelHeight = 450;
    float panelX = width/2 - panelWidth/2;
    float panelY = height/2 - panelHeight/2;
    
    // Clic en el botón "Crear" (ahora en la esquina inferior derecha)
    if (mouseX >= panelX + panelWidth - 170 && mouseX <= panelX + panelWidth - 90 &&
        mouseY >= panelY + panelHeight - 40 && mouseY <= panelY + panelHeight - 15) {
      createNewKoi();
      isOpen = false;
      return true;
    }
    
    // Clic en el botón "Cancelar" (ahora en la esquina inferior derecha)
    if (mouseX >= panelX + panelWidth - 80 && mouseX <= panelX + panelWidth - 10 &&
        mouseY >= panelY + panelHeight - 40 && mouseY <= panelY + panelHeight - 15) {
      isOpen = false;
      return true;
    }
    
    // Clic en selección de tamaño
    float sizeY = panelY + 60;
    if (mouseY >= sizeY && mouseY <= sizeY + 25) {
      for (int i = 0; i < sizeOptions.length; i++) {
        float btnX = width/2 - 160 + i * 65;
        if (mouseX >= btnX && mouseX <= btnX + 60) {
          selectedSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color
    float colorY = panelY + 120;
    if (mouseY >= colorY && mouseY <= colorY + 25) {
      for (int i = 0; i < colorOptions.length; i++) {
        float btnX = width/2 - 170 + i * 60;
        if (mouseX >= btnX && mouseX <= btnX + 50) {
          selectedColorIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color de manchas (múltiple)
    float spotColorY = panelY + 180;
    if (mouseY >= spotColorY && mouseY <= spotColorY + 25) {
      for (int i = 0; i < spotColorOptions.length; i++) {
        float btnX = width/2 - 140 + i * 70;
        if (mouseX >= btnX && mouseX <= btnX + 65) {
          // Toggle de selección
          selectedSpotColors[i] = !selectedSpotColors[i];
          return true;
        }
      }
    }
    
    // Clic en selección de tamaño de manchas
    float spotSizeY = panelY + 300;
    if (mouseY >= spotSizeY && mouseY <= spotSizeY + 25) {
      for (int i = 0; i < spotSizeOptions.length; i++) {
        float btnX = width/2 - 140 + i * 70;
        if (mouseX >= btnX && mouseX <= btnX + 65) {
          selectedSpotSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de número de manchas
    float sliderY = panelY + 240;
    float sliderStart = width/2 - 140;
    float sliderWidth = 280;
    
    if (mouseY >= sliderY && mouseY <= sliderY + 25) {
      if (mouseX >= sliderStart && mouseX <= sliderStart + sliderWidth) {
        float percentage = (mouseX - sliderStart) / sliderWidth;
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