/**
 * Clase UIManager
 * 
 * Gestiona todos los elementos de la interfaz de usuario en el estanque.
 * Se encarga de renderizar y actualizar los componentes visuales.
 */
class UIManager {
  PApplet applet;
  KoiCreator koiCreator;
  int timeOfDay; // Tiempo del día actual
  color[] pondColors; // Colores del estanque
  
  /**
   * Constructor
   * 
   * @param applet Instancia de PApplet
   * @param koiManager Referencia al gestor de peces
   * @param timeOfDay El tiempo del día actual (0: día, 1: atardecer, 2: noche, 3: amanecer)
   * @param pondColors Array de colores del estanque para diferentes tiempos del día
   */
  UIManager(PApplet applet, KoiManager koiManager, int timeOfDay, color[] pondColors) {
    this.applet = applet;
    this.koiCreator = new KoiCreator(koiManager);
    this.timeOfDay = timeOfDay;
    this.pondColors = pondColors;
  }
  
  /**
   * Actualiza todos los elementos de la UI
   */
  void update() {
    this.koiCreator.update(applet.mouseX, applet.mouseY);
  }
  
  /**
   * Actualiza el tiempo del día
   * 
   * @param timeOfDay El nuevo tiempo del día
   */
  void setTimeOfDay(int timeOfDay) {
    this.timeOfDay = timeOfDay;
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
    float panelHeight = 480; // Altura incrementada para agregar la vista previa
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
    
    // Texto informativo sobre manchas
    applet.fill(0);
    applet.textSize(11);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("(Si no selecciona color de manchas, no tendrá manchas)", panelX + 20, sliderY + 35);
    
    // Sección de tamaño de manchas
    float spotSizeY = panelY + 320;
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
    
    // Texto de distribución de manchas
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Las manchas se distribuirán aleatoriamente", applet.width/2, spotSizeY + 40);
    
    // Área de vista previa del pez koi
    float previewX = panelX + 30;
    float previewY = panelY + panelHeight - 100;
    float previewWidth = 150;
    float previewHeight = 80;
    
    // Panel de fondo con color del agua según el tiempo del día
    applet.fill(red(pondColors[timeOfDay]), green(pondColors[timeOfDay]), blue(pondColors[timeOfDay]), 180);
    applet.rect(previewX, previewY, previewWidth, previewHeight, 8);
    
    // Texto de vista previa
    applet.fill(255);
    applet.textSize(12);
    applet.textAlign(applet.CENTER, applet.TOP);
    applet.text("Vista previa", previewX + previewWidth/2, previewY + 5);
    
    // Dibuja el pez koi en vista previa
    renderPreviewKoi(
      previewX + previewWidth/2, 
      previewY + previewHeight/2 + 10,
      creator.sizeLengths[creator.selectedSizeIndex] * 2.5, // Escala para mejor visibilidad
      creator.colorHexCodes[creator.selectedColorIndex],
      creator.getSelectedSpotColors(),
      creator.selectedSpotCount,
      creator.getSelectedSpotSize()
    );
    
    // Botones en la esquina inferior derecha
    applet.fill(ColorUtils.hexToColor("#4CAF50"));
    applet.rect(panelX + panelWidth - 170, panelY + panelHeight - 40, 80, 25, 5);
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Crear", panelX + panelWidth - 130, panelY + panelHeight - 28);
    
    applet.fill(ColorUtils.hexToColor("#F44336"));
    applet.rect(panelX + panelWidth - 80, panelY + panelHeight - 40, 70, 25, 5);
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Cancelar", panelX + panelWidth - 45, panelY + panelHeight - 28);
  }
  
  /**
   * Renderiza una vista previa del pez koi basado en las opciones seleccionadas
   * 
   * @param x Posición X del centro del pez
   * @param y Posición Y del centro del pez
   * @param length Longitud del pez
   * @param koiColor Color del pez
   * @param spotColors Colores de las manchas
   * @param spotCount Número de manchas
   * @param spotSize Tamaño de las manchas
   */
  void renderPreviewKoi(float x, float y, float length, String koiColor, ArrayList<String> spotColors, int spotCount, float spotSize) {
    float width = length * 0.4; // Ancho proporcional al largo
    float time = applet.millis() * 0.001; // Tiempo para animación
    
    // Movimiento suave de la cola
    float tailFrequency = 0.1;
    float tailAmplitude = 0.2;
    float tailWag = sin(time * 5 * tailFrequency) * tailAmplitude;
    
    applet.pushMatrix();
    applet.translate(x, y);
    
    // Obtiene el color del koi
    color koiC = ColorUtils.hexToColor(koiColor);
    
    // Dibuja el cuerpo exterior (30% más grande)
    applet.noStroke();
    applet.fill(koiC);
    applet.ellipse(0, 0, length * 1.3, width * 1.3);
    
    // Dibuja el cuerpo base del koi
    applet.fill(koiC);
    applet.ellipse(0, 0, length, width);
    
    // Genera y dibuja manchas aleatorias
    if (spotCount > 0 && spotColors.size() > 0) {
      // Usamos un algoritmo determinista para que las manchas no cambien cada frame
      randomSeed(int(koiColor.hashCode() + spotCount + spotSize * 100));
      
      for (int i = 0; i < spotCount; i++) {
        // Posición relativa de la mancha
        float spotXRel = random(0.2, 0.8);
        float spotYRel = random(0.2, 0.8);
        
        // Posición absoluta de la mancha
        float spotX = (spotXRel - 0.5) * length;
        float spotY = (spotYRel - 0.5) * width;
        
        // Tamaño de la mancha
        float actualSpotSize;
        if (spotSize < 0) { // Aleatorio
          actualSpotSize = random(0.2, 0.5) * width;
        } else {
          actualSpotSize = spotSize * width;
        }
        
        // Limita el tamaño y posición para que esté dentro del cuerpo
        float distFromCenter = sqrt(spotX * spotX + spotY * spotY);
        float maxAllowedDist = (length / 2) * 0.7; // 70% del radio
        
        if (distFromCenter > maxAllowedDist) {
          float angle = atan2(spotY, spotX);
          spotX = cos(angle) * maxAllowedDist;
          spotY = sin(angle) * maxAllowedDist;
        }
        
        // Ajusta el tamaño para evitar desbordamiento
        actualSpotSize = min(actualSpotSize, width * 0.6);
        
        // Elige un color aleatorio de la lista de colores seleccionados
        String spotColor = spotColors.get(i % spotColors.size());
        color spotC = ColorUtils.hexToColor(spotColor);
        
        // Dibuja la mancha
        applet.noStroke();
        applet.fill(red(spotC), green(spotC), blue(spotC), 180);
        applet.ellipse(spotX, spotY, actualSpotSize, actualSpotSize);
      }
      
      // Restaura la semilla aleatoria
      randomSeed(int(random(10000)));
    }
    
    // Dibuja la cola con el mismo color que el cuerpo
    // Dibuja primero la cola exterior (30% más grande)
    applet.fill(koiC);
    applet.beginShape();
    applet.vertex(-length/2 * 1.3, 0);
    applet.quadraticVertex(
      (-length/2 - length/4) * 1.3, tailWag * width * 1.3,
      (-length/2 - length/3) * 1.3, tailWag * width * 1.5 * 1.3
    );
    applet.quadraticVertex(
      (-length/2 - length/4) * 1.3, tailWag * width * 1.3,
      -length/2 * 1.3, 0
    );
    applet.endShape(CLOSE);
    
    // Dibuja la cola interior
    applet.fill(koiC);
    applet.beginShape();
    applet.vertex(-length/2, 0);
    applet.quadraticVertex(
      -length/2 - length/4, tailWag * width,
      -length/2 - length/3, tailWag * width * 1.5
    );
    applet.quadraticVertex(
      -length/2 - length/4, tailWag * width,
      -length/2, 0
    );
    applet.endShape(CLOSE);
    
    applet.popMatrix();
  }
} 