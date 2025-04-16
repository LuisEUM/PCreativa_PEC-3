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
  String[] spotSizeOptions = {"S", "M", "L", "?"};
  float[] spotSizeValues = {0.2, 0.35, 0.5, -1}; // -1 significa aleatorio
  int selectedSpotSizeIndex = 3; // Aleatorio por defecto
  
  // Selecciones actuales
  int selectedSizeIndex;
  int selectedColorIndex;
  int selectedSpotCount;
  
  // Nuevas propiedades
  int fishCount = 1; // Cantidad de peces a crear (entre 1 y 25)
  boolean identicalFish = false; // false = aleatorios, true = iguales
  
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
    float panelHeight = 480;
    float panelX = width/2 - panelWidth/2;
    float panelY = height/2 - panelHeight/2;
    float squareSize = 30; // Tamaño de los botones cuadrados
    float spacing = 5;     // Espacio entre elementos
    
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
    if (mouseY >= sizeY - squareSize/2 - extendedArea && mouseY <= sizeY + squareSize/2 + extendedArea) {
      for (int i = 0; i < sizeOptions.length; i++) {
        float btnX = panelX + 80 + i * (squareSize + spacing);
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + squareSize + extendedArea) {
          selectedSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color con área ampliada
    float colorY = panelY + 100;
    if (mouseY >= colorY - squareSize/2 - extendedArea && mouseY <= colorY + squareSize/2 + extendedArea) {
      for (int i = 0; i < colorOptions.length; i++) {
        float btnX = panelX + 80 + i * (squareSize + spacing);
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + squareSize + extendedArea) {
          selectedColorIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de color de manchas con área ampliada
    float spotColorY = panelY + 140;
    if (mouseY >= spotColorY - squareSize/2 - extendedArea && mouseY <= spotColorY + squareSize/2 + extendedArea) {
      for (int i = 0; i < spotColorOptions.length; i++) {
        float btnX = panelX + 120 + i * (squareSize + spacing);
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + squareSize + extendedArea) {
          // Toggle de selección
          selectedSpotColors[i] = !selectedSpotColors[i];
          return true;
        }
      }
    }
    
    // Clic en selección de tamaño de manchas con área ampliada
    float spotSizeY = panelY + 230;
    if (mouseY >= spotSizeY - squareSize/2 - extendedArea && mouseY <= spotSizeY + squareSize/2 + extendedArea) {
      for (int i = 0; i < spotSizeOptions.length; i++) {
        float btnX = panelX + 130 + i * (squareSize + spacing);
        if (mouseX >= btnX - extendedArea && mouseX <= btnX + squareSize + extendedArea) {
          selectedSpotSizeIndex = i;
          return true;
        }
      }
    }
    
    // Clic en selección de número de manchas con botones + y -
    float spotCountY = panelY + 180;
    float spotCountControlX = panelX + 135;
    
    // Botón disminuir (-)
    if (mouseY >= spotCountY - squareSize/2 - extendedArea && mouseY <= spotCountY + squareSize/2 + extendedArea &&
        mouseX >= spotCountControlX - extendedArea && mouseX <= spotCountControlX + squareSize + extendedArea) {
      selectedSpotCount = max(0, selectedSpotCount - 1); // No menor a 0
      return true;
    }
    
    // Botón aumentar (+)
    if (mouseY >= spotCountY - squareSize/2 - extendedArea && mouseY <= spotCountY + squareSize/2 + extendedArea &&
        mouseX >= spotCountControlX + squareSize*2.2 + spacing*2 - extendedArea && 
        mouseX <= spotCountControlX + squareSize*3.2 + spacing*2 + extendedArea) {
      selectedSpotCount = min(10, selectedSpotCount + 1); // No mayor a 10
      return true;
    }
    
    // Clic en botones de aumentar/disminuir cantidad de peces
    float fishCountY = panelY + 290;
    float countControlX = panelX + 330;
    
    // Botón disminuir (-)
    if (mouseY >= fishCountY - squareSize/2 - extendedArea && mouseY <= fishCountY + squareSize/2 + extendedArea &&
        mouseX >= countControlX - extendedArea && mouseX <= countControlX + squareSize + extendedArea) {
      fishCount = max(1, fishCount - 1); // No menor a 1
      return true;
    }
    
    // Botón aumentar (+)
    if (mouseY >= fishCountY - squareSize/2 - extendedArea && mouseY <= fishCountY + squareSize/2 + extendedArea &&
        mouseX >= countControlX + squareSize*2.2 + spacing*2 - extendedArea && 
        mouseX <= countControlX + squareSize*3.2 + spacing*2 + extendedArea) {
      fishCount = min(25, fishCount + 1); // No mayor a 25
      return true;
    }
    
    // Toggle de peces iguales/aleatorios
    float toggleY = panelY + 330;
    float toggleX = panelX + 330;
    float toggleButtonSize = squareSize;
    
    // Botón Aleatorios
    if (mouseY >= toggleY - toggleButtonSize/2 - extendedArea && mouseY <= toggleY + toggleButtonSize/2 + extendedArea &&
        mouseX >= toggleX - extendedArea && mouseX <= toggleX + toggleButtonSize + extendedArea) {
      identicalFish = false;
      return true;
    }
    
    // Botón Iguales
    if (mouseY >= toggleY - toggleButtonSize/2 - extendedArea && mouseY <= toggleY + toggleButtonSize/2 + extendedArea &&
        mouseX >= toggleX + toggleButtonSize + spacing - extendedArea && 
        mouseX <= toggleX + toggleButtonSize*2 + spacing + extendedArea) {
      identicalFish = true;
      return true;
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
    
    // Si se solicita solo un pez o peces idénticos, se usa una semilla fija
    long seed = identicalFish ? 12345 : 0;
    
    // Crea los peces solicitados
    for (int i = 0; i < fishCount; i++) {
      // Para peces aleatorios, usamos una semilla diferente para cada uno
      if (!identicalFish) {
        seed = (long)(random(1, 10000) * i);
      }
      
      // Crea un nuevo koi en el centro del estanque con un offset aleatorio
      float offsetX = random(-100, 100);
      float offsetY = random(-100, 100);
      
      koiManager.createCustomKoi(
        width/2 + offsetX, 
        height/2 + offsetY, 
        koiLength, 
        koiColor, 
        spotColors, 
        spotCount,
        spotSize,
        seed
      );
    }
  }
} 