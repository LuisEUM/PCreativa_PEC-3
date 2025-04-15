/**
 * Clase UIManager
 * 
 * Gestiona todos los elementos de la interfaz de usuario en el estanque.
 * Se encarga de renderizar y actualizar los componentes visuales.
 */
class UIManager {
  PApplet applet;
  KoiCreator koiCreator;
  
  /**
   * Constructor
   * 
   * @param applet Instancia de PApplet
   * @param koiManager Referencia al gestor de peces
   */
  UIManager(PApplet applet, KoiManager koiManager) {
    this.applet = applet;
    this.koiCreator = new KoiCreator(koiManager);
  }
  
  /**
   * Actualiza todos los elementos de la UI
   */
  void update() {
    this.koiCreator.update(applet.mouseX, applet.mouseY);
  }
  
  /**
   * Maneja los clics del ratón
   * 
   * @param mouseX Posición X del ratón
   * @param mouseY Posición Y del ratón
   * @return true si el clic fue consumido por la UI
   */
  boolean handleClick(float mouseX, float mouseY) {
    return this.koiCreator.handleClick(mouseX, mouseY);
  }
  
  /**
   * Renderiza todos los elementos de la UI
   */
  void render() {
    renderAddButton();
    
    if (koiCreator.isOpen) {
      renderCreatorPanel();
    }
  }
  
  /**
   * Renderiza el botón de añadir
   */
  void renderAddButton() {
    Button btn = koiCreator.addButton;
    
    // Dibuja el fondo del botón
    applet.noStroke();
    applet.fill(btn.isHovered ? btn.hoverColor : btn.buttonColor);
    applet.rect(btn.position.x, btn.position.y, btn.width, btn.height, 5);
    
    // Dibuja el símbolo +
    applet.fill(btn.textColor);
    applet.textSize(24);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("+", btn.position.x + btn.width/2, btn.position.y + btn.height/2 - 2);
  }
  
  /**
   * Renderiza el panel de creación de peces
   */
  void renderCreatorPanel() {
    KoiCreator creator = this.koiCreator;
    float panelWidth = 380;
    float panelHeight = 450; // Altura incrementada para agregar la sección de tamaño de manchas
    float panelX = applet.width/2 - panelWidth/2;
    float panelY = applet.height/2 - panelHeight/2;
    
    // Panel principal
    applet.fill(0, 0, 0, 180);
    applet.rect(0, 0, applet.width, applet.height);
    
    applet.fill(255);
    applet.rect(panelX, panelY, panelWidth, panelHeight, 10);
    
    // Título
    applet.fill(0);
    applet.textSize(20);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Agregar Nuevo Koi", applet.width/2, panelY + 25);
    
    // Sección de tamaño
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.fill(0);
    applet.text("Tamaño:", panelX + 20, panelY + 60 - 12);
    
    // Botones de tamaño
    float sizeY = panelY + 60;
    for (int i = 0; i < creator.sizeOptions.length; i++) {
      float btnX = applet.width/2 - 160 + i * 65;
      
      applet.fill(creator.selectedSizeIndex == i ? ColorUtils.hexToColor("#4CAF50") : ColorUtils.hexToColor("#DDDDDD"));
      applet.rect(btnX, sizeY, 60, 25, 5);
      
      applet.fill(creator.selectedSizeIndex == i ? 255 : 0);
      applet.textSize(11);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(creator.sizeOptions[i], btnX + 30, sizeY + 13);
    }
    
    // Sección de color base
    float colorY = panelY + 120;
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Color base:", panelX + 20, colorY - 12);
    
    // Muestra de colores (solo colores, sin texto)
    for (int i = 0; i < creator.colorOptions.length; i++) {
      float btnX = applet.width/2 - 170 + i * 60;
      
      // Borde de selección
      if (creator.selectedColorIndex == i) {
        applet.stroke(0);
        applet.strokeWeight(3);
      } else {
        applet.stroke(200);
        applet.strokeWeight(1);
      }
      
      // Color de fondo
      applet.fill(ColorUtils.hexToColor(creator.colorHexCodes[i]));
      applet.rect(btnX, colorY, 50, 25, 5);
      
      applet.noStroke();
    }
    
    // Sección de color de manchas
    float spotColorY = panelY + 180;
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Color de manchas (selección múltiple):", panelX + 20, spotColorY - 12);
    
    // Muestra de colores de manchas con selección múltiple (solo colores, sin texto)
    for (int i = 0; i < creator.spotColorOptions.length; i++) {
      float btnX = applet.width/2 - 140 + i * 70;
      
      // Borde de selección más grueso para los seleccionados
      if (creator.selectedSpotColors[i]) {
        applet.stroke(0);
        applet.strokeWeight(4); // Borde más grueso para los seleccionados
      } else {
        applet.stroke(200);
        applet.strokeWeight(1);
      }
      
      // Color de fondo
      applet.fill(ColorUtils.hexToColor(creator.spotColorHexCodes[i]));
      applet.rect(btnX, spotColorY, 65, 25, 5);
      
      applet.noStroke();
    }
    
    // Sección de número de manchas
    float sliderY = panelY + 240;
    String spotCountText;
    
    if (!creator.hasSelectedSpotColors()) {
      spotCountText = "Sin manchas";
    } else if (creator.selectedSpotCount == 0) {
      spotCountText = "Sin manchas";
    } else {
      spotCountText = String.valueOf(creator.selectedSpotCount);
    }
    
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Número de manchas: " + spotCountText, panelX + 20, sliderY - 12);
    applet.textSize(11);
    applet.text("(Si no selecciona color de manchas, no tendrá manchas)", panelX + 20, sliderY + 35);
    
    // Slider de número de manchas
    float sliderStart = applet.width/2 - 140;
    float sliderEnd = sliderStart + 280;
    
    // Línea de slider
    applet.stroke(150);
    applet.strokeWeight(2);
    applet.line(sliderStart, sliderY + 12, sliderEnd, sliderY + 12);
    
    // Marcadores de número
    for (int i = 0; i <= 10; i++) {
      float markerX = sliderStart + (i * 280 / 10);
      applet.line(markerX, sliderY + 8, markerX, sliderY + 16);
      
      applet.fill(150);
      applet.textSize(9);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(String.valueOf(i), markerX, sliderY + 25);
    }
    
    // Posición del control deslizante
    float handleX = sliderStart + (creator.selectedSpotCount * 280 / 10);
    applet.noStroke();
    applet.fill(ColorUtils.hexToColor("#4CAF50"));
    applet.ellipse(handleX, sliderY + 12, 15, 15);
    
    // Sección de tamaño de manchas
    float spotSizeY = panelY + 300;
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Tamaño de manchas:", panelX + 20, spotSizeY - 12);
    
    // Botones de tamaño de manchas
    for (int i = 0; i < creator.spotSizeOptions.length; i++) {
      float btnX = applet.width/2 - 140 + i * 70;
      
      // Borde de selección
      if (creator.selectedSpotSizeIndex == i) {
        applet.fill(ColorUtils.hexToColor("#4CAF50"));
      } else {
        applet.fill(ColorUtils.hexToColor("#DDDDDD"));
      }
      
      applet.rect(btnX, spotSizeY, 65, 25, 5);
      
      applet.fill(creator.selectedSpotSizeIndex == i ? 255 : 0);
      applet.textSize(11);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(creator.spotSizeOptions[i], btnX + 32, spotSizeY + 13);
    }
    
    // Texto de manchas aleatorias
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Las manchas se distribuirán aleatoriamente", applet.width/2, sliderY + 50);
    
    // Botones en la esquina inferior derecha
    applet.fill(ColorUtils.hexToColor("#4CAF50"));
    applet.rect(panelX + panelWidth - 170, panelY + panelHeight - 40, 80, 25, 5);
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Crear", panelX + panelWidth - 130, panelY + panelHeight - 28);
    
    applet.fill(ColorUtils.hexToColor("#f44336"));
    applet.rect(panelX + panelWidth - 80, panelY + panelHeight - 40, 70, 25, 5);
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Cancelar", panelX + panelWidth - 45, panelY + panelHeight - 28);
  }
} 