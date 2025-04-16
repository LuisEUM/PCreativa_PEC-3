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
  Button clearPondButton; // Botón para vaciar el estanque
  Button randomKoiButton; // Botón para generar 25 peces aleatorios
  KoiManager koiManager; // Referencia al gestor de peces
  
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
    this.koiManager = koiManager;
    
    // Crear botón para vaciar el estanque en la esquina inferior izquierda
    this.clearPondButton = new Button(20, applet.height - 50, 40, 40, "");
    this.clearPondButton.buttonColor = ColorUtils.hexToColor("#F44336"); // Rojo
    this.clearPondButton.hoverColor = ColorUtils.hexToColor("#D32F2F"); // Rojo más oscuro
    this.clearPondButton.textColor = color(255);
    
    // Crear botón para generar peces aleatorios al lado del botón de papelera
    this.randomKoiButton = new Button(70, applet.height - 50, 40, 40, "");
    this.randomKoiButton.buttonColor = ColorUtils.hexToColor("#2196F3"); // Azul
    this.randomKoiButton.hoverColor = ColorUtils.hexToColor("#1976D2"); // Azul más oscuro
    this.randomKoiButton.textColor = color(255);
  }
  
  /**
   * Actualiza todos los elementos de la UI
   */
  void update() {
    this.koiCreator.update(applet.mouseX, applet.mouseY);
    
    // Actualizar estado hover del botón de vaciar estanque
    this.clearPondButton.isHovered = 
      applet.mouseX >= this.clearPondButton.position.x && 
      applet.mouseX <= this.clearPondButton.position.x + this.clearPondButton.width &&
      applet.mouseY >= this.clearPondButton.position.y && 
      applet.mouseY <= this.clearPondButton.position.y + this.clearPondButton.height;
      
    // Actualizar estado hover del botón de peces aleatorios
    this.randomKoiButton.isHovered = 
      applet.mouseX >= this.randomKoiButton.position.x && 
      applet.mouseX <= this.randomKoiButton.position.x + this.randomKoiButton.width &&
      applet.mouseY >= this.randomKoiButton.position.y && 
      applet.mouseY <= this.randomKoiButton.position.y + this.randomKoiButton.height;
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
    // Comprobar si se hizo clic en el botón de vaciar estanque
    if (this.clearPondButton.isClicked(mouseX, mouseY)) {
      // Vaciar el estanque inmediatamente
      koiManager.removeAllKoi();
      return true;
    }
    
    // Comprobar si se hizo clic en el botón de generar peces aleatorios
    if (this.randomKoiButton.isClicked(mouseX, mouseY)) {
      // Primero eliminamos todos los peces
      koiManager.removeAllKoi();
      // Luego creamos 25 peces aleatorios
      koiManager.initialize(25);
      return true;
    }
    
    return this.koiCreator.handleClick(mouseX, mouseY);
  }
  
  /**
   * Renderiza todos los elementos de la UI
   */
  void render() {
    renderAddButton();
    renderClearPondButton();
    renderRandomKoiButton();
    renderFishCounter();
    
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
   * Renderiza el botón de vaciar estanque
   */
  void renderClearPondButton() {
    Button btn = this.clearPondButton;
    
    // Determinar el color del botón según su estado hover
    color buttonColor = btn.isHovered ? btn.hoverColor : btn.buttonColor;
    
    // Dibuja el fondo del botón
    applet.noStroke();
    applet.fill(buttonColor);
    applet.rect(btn.position.x, btn.position.y, btn.width, btn.height, 5);
    
    // Dibuja el icono de papelera con un diseño simplificado
    applet.fill(btn.textColor);
    
    // Cálculo de dimensiones relativas al tamaño del botón
    float centerX = btn.position.x + btn.width/2;
    float centerY = btn.position.y + btn.height/2;
    float iconWidth = btn.width * 0.5;  // 50% del ancho del botón
    float iconHeight = btn.height * 0.55; // 55% de la altura del botón
    
    // Tapa de la papelera
    float lidWidth = iconWidth * 1.2; // Ligeramente más ancha que el cuerpo
    float lidHeight = iconHeight * 0.15;
    float lidY = centerY - iconHeight/2;
    
    // Dibujar la tapa
    applet.rect(centerX - lidWidth/2, lidY, lidWidth, lidHeight, 2);
    
    // Mango de la tapa
    float handleWidth = lidWidth * 0.25;
    float handleHeight = lidHeight * 0.8;
    applet.rect(centerX - handleWidth/2, lidY - handleHeight, handleWidth, handleHeight, 1);
    
    // Cuerpo de la papelera (ligeramente trapezoidal para mejor apariencia)
    applet.beginShape();
    float bodyTop = lidY + lidHeight;
    float bodyBottom = centerY + iconHeight/2;
    float bodyWidthTop = iconWidth * 0.9;
    float bodyWidthBottom = iconWidth;
    
    applet.vertex(centerX - bodyWidthTop/2, bodyTop);
    applet.vertex(centerX + bodyWidthTop/2, bodyTop);
    applet.vertex(centerX + bodyWidthBottom/2, bodyBottom);
    applet.vertex(centerX - bodyWidthBottom/2, bodyBottom);
    applet.endShape(CLOSE);
    
    // Líneas decorativas en la papelera
    applet.stroke(btn.textColor);
    applet.strokeWeight(1);
    
    // Número de líneas verticales
    int numLines = 3;
    float lineSpacing = bodyWidthBottom / (numLines + 1);
    float lineHeight = (bodyBottom - bodyTop) * 0.7; // 70% del alto del cuerpo
    float lineTop = bodyTop + (bodyBottom - bodyTop) * 0.15; // Comienza al 15% desde arriba
    
    // Dibuja las líneas verticales en el cuerpo de la papelera
    for (int i = 1; i <= numLines; i++) {
      float lineX = centerX - bodyWidthBottom/2 + i * lineSpacing;
      applet.line(lineX, lineTop, lineX, lineTop + lineHeight);
    }
    
    applet.noStroke();
  }
  
  /**
   * Renderiza el botón de generar peces aleatorios
   */
  void renderRandomKoiButton() {
    Button btn = this.randomKoiButton;
    
    // Determinar el color del botón según su estado hover
    color buttonColor = btn.isHovered ? btn.hoverColor : btn.buttonColor;
    
    // Dibuja el fondo del botón
    applet.noStroke();
    applet.fill(buttonColor);
    applet.rect(btn.position.x, btn.position.y, btn.width, btn.height, 5);
    
    // Dibuja el signo de interrogación
    applet.fill(btn.textColor);
    applet.textSize(24);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("?", btn.position.x + btn.width/2, btn.position.y + btn.height/2);
    
    applet.noStroke();
  }
  
  /**
   * Renderiza el contador de peces
   */
  void renderFishCounter() {
    int currentFishCount = koiManager.getKoiCount();
    int maxFishCount = koiManager.MAX_FISH; // Usa la constante definida en KoiManager
    
    // Dibuja el fondo del contador
    applet.fill(0, 0, 0, 120);
    applet.rect(20, 20, 80, 30, 5);
    
    // Dibuja el texto del contador
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text(currentFishCount + "/" + maxFishCount, 60, 35);
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
    
    // Sección de tamaño - Pequeños cuadrados en línea horizontal
    float labelX = panelX + 20; // Posición X común para todas las etiquetas
    float selectorX = panelX + 130; // Posición X común para todos los selectores (reducido para un diseño más compacto)
    float verticalGap = 35; // Espacio vertical entre grupos de elementos (reducido de 40 a 35)
    
    // Ajustado para dar más espacio después del título
    float sizeY = panelY + 70; // Aumentado de 60 a 70
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.fill(0);
    applet.text("Tamaño:", labelX, sizeY);
    
    // Botones de tamaño
    float squareSize = 30; // Tamaño cuadrado uniforme
    float spacing = 5; // Espacio entre elementos
    
    for (int i = 0; i < creator.sizeOptions.length; i++) {
      float btnX = selectorX + i * (squareSize + spacing);
      
      applet.fill(creator.selectedSizeIndex == i ? ColorUtils.hexToColor("#4CAF50") : ColorUtils.hexToColor("#DDDDDD"));
      applet.rect(btnX, sizeY - squareSize/2, squareSize, squareSize, 5);
      
      applet.fill(creator.selectedSizeIndex == i ? 255 : 0);
      applet.textSize(11);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(creator.sizeOptions[i], btnX + squareSize/2, sizeY);
    }
    
    // Sección de color base - En línea con etiqueta
    float colorY = sizeY + verticalGap;
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Color base:", labelX, colorY);
    
    // Muestra de colores como pequeños cuadrados
    for (int i = 0; i < creator.colorOptions.length; i++) {
      float btnX = selectorX + i * (squareSize + spacing);
      
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
      applet.rect(btnX, colorY - squareSize/2, squareSize, squareSize, 5);
      
      applet.noStroke();
    }
    
    // Sección de color de manchas - En línea con etiqueta
    float spotColorY = colorY + verticalGap;
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Color de manchas:", labelX, spotColorY);
    
    // Muestra de colores de manchas como pequeños cuadrados
    for (int i = 0; i < creator.spotColorOptions.length; i++) {
      float btnX = selectorX + i * (squareSize + spacing);
      
      // Borde de selección más grueso para los seleccionados
      if (creator.selectedSpotColors[i]) {
        applet.stroke(0);
        applet.strokeWeight(3);
      } else {
        applet.stroke(200);
        applet.strokeWeight(1);
      }
      
      // Color de fondo
      applet.fill(ColorUtils.hexToColor(creator.spotColorHexCodes[i]));
      applet.rect(btnX, spotColorY - squareSize/2, squareSize, squareSize, 5);
      
      applet.noStroke();
    }
    
    // Sección de número de manchas
    float spotCountY = spotColorY + verticalGap;
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Número de manchas:", labelX, spotCountY);
    
    // Control de número de manchas con botones + y -
    float spotCountControlX = selectorX;
    
    // Botón -
    applet.fill(ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(spotCountControlX, spotCountY - squareSize/2, squareSize, squareSize, 5);
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("-", spotCountControlX + squareSize/2, spotCountY);
    
    // Campo de número
    applet.fill(255);
    applet.stroke(200);
    applet.rect(spotCountControlX + squareSize + spacing, spotCountY - squareSize/2, squareSize*1.2, squareSize);
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text(String.valueOf(creator.selectedSpotCount), spotCountControlX + squareSize + spacing + squareSize*0.6, spotCountY);
    applet.noStroke();
    
    // Botón +
    applet.fill(ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(spotCountControlX + squareSize*2.2 + spacing*2, spotCountY - squareSize/2, squareSize, squareSize, 5);
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("+", spotCountControlX + squareSize*2.2 + spacing*2 + squareSize/2, spotCountY);
    
    // Sección de tamaño de manchas - En línea con etiqueta
    float spotSizeY = spotCountY + verticalGap;
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Tamaño de manchas:", labelX, spotSizeY);
    
    // Botones de tamaño de manchas
    for (int i = 0; i < creator.spotSizeOptions.length; i++) {
      float btnX = selectorX + i * (squareSize + spacing);
      
      // Borde de selección
      if (creator.selectedSpotSizeIndex == i) {
        applet.fill(ColorUtils.hexToColor("#4CAF50"));
      } else {
        applet.fill(ColorUtils.hexToColor("#DDDDDD"));
      }
      
      applet.rect(btnX, spotSizeY - squareSize/2, squareSize, squareSize, 5);
      
      applet.fill(creator.selectedSpotSizeIndex == i ? 255 : 0);
      applet.textSize(11);
      applet.textAlign(applet.CENTER, applet.CENTER);
      applet.text(creator.spotSizeOptions[i], btnX + squareSize/2, spotSizeY);
    }
    
    // Área de vista previa del pez koi - Centrada
    float previewWidth = 180; // Aumentado ligeramente
    float previewHeight = 100; // Aumentado ligeramente
    float previewX = applet.width/2 - previewWidth/2;
    float previewY = spotSizeY + verticalGap + 5; // Añadido 5px extra para dar más espacio antes de la vista previa
    
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
      creator.sizeLengths[creator.selectedSizeIndex] * 2, // Escala para mejor visibilidad
      creator.colorHexCodes[creator.selectedColorIndex],
      creator.getSelectedSpotColors(),
      creator.selectedSpotCount,
      creator.getSelectedSpotSize()
    );
    
    // Sección de cantidad de peces - Alineada a la izquierda debajo de la vista previa con espaciado consistente
    float fishCountY = previewY + previewHeight + verticalGap - 5; // Reducido 5px para acercar los elementos inferiores
    
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Cantidad de peces:", labelX, fishCountY);
    
    // Selector de cantidad con botones + y -
    float countControlX = selectorX;
    
    // Botón -
    applet.fill(ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(countControlX, fishCountY - squareSize/2, squareSize, squareSize, 5);
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("-", countControlX + squareSize/2, fishCountY);
    
    // Campo de número
    applet.fill(255);
    applet.stroke(200);
    applet.rect(countControlX + squareSize + spacing, fishCountY - squareSize/2, squareSize*1.2, squareSize);
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text(String.valueOf(creator.fishCount), countControlX + squareSize + spacing + squareSize*0.6, fishCountY);
    applet.noStroke();
    
    // Botón +
    applet.fill(ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(countControlX + squareSize*2.2 + spacing*2, fishCountY - squareSize/2, squareSize, squareSize, 5);
    applet.fill(0);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("+", countControlX + squareSize*2.2 + spacing*2 + squareSize/2, fishCountY);
    
    // Sección de toggle de peces iguales/aleatorios - Alineada a la izquierda debajo de cantidad de peces
    float toggleY = fishCountY + verticalGap;
    
    applet.fill(0);
    applet.textSize(12);
    applet.textAlign(applet.LEFT, applet.CENTER);
    applet.text("Patrón de manchas:", labelX, toggleY);
    
    // Toggle switch como dos botones cuadrados
    float toggleButtonSize = squareSize;
    float toggleX = selectorX;
    
    // Botón "Aleatorios"
    applet.fill(!creator.identicalFish ? ColorUtils.hexToColor("#2196F3") : ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(toggleX, toggleY - toggleButtonSize/2, toggleButtonSize, toggleButtonSize, 5);
    applet.fill(!creator.identicalFish ? 255 : 100);
    applet.textSize(10);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("?", toggleX + toggleButtonSize/2, toggleY);
    
    // Botón "Iguales"
    applet.fill(creator.identicalFish ? ColorUtils.hexToColor("#4CAF50") : ColorUtils.hexToColor("#DDDDDD"));
    applet.rect(toggleX + toggleButtonSize + spacing, toggleY - toggleButtonSize/2, toggleButtonSize, toggleButtonSize, 5);
    applet.fill(creator.identicalFish ? 255 : 100);
    applet.textSize(10);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("=", toggleX + toggleButtonSize + spacing + toggleButtonSize/2, toggleY);
    
    // Botón Crear en la esquina inferior derecha
    applet.fill(ColorUtils.hexToColor("#4CAF50"));
    applet.rect(panelX + panelWidth - 90, panelY + panelHeight - 50, 70, 30, 5); // Aumentado de -40 a -50 para dar más espacio al borde inferior
    applet.fill(255);
    applet.textSize(14);
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("Crear", panelX + panelWidth - 55, panelY + panelHeight - 35); // Ajustado de -25 a -35
    
    // Botón Cancelar como X en la esquina superior derecha
    float closeSize = 35; // Aumentado de 30 a 35 para hacer la X más grande
    float closeX = panelX + panelWidth - 25;
    float closeY = panelY + 25;
    
    // Verifica si el cursor está sobre el botón X
    boolean hoverClose = applet.mouseX >= closeX - closeSize/2 && 
                         applet.mouseX <= closeX + closeSize/2 &&
                         applet.mouseY >= closeY - closeSize/2 && 
                         applet.mouseY <= closeY + closeSize/2;
    
    // Color de la X (negro normalmente, rojo al pasar por encima)
    applet.fill(hoverClose ? ColorUtils.hexToColor("#F44336") : ColorUtils.hexToColor("#000000"));
    applet.textSize(30); // Aumentado de 26 a 30 para una X más grande
    applet.textAlign(applet.CENTER, applet.CENTER);
    applet.text("×", closeX, closeY);
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