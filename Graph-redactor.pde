ArrayList<Graph> graphs = new ArrayList<Graph>();;
Graph chosen;
final int GRAPH_COUNT = 12;

final int VERTEX_DIAMETER = 80;

void setup() {
  size(displayWidth, displayHeight);
  textSize(40);
  textAlign(CENTER, CENTER);
  strokeWeight(1);
  stroke(0);

  for (int i = 0; i < GRAPH_COUNT; i++) {
    float x = random(width);
    float y = random(height);
    graphs.add(new Graph(i + 1, x, y));
  }

  //graphs[0].addLinks(graphs[1], graphs[9]);
  graphs.get(4).addLinks(graphs.get(5));
  graphs.get(5).addLinks(graphs.get(4));
}

void draw() {
  background(200);

  println();
  for (Graph graph: graphs) {
    graph.display();
    graph.move();
  }
}
