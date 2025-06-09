# 🎮 Jardín Koi

**Un juego de supervivencia y simulación de estanque de peces koi con tres modos de juego únicos: Waves, Endless y Zen.**

## 🎯 DESCRIPCIÓN DEL JUEGO

Jardín Koi es una evolución de la simulación original de estanque de peces que combina mecánicas de supervivencia con la experiencia relajante de cuidar koi. El juego ofrece tres experiencias completamente diferentes:

### 🌊 **MODO WAVES**

Juego de supervivencia estratégica con 5 oleadas programadas. Cada oleada dura 2 minutos y presenta enemigos cada vez más peligrosos. Recursos limitados y sistema de mejoras entre oleadas.

### ♾️ **MODO ENDLESS**

Supervivencia infinita con dificultad creciente. Los enemigos aparecen constantemente y la dificultad aumenta cada 30 segundos. Ideal para conseguir puntuaciones altas.

### 🧘 **MODO ZEN**

La simulación original de estanque pacífico. Crea koi personalizados, experimenta con colores y patrones, y disfruta de un ecosistema relajante sin enemigos.

---

## ⚙️ **MECÁNICAS DEL JUEGO**

### 🐟 **Sistema de Koi**

#### **Niveles de Crecimiento:**

| Nivel | Tamaño | Resistencia    | Velocidad  |
| ----- | ------ | -------------- | ---------- |
| XS    | 10px   | Muy frágil     | Muy rápida |
| S     | 15px   | Frágil         | Rápida     |
| M     | 20px   | Normal         | Normal     |
| L     | 28px   | Resistente     | Lenta      |
| XL    | 35px   | Muy resistente | Muy lenta  |

#### **Mecánicas de Crecimiento:**

- Los koi crecen cada **10 comidas consumidas**
- Los koi pierden niveles cuando son atacados por enemigos
- Los koi XS mueren si son atacados
- Sistema de invulnerabilidad temporal tras recibir daño

### 🦈 **Sistema de Enemigos** _(Solo Waves y Endless)_

#### **Tipos de Enemigos:**

| Tipo    | Tamaño | Daño     | Resistencia | Velocidad  |
| ------- | ------ | -------- | ----------- | ---------- |
| Bagre   | 25px   | 1 punto  | 2 golpes    | Lenta      |
| Carpa   | 35px   | 2 puntos | 3 golpes    | Normal     |
| Lucio   | 45px   | 3 puntos | 4 golpes    | Rápida     |
| Tiburón | 55px   | 4 puntos | 5 golpes    | Muy rápida |

#### **Comportamiento de Enemigos:**

- Aparecen desde los bordes del mapa
- Persiguen a los koi más cercanos
- Pueden ser atraídos por la comida
- Pueden ser repelidos y eliminados con rocas

### 💎 **Sistema de Recursos** _(Waves y Endless)_

#### **Recursos Disponibles:**

- **Comida:** Atrae a los koi para alimentarlos
- **Rocas:** Repelen enemigos y pueden eliminarlos con golpe directo

#### **Límites de Recursos:**

- **Modo Waves:** 100 comida / 100 rocas iniciales
- **Modo Endless:** 50 comida / 50 rocas iniciales
- Los recursos **NO se regeneran automáticamente**
- Solo se obtienen a través de power-ups

### 🎁 **Sistema de Power-ups** _(Waves y Endless)_

#### **Frecuencia:** Aparecen cada 10 segundos en burbujas flotantes

#### **Tipos disponibles:**

- **🪨 Rocas:** +15/+20/+25 rocas
- **🐠 Koi:** +15/+20/+25 koi nuevos
- **🍜 Comida:** +15/+20/+25 comida

---

## 🌊 **MODO WAVES - ESTRUCTURA**

### **📋 Progresión de Oleadas:**

1. **Wave 1 (DÍA):** Enemigos básicos - 2 minutos
2. **Wave 2 (ATARDECER):** Mayor variedad - 2 minutos
3. **Wave 3 (NOCHE):** Enemigos grandes - 2 minutos
4. **Wave 4 (AMANECER):** Invasión masiva - 2 minutos
5. **Wave 5 (DÍA):** Supervivencia final - 2 minutos

### **📈 Entre Oleadas:**

- Pantalla de mejoras con 3 opciones
- Reponer algunos recursos automáticamente
- Preparación para la siguiente oleada

---

## ♾️ **MODO ENDLESS - ESCALADA**

### **⏱️ Escalada de Dificultad:**

- **Cada 30 segundos:** Aumenta la cantidad de enemigos
- **Progresivo:** Nuevos tipos de enemigos se desbloquean
- **Sin límite:** La dificultad crece indefinidamente

### **🌅 Ciclo de Tiempo:**

- Cambio automático cada 2 minutos
- Día → Atardecer → Noche → Amanecer (repetir)

### **🏆 Sistema de Puntuación:**

#### **Puntos por Supervivencia:**

- **+1 punto** por segundo sobrevivido (solo Endless)

#### **Puntos por Koi Alimentados:**

- **Koi Pequeños (≤15px):** +100 puntos por alimentación
- **Koi Medianos (16-25px):** +200 puntos por alimentación
- **Koi Grandes (≥26px):** +300 puntos por alimentación

#### **Puntos por Enemigos Eliminados:**

- **Bagres (≤25px):** +150 puntos por eliminación
- **Carpas (26-35px):** +300 puntos por eliminación
- **Lucios (36-45px):** +500 puntos por eliminación
- **Tiburones (≥46px):** +1000 puntos por eliminación

---

## 🧘 **MODO ZEN - CARACTERÍSTICAS**

### **🎨 Personalización de Koi:**

- Tamaños personalizados
- Colores del cuerpo ajustables
- Sistema de manchas con colores y tamaños variables
- Generación aleatoria y manual

### **🌸 Elementos Decorativos:**

- Flores de loto flotantes
- Pétalos que caen del cielo
- Ondulaciones naturales en el agua
- Plantas acuáticas decorativas

### **🌅 Control del Tiempo:**

- Ciclo día/noche manual
- 4 ambientes diferentes: Día, Atardecer, Noche, Amanecer

---

## 🎮 **CONTROLES**

### **🕹️ Controles Universales:**

- **ESPACIO / P:** Pausar/Reanudar juego
- **ESC:** Volver al menú principal
- **M:** Silenciar/Activar música

### **🖱️ Controles de Gameplay:**

#### **Modes Waves y Endless:**

- **CLIC IZQUIERDO:** Alimentar koi (consume comida)
- **CLIC DERECHO:** Lanzar rocas (repele/daña enemigos)

#### **Modo Zen:**

- **CLIC IZQUIERDO:** Alimentar koi (ilimitado)
- **CLIC DERECHO:** Lanzar rocas (repele koi)
- **Interfaz UI:** Crear koi personalizados, cambiar tiempo del día

---

## 🖥️ **CARACTERÍSTICAS TÉCNICAS**

### **🎵 Sistema de Música:**

- Música diferente para cada modo
- Control de volumen en el perfil
- Pausa automática con el juego

### **💾 Sistema de Datos:**

- Guardado automático de puntuaciones
- Perfil de usuario personalizable
- Estadísticas de juego persistentes
- Desbloques y progreso guardado

### **📊 Pantallas Disponibles:**

- **Menú Principal:** Selección de modo con iconos de trofeos y perfil
- **Instrucciones:** Guía completa de cada modo con controles específicos
- **Perfil:** Edición de nombre y configuración de volumen
- **Puntuaciones:** Hall de la Fama con tabs para Waves y Endless
- **Pausa:** Sistema universal con estadísticas en tiempo real
- **Victoria/Derrota:** Resultados detallados con datos reales de la partida
- **Desglose Detallado:** Análisis completo con tabs para peces y enemigos

---

## 🎯 **OBJETIVOS POR MODO**

### **🌊 Modo Waves:**

- Sobrevivir las 5 oleadas completas
- Gestionar recursos limitados estratégicamente
- Aprovechar las mejoras entre oleadas
- Maximizar la puntuación final

### **♾️ Modo Endless:**

- Sobrevivir el mayor tiempo posible
- Conseguir la puntuación más alta
- Adaptarse a la escalada de dificultad
- Optimizar el uso de power-ups

### **🧘 Modo Zen:**

- Crear koi únicos y hermosos
- Experimentar con combinaciones de colores
- Disfrutar de una experiencia relajante
- Explorar todas las opciones de personalización

---

## 🚀 **INSTALACIÓN Y CONFIGURACIÓN**

### **📋 Requisitos:**

- Processing 4.0 o superior
- Resolución mínima: 600x600 píxeles

### **🎵 Música (Opcional):**

- Instalar librería "Sound" desde Processing
- Colocar archivos de audio en carpeta `assets/`
- El juego funciona sin música sin problemas

### **▶️ Ejecución:**

1. Abrir `lurdaneta_PR.pde` en Processing
2. Presionar "Play" o Ctrl+R
3. Seleccionar modo de juego en el menú principal

---

## 🏗️ **ARQUITECTURA DEL CÓDIGO**

### **📁 Estructura Principal:**

```
ScreenManager.pde      - Gestor de estados y pantallas
WavesManager.pde       - Lógica del modo Waves
EndlessManager.pde     - Lógica del modo Endless
PondManager.pde        - Lógica del modo Zen
KoiManager.pde         - Sistema de peces koi
EnemyManager.pde       - Sistema de enemigos
PowerUpManager.pde     - Sistema de power-ups
DataManager.pde        - Persistencia de datos
MusicManager.pde       - Sistema de audio
```

### **🎨 Interfaces:**

```
MainMenu.pde           - Menú principal
ProfileScreen.pde      - Perfil de usuario
ScoresScreen.pde       - Tabla de puntuaciones
VictoryScreen.pde      - Pantalla de victoria
GameOverScreen.pde     - Pantalla de derrota
PauseScreen.pde        - Sistema de pausa
```

---

## 🎨 **ELEMENTOS VISUALES**

### **🌊 Sistema de Agua:**

- 4 colores de agua según el tiempo del día
- Efectos de ondulación por interacciones
- Partículas de comida flotantes
- Burbujas de power-ups

### **🎭 Efectos Especiales:**

- Animaciones de crecimiento de koi
- Efectos de impacto de rocas
- Partículas de eliminación de enemigos
- Transiciones suaves entre estados

### **📱 Interfaz de Usuario:**

- Iconos vectoriales dibujados a mano
- Sistema de botones interactivos
- Contadores en tiempo real
- Alertas visuales para eventos importantes

### **📊 Sistema de Puntuación:**

- **Tracking en Tiempo Real:** Todos los datos se registran automáticamente
- **Peces Salvados:** Conteo por cada koi alimentado, categorizado por tamaño
- **Enemigos Vencidos:** Registro detallado por tipo (Bagres, Carpas, Lucios, Tiburones)
- **Pantalla de Desglose:** Análisis completo con tabs separadas para peces y enemigos
- **Datos Persistentes:** Puntuaciones guardadas en Hall de la Fama

---

## ✅ **ESTADO ACTUAL DEL PROYECTO**

### **🎮 Funcionalidades Completadas:**

- [x] Sistema de tres modos de juego completamente funcionales
- [x] Mecánicas de supervivencia balanceadas
- [x] Sistema de puntuación con datos reales en tiempo real
- [x] Interfaz de usuario completa y navegable con system de tabs
- [x] Sistema de música integrado
- [x] Personalización de koi en modo Zen
- [x] Escalada de dificultad en modo Endless
- [x] Sistema de oleadas en modo Waves
- [x] Pantalla de desglose detallado con estadísticas reales
- [x] Hall de la Fama con puntuaciones persistentes

### **🎯 Experiencia de Usuario:**

- [x] Flujo de navegación intuitivo
- [x] Controles responsivos y claros
- [x] Feedback visual inmediato
- [x] Sistema de pausa universal
- [x] Instrucciones detalladas por modo
- [x] Personalización de perfil

---

## 📄 **LICENCIA**

Este proyecto está licenciado bajo la Licencia MIT.

---

## 🎮 **¡A JUGAR!**

**Jardín Koi** ofrece una experiencia única que combina acción estratégica con momentos de relajación. Ya sea enfrentando oleadas de enemigos o creando koi hermosos, hay algo para cada tipo de jugador.

¡Sumérgete en el mundo del Jardín Koi y descubre tu modo favorito! 🐟💙

---

## 🎵 Créditos de Música

La música utilizada en Jardín Koi ha sido generada y licenciada gracias a los assets de Suno (https://suno.com). Agradecemos a Suno por su contribución a la ambientación sonora del juego.

