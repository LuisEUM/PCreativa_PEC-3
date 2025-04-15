/**
 * Clase Vector2D
 * 
 * Implementa un vector bidimensional con operaciones matemáticas comunes.
 */
static class Vector2D {
  float x, y;
  
  Vector2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // Calcula la distancia entre dos vectores
  static float distance(Vector2D v1, Vector2D v2) {
    float dx = v2.x - v1.x;
    float dy = v2.y - v1.y;
    return sqrt(dx * dx + dy * dy);
  }
  
  // Calcula el ángulo entre dos vectores
  static float angle(Vector2D v1, Vector2D v2) {
    float dx = v2.x - v1.x;
    float dy = v2.y - v1.y;
    return atan2(dy, dx);
  }
  
  // Suma otro vector a este vector
  Vector2D add(Vector2D v) {
    return new Vector2D(this.x + v.x, this.y + v.y);
  }
  
  // Resta otro vector de este vector
  Vector2D subtract(Vector2D v) {
    return new Vector2D(this.x - v.x, this.y - v.y);
  }
  
  // Multiplica este vector por un escalar
  Vector2D multiply(float scalar) {
    return new Vector2D(this.x * scalar, this.y * scalar);
  }
  
  // Normaliza el vector (longitud = 1)
  Vector2D normalize() {
    float length = sqrt(this.x * this.x + this.y * this.y);
    if (length == 0) return new Vector2D(0, 0);
    return new Vector2D(this.x / length, this.y / length);
  }
  
  // Crea una copia de este vector
  Vector2D clone() {
    return new Vector2D(this.x, this.y);
  }
} 