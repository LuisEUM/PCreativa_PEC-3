# 🎵 Guía de Instalación de Música para Jardín Koi

## 📋 **Problema Actual**

El juego está configurado para reproducir música de fondo, pero la librería de sonido de Processing no está instalada, por lo que la música funciona en "modo silencioso".

## 🛠️ **Solución: Instalar la Librería Sound**

### **Pasos para instalar:**

1. **Abrir Processing IDE**
2. **Ir al menú:** `Tools` > `Manage Tools...`
3. **Seleccionar pestaña:** `Libraries`
4. **Buscar:** Escribir "Sound" en el campo de búsqueda
5. **Instalar:** Hacer clic en "Sound" de "The Processing Foundation" y presionar `Install`

### **Activar la música después de instalar:**

1. **Abrir:** `MusicManager.pde`
2. **Línea 2:** Descomentar (remover `//` del inicio):

   ```java
   // import processing.sound.*;
   ```

   Cambiar a:

   ```java
   import processing.sound.*;
   ```

3. **Buscar todas las secciones comentadas** que dicen:

   ```java
   // DESCOMENTAR CUANDO TENGAS LA LIBRERÍA SOUND:
   /*
   código aquí...
   */
   ```

4. **Descomentar el código** dentro de los `/* */` en estas secciones:
   - Constructor: líneas de `new SoundFile(...)`
   - `setGameMode()`: líneas de `.amp()` y `.loop()`
   - `stopCurrentMusic()`: línea de `.stop()`
   - `pauseMusic()`: línea de `.pause()`
   - `resumeMusic()`: línea de `.play()`
   - `setVolume()`: línea de `.amp()`
   - `isPlaying()`: línea de `return ...isPlaying()`
   - `dispose()`: líneas de `.stop()`

### **Ejemplo de descomentado:**

**ANTES:**

```java
// DESCOMENTAR CUANDO TENGAS LA LIBRERÍA SOUND:
/*
gameMusic = new SoundFile(parent, "KoiGarden_Game.mp3");
zenMusic = new SoundFile(parent, "KoiGarden_Zen.mp3");
println("🎵 MusicManager: Archivos de música cargados exitosamente");
*/
```

**DESPUÉS:**

```java
// DESCOMENTAR CUANDO TENGAS LA LIBRERÍA SOUND:
gameMusic = new SoundFile(parent, "KoiGarden_Game.mp3");
zenMusic = new SoundFile(parent, "KoiGarden_Zen.mp3");
println("🎵 MusicManager: Archivos de música cargados exitosamente");
```

## 🎵 **Funcionamiento de la Música**

Una vez activada, la música funcionará así:

| Modo/Estado    | Música Reproducida      |
| -------------- | ----------------------- |
| Menú Principal | `KoiGarden_Game.mp3`    |
| Modo Waves     | `KoiGarden_Game.mp3`    |
| Modo Endless   | `KoiGarden_Game.mp3`    |
| **Modo Zen**   | **`KoiGarden_Zen.mp3`** |
| Game Over      | `KoiGarden_Game.mp3`    |

### **Controles de Música:**

- **M**: Silenciar/activar música
- **Automático**: Cambia según el modo de juego
- **Pausa**: La música se pausa con el juego

## ✅ **Estado Actual del Juego**

**CON LIBRERÍA SOUND:** ✅ Música funcionando completamente
**SIN LIBRERÍA SOUND:** ✅ Juego funciona en modo silencioso (sin errores)

¡El juego está completamente funcional en ambos casos! 🎮
