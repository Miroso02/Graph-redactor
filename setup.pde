ArrayList<Vertex> vertexes = new ArrayList<Vertex>();
ArrayList<Vertex> condensVert = new ArrayList<Vertex>();
Vertex chosen;
Switch linkLength;
Switch moveVertex;
GraphController gc = new GraphController();
final int GRAPH_COUNT = 12;
final boolean DIRECTED = true;
final int VERTEX_DIAMETER = 80;

void setup() {
  size(displayWidth, displayHeight);
  textSize(40);
  textAlign(CENTER, CENTER);
  strokeWeight(2);
  rectMode(CENTER);
  stroke(0);
  randomSeed(9323);
  
  linkLength = new Switch(3);
  linkLength.setPosition(150, height / 2 + 200);
  linkLength.setDimensions(200, 80);
  linkLength.setColors(color(255, 0, 255),
                       color(0, 255, 255),
                       color(255, 255, 0));
  linkLength.setText("Шляхи \n довжиною " + (linkLength.state + 1));
  
  moveVertex = new Switch(2);
  moveVertex.setPosition(width - 100, height / 2 + 200);
  moveVertex.setDimensions(180, 70);
  moveVertex.setColors(color(255, 0, 0), color(0, 255, 0));
  moveVertex.setText("Переміс����ити");
  
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

//------------------------------------------------------

void circle(PVector position, int size) {
  ellipse(position.x, position.y, size, size);
} 
void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}
void rect(PVector position, PVector dimensions)
{
  rect(position.x, position.y, dimensions.x, dimensions.y);
}

int[][] mult(int[][] m1, int[][] m2) {
  int l = m1.length;
  int[][] res = new int[l][l];
  for (int i = 0; i < l; i++) {
    for (int j = 0; j < l; j++) {
      for (int k = 0; k < l; k++) {
        res[i][j] += m1[i][k] * m2[k][j];
      }
    }
  }
  return res;
}
int[][] add(int[][] m1, int[][] m2) {
  int l = m1.length;
  int[][] res = new int[l][l];
  for (int i = 0; i < l; i++) {
    for (int j = 0; j < l; j++) {
      res[i][j] = m1[i][j] + m2[i][j];
      if (res[i][j] > 0) res[i][j] = 1;
    }
  }
  return res;
}
ArrayList<Integer> copy(ArrayList<Integer> a) {
  ArrayList<Integer> res = new ArrayList<Integer>();
  res.addAll(a);
  return res;
}
