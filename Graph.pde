public class Graph {
  int value;
  float x;
  float y;

  ArrayList<Graph> linked = new ArrayList<Graph>();

  public Graph(int value, float x, float y) {
    this.value = value;
    this.x = x;
    this.y = y;
  }

  void display() {
    displayLinks();

    fill(255);
    strokeWeight(1);
    stroke(0);
    ellipse(x, y, VERTEX_DIAMETER, VERTEX_DIAMETER);
    fill(0);
    text(value, x, y);
  }

  void addLinks(Graph ...links) {
    for (Graph link : links) {
      linked.add(link);
    }
  }

  void move() {
    if (mousePressed) {
      if (sq(mouseX - x) + sq(mouseY - y) < sq(VERTEX_DIAMETER)) {
        if (chosen == null) chosen = this;
        if (chosen != this) return;
        x += mouseX - pmouseX;
        y += mouseY - pmouseY;
      }
    } else chosen = null;
  }

  //---------------------------------------

  void displayLinks() {
    for (Graph graph : linked) {
      if (graph == this) {
        linkToMyself();
        continue;
      }
      boolean crossed = false;
      for (Graph gLink: graph.linked) {
        if (gLink == this) {
          commonLink(graph, true);
          crossed = true;
          break;
        }
      }
      if (crossed) continue;
      if (sq(graph.x - x) + sq(graph.y - y) < sq(VERTEX_DIAMETER)) continue;
      commonLink(graph, false);
    }
  }

  private void commonLink(Graph graph, boolean imaginary) {
    PVector startPoint = new PVector(x, y);

    Graph touched = linkTouchGraph(startPoint, new PVector(graph.x, graph.y));
    
    if ((touched == null || touched.value == graph.value) && imaginary) {
      Graph fantom = new Graph(0, (x + graph.x) / 2, (y + graph.y) / 2);
      touched = fantom;
      touched.display();
    }

    while (touched != null) {
      if (touched.value == graph.value) break;
      final float indent = VERTEX_DIAMETER * 0.75;
      
      PVector transfPoint;
      if (startPoint.x >= touched.x && startPoint.y < touched.y) {
        transfPoint = new PVector(touched.x + indent, touched.y);
      } else if (startPoint.x <= touched.x && startPoint.y > touched.y) {
        transfPoint = new PVector(touched.x - indent, touched.y);
      } else if (startPoint.x > touched.x && startPoint.y >= touched.y) {
        transfPoint = new PVector(touched.x, touched.y + indent);
      } else {
        transfPoint = new PVector(touched.x, touched.y - indent);
      }
      
      touched = linkTouchGraph(startPoint, transfPoint);
      if (touched != null) continue;
      
      line(startPoint.x, startPoint.y, transfPoint.x, transfPoint.y);
      startPoint = transfPoint;

      touched = linkTouchGraph(startPoint, new PVector(graph.x, graph.y));
    }

    PVector intPoint = findIntersectPoint(startPoint.x, startPoint.y, graph.x, graph.y);
    line(startPoint.x, startPoint.y, intPoint.x, intPoint.y);

    float k = -(graph.x - startPoint.x) / (graph.y - startPoint.y);
    Arrow arr = new Arrow();
    if (graph.y < startPoint.y) arr.rotate(atan(k));
    else arr.rotate(PI + atan(k));
    arr.translate(intPoint.x, intPoint.y);
    arr.display();
    
    //if (graphs.size() > GRAPH_COUNT) graphs.remove(12);
  }

  private void linkToMyself() {
  }

  private PVector findIntersectPoint(float x1, float y1, float x2, float y2) {
    float dist = sqrt(sq(x1 - x2) + sq(y1 - y2));
    final int r = VERTEX_DIAMETER / 2;
    float x = (x1 * r + x2 * (dist - r)) / dist;
    float y = (y1 * r + y2 * (dist - r)) / dist;
    return new PVector(x, y);
  }

  private Graph linkTouchGraph(PVector pos0, PVector pos1) {
    Graph intersected = null;
    float leastDist = 5000;

    for (Graph other: graphs) {
      if (other.x - VERTEX_DIAMETER / 2 > pos0.x && other.x - VERTEX_DIAMETER / 2 > pos1.x
        || other.y - VERTEX_DIAMETER / 2 > pos0.y && other.y - VERTEX_DIAMETER / 2 > pos1.y
        || other.x + VERTEX_DIAMETER / 2 < pos0.x && other.x + VERTEX_DIAMETER / 2 < pos1.x
        || other.y + VERTEX_DIAMETER / 2 < pos0.y && other.y + VERTEX_DIAMETER / 2 < pos1.y) continue;
      if (other.x == this.x && other.y == this.y) continue;

      float distToGraph = sqrt(sq(other.x - pos0.x) + sq(other.y - pos0.y));
      // (x - x1) * (y2 - y1) = (y - y1) * (x2 - x1)
      // x(y2 - y1) + y(x1 - x2) + y1(x2 - x1) - x1(y2 - y1) = 0
      float dist = 
        abs(other.x * (pos1.y - pos0.y) + other.y * (pos0.x - pos1.x) + pos0.y * pos1.x - pos0.x * pos1.y)
        / sqrt(sq(pos1.x - pos0.x) + sq(pos1.y - pos0.y));
      if (dist < VERTEX_DIAMETER / 2 && dist > 0 && distToGraph < leastDist) {
        intersected = other;
        leastDist = distToGraph;
      }
    }
   // if (intersected != null) println(intersected.value);
    return intersected;
  }
}
