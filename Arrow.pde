public class Arrow {
  PVector[] vertexes = new PVector[3];
  
  public Arrow() {
    vertexes[0] = new PVector(0, 0);
    vertexes[1] = new PVector(5, 20);
    vertexes[2] = new PVector(-5, 20);
  }
  
  void display() {
    triangle(vertexes[0].x, vertexes[0].y,
             vertexes[1].x, vertexes[1].y, 
             vertexes[2].x, vertexes[2].y);
  }
  
  void rotate(float angle) {
    for (PVector ver: vertexes) {
      float x = ver.x * cos(angle) - ver.y * sin(angle);
      float y = ver.x * sin(angle) + ver.y * cos(angle);
      ver.set(x, y);
    }
  }
  void translate(float x, float y) {
    for (PVector ver: vertexes) {
      ver.add(x, y);
    }
  }
}