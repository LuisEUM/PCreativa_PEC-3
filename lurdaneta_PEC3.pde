/**
 * Simulación de Estanque de Koi
 * 
 * Esta aplicación simula un estanque de peces koi tradicional japonés. El sistema 
 * representa un ecosistema acuático completo donde peces koi de diversos colores y patrones
 * nadan evitando obstáculos como rocas decorativas. Los peces responden a la 
 * interacción del usuario, acercándose a los puntos donde se hace clic izquierdo para buscar 
 * alimento y alejándose de los clics derechos (piedras). El estanque incluye elementos decorativos 
 * como hojas y flores de loto que flotan en la superficie, así como pétalos que caen aleatoriamente 
 * sobre el agua creando ondulaciones. El ciclo de tiempo cambia entre día, atardecer, noche y amanecer,
 * afectando el color del agua. Los usuarios pueden personalizar y añadir nuevos peces koi
 * con diferentes tamaños, colores base y patrones de manchas.
 * 
 * Este es el archivo principal que coordina todos los elementos del estanque de koi.
 * Este es el punto de entrada de la aplicación que inicializa y gestiona
 * todos los componentes de la simulación.
 * 
 * ARQUITECTURA DEL PROYECTO:
 * --------------------------
 * Este proyecto utiliza una arquitectura de Facade combinada con el patrón Manager.
 * Cada elemento de la simulación (peces, plantas, rocas, etc.) se gestiona a través
 * de su propio gestor especializado, y todos estos gestores están coordinados por
 * un gestor principal (PondManager) que actúa como fachada para simplificar las
 * interacciones entre los componentes.
 * 
 * COMPONENTS MANAGERS:
 * -------------------
 * - PondManager: Actúa como fachada principal que coordina todos los demás gestores.
 *   Implementa el patrón Facade para simplificar la interfaz del sistema complejo.
 * 
 * - KoiManager: Gestiona la colección de peces koi, su comportamiento y movimiento.
 *   Controla la creación, actualización y comportamiento colectivo de los peces.
 * 
 * - KoiCreator: Maneja la interfaz para crear nuevos peces koi personalizados con
 *   opciones de tamaño, color y patrones de manchas.
 * 
 * - PlantManager: Administra todas las plantas acuáticas (hojas y flores de loto).
 *   Gestiona la colocación estratégica y el ciclo de vida de las plantas.
 * 
 * - RockManager: Gestiona las rocas decorativas en el estanque, asegurando que no
 *   colisionen con las plantas y proporcionando obstáculos para los peces.
 * 
 * - RippleManager: Controla los efectos de ondulación en la superficie del agua,
 *   creados por interacciones como clics o pétalos que caen.
 * 
 * - PetalManager: Gestiona los pétalos de flor que flotan en el estanque,
 *   controlando su aparición, movimiento y hundimiento.
 * 
 * - FoodManager: Administra las partículas de comida que se crean cuando el usuario
 *   hace clic y que atraen a los peces koi.
 * 
 * - UIManager: Gestiona la interfaz de usuario para interacciones avanzadas,
 *   como la creación de nuevos peces koi con propiedades personalizadas,
 *   botones para cambiar el ciclo del día y eliminar peces.
 * 
 * CARACTERÍSTICAS PRINCIPALES:
 * --------------------------
 * - Personalización de peces koi: diferentes tamaños, colores base, patrones de manchas
 * - Comportamiento realista de los peces con evasión de obstáculos
 * - Ciclo de tiempo día/noche con cambios visuales en el agua
 * - Interacción usuario: alimentar peces (clic izquierdo) y lanzar piedras (clic derecho)
 * - Efectos visuales: ondulaciones de agua, pétalos flotantes, animaciones de peces
 * - Gestión de población: límite de 100 peces, contador visual, función para eliminar peces
 * 
 * FLUJO DE DATOS:
 * --------------
 * 1. La clase principal (lurdaneta_PEC2) inicializa el PondManager
 * 2. PondManager inicializa todos los demás gestores
 * 3. El método draw() actualiza y renderiza todos los elementos a través de PondManager
 * 4. Cuando ocurre un clic, se propaga a través del PondManager a los gestores relevantes
 * 
 * PATRONES DE DISEÑO:
 * ------------------
 * - Facade: PondManager proporciona una interfaz simplificada al sistema complejo
 * - Manager: Cada categoría de objetos tiene su propio gestor especializado
 * - Object-Oriented: Uso de clases para encapsular comportamiento y datos relacionados
 */

// Gestores
PondManager pondManager;

/**
 * Función de configuración - se ejecuta una vez al principio
 * Inicializa todos los componentes necesarios
 */
void setup() {
  // Establece el tamaño del lienzo a 600x600
  size(600, 600);
  // Habilita el renderizado suave
  smooth();
  
  // Establece el modo de color a RGB (predeterminado)
  colorMode(RGB, 255, 255, 255);
  
  // Inicializa el gestor del estanque que coordina todos los elementos
  pondManager = new PondManager(this);
}

/**
 * Función de dibujo - se ejecuta continuamente
 * Actualiza y renderiza todos los elementos
 * 
 * Este método se ejecuta aproximadamente 60 veces por segundo y es responsable de:
 * 1. Actualizar el estado de todos los elementos (posición, animación, etc.)
 * 2. Renderizar todos los elementos en el orden correcto (desde el fondo hasta la superficie)
 */
void draw() {
  // Actualiza y renderiza el estanque
  pondManager.update();
  pondManager.render();
}

/**
 * Manejador de evento de pulsación del ratón
 * Crea ondulaciones y partículas de comida, atrae a los peces
 * 
 * Este método responde a los clics del usuario y:
 * 1. Comprueba si el clic es manejado por la interfaz de usuario
 * 2. Si no, crea ondas en el agua (ripples)
 * 3. Genera partículas de comida (clic izquierdo) o piedras (clic derecho)
 * 4. Atrae a los peces koi cercanos o los repele, dependiendo del tipo de clic
 */
void mousePressed() {
  pondManager.handleClick(mouseX, mouseY);
}

