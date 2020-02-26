ArrayList<Vertex> vertexes = new ArrayList<Vertex>();;
Vertex chosen;
final int GRAPH_COUNT = 12;
final boolean DIRECTED = true;
final int VERTEX_DIAMETER = 80;

void setup() {
  size(displayWidth, displayHeight);
  textSize(40);
  textAlign(CENTER, CENTER);
  strokeWeight(1);
  stroke(0);
  randomSeed(9323);
  
  for (int i = 0; i < 4; i++) {
    float x = width / 2 - 240 + 160 * i;
    float y = 200 + i;
    vertexes.add(new Vertex(i + 1, x, y));
  }
  for (int i = 4; i < 8; i++) {
    float x = width / 2 - 240 + 160 * (i - 4);
    float y = 200 + 160 * 3 - i;
    vertexes.add(new Vertex(i + 1, x, y));
  }
  for (int i = 8; i < 10; i++) {
    float x = width / 2 - 240 + i - 7;
    float y = 200 + 160 * (i - 7) + i - 7;
    vertexes.add(new Vertex(i + 1, x, y));
  }
  for (int i = 10; i < 12; i++) {
    float x = width / 2 + 240 - i + 9;
    float y = 200 + 160 * (i - 9) + i - 9;
    vertexes.add(new Vertex(i + 1, x, y));
  }
  
  vertexes.add(new Vertex(0, 0, 0));
  
  setLinks();
}

void draw() {
  background(200);
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    vertexes.get(i).display();
    vertexes.get(i).move();
  }
}

void setLinks() {
  final float A = 1 - 0.25 - 2 * 0.02 - 3 * 0.005;
  
  int[][] matrix = new int[GRAPH_COUNT][GRAPH_COUNT];
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      matrix[i][j] = floor((random(1) + random(1)) * A);
    }
  }
  
  if (!DIRECTED) {
  int[][] transponed = new int[GRAPH_COUNT][GRAPH_COUNT];
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      transponed[i][j] = matrix[i][j];
    }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = i + 1; j < GRAPH_COUNT; j++) {
      int temp = transponed[i][j];
      transponed[i][j] = transponed[j][i];
      transponed[j][i] = temp;
    }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      matrix[i][j] += transponed[i][j];
      if (matrix[i][j] == 2) matrix[i][j] = 1;
    }
  }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(matrix[i][j] + " ");
      if (matrix[i][j] == 1) vertexes.get(i).addLinks(vertexes.get(j));
    }
  }
}

void circle(PVector position, int size) {
  ellipse(position.x, position.y, size, size);
} 
void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}
