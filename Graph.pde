public class Graph {
  int value;
  PVector position;

  ArrayList<Graph> linked = new ArrayList<Graph>();

  public Graph(int value, float x, float y) {
    this.value = value;
    this.position = new PVector(x, y);
  }

  void display() {
    displayLinks();

    fill(255);
    strokeWeight(1);
    stroke(0);
    ellipse(position.x, position.y, VERTEX_DIAMETER, VERTEX_DIAMETER);
    fill(0);
    text(value, position.x, position.y);
  }

  void addLinks(Graph ...links) {
    for (Graph link: links) {
      linked.add(link);
    }
  }

  void move() {
    if (mousePressed) {
      if (sq(mouseX - position.x) + sq(mouseY - position.y) < sq(VERTEX_DIAMETER)) {
        if (chosen == null) chosen = this;
        if (chosen != this) return;
        position.add(mouseX - pmouseX, mouseY - pmouseY);
      }
    } else chosen = null;
  }

  //---------------------------------------

  void displayLinks() {
    for (Graph graph: linked) {
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
      if (findDistSq(graph.position, position) < sq(VERTEX_DIAMETER)) continue;
      commonLink(graph, false);
    }
  }

  private void commonLink(Graph graph, boolean imaginary) {
    PVector startPoint = position.copy();

    Graph touched = linkTouchGraph(startPoint, graph.position.copy());

    if ((touched == null || touched.value == graph.value) && imaginary) {
      Graph fantom = new Graph(0, (position.x + graph.x) / 2, (position.y + graph.y) / 2);
      touched = fantom;
      touched.display();
    }

    while (touched != null) {
      if (touched.value == graph.value) break;
      final float indent = VERTEX_DIAMETER * 0.75;

      PVector transfPoint;
      if (startPoint.x >= touched.x && startPoint.y < touched.y) {
        transfPoint = touched.position.copy().add(indent, 0);
      } else if (startPoint.x <= touched.x && startPoint.y > touched.y) {
        transfPoint = touched.position.copy().add(-indent, 0);
      } else if (startPoint.x > touched.x && startPoint.y >= touched.y) {
        transfPoint = touched.position.copy().add(0, indent);
      } else {
        transfPoint = touched.position.copy().add(0, -indent);
      }

      touched = linkTouchGraph(startPoint, transfPoint);
      if (touched != null) continue;

      line(startPoint.x, startPoint.y, transfPoint.x, transfPoint.y);
      startPoint = transfPoint;

      touched = linkTouchGraph(startPoint, graph.position.copy());
    }

    PVector intPoint = findIntersectPoint(startPoint, graph.position);
    line(startPoint.x, startPoint.y, intPoint.x, intPoint.y);

    float k = -(graph.position.x - startPoint.x) / (graph.position.y - startPoint.y);
    Arrow arr = new Arrow();
    if (graph.position.y < startPoint.y) arr.rotate(atan(k));
    else arr.rotate(PI + atan(k));
    arr.translate(intPoint.x, intPoint.y);
    arr.display();

  }

  private PVector findIntersectPoint(PVector p1, PVector p2) {
    final int r = VERTEX_DIAMETER / 2;
    float dist = sqrt(findDistSq(p1, p2));
    float x = (p1.x * r + p2.x * (dist - r)) / dist;
    float y = (p1.y * r + p2.y * (dist - r)) / dist;
    return new PVector(x, y);
    Graph intersected = null;
  }

  private Graph linkTouchGraph(PVector pos0, PVector pos1) {
    float leastDist = 5000;

    for (Graph other: graphs) {
      if (other.x - VERTEX_DIAMETER / 2 > pos0.x && other.x - VERTEX_DIAMETER / 2 > pos1.x
        || other.y - VERTEX_DIAMETER / 2 > pos0.y && other.y - VERTEX_DIAMETER / 2 > pos1.y
        || other.x + VERTEX_DIAMETER / 2 < pos0.x && other.x + VERTEX_DIAMETER / 2 < pos1.x
        || other.y + VERTEX_DIAMETER / 2 < pos0.y && other.y + VERTEX_DIAMETER / 2 < pos1.y) continue;
      if (other.x == this.x && other.y == this.y) continue;

      float distToGraph = sqrt(findDistSq(other.position, pos0));
      // (x - x1) * (y2 - y1) = (y - y1) * (x2 - x1)
      // x(y2 - y1) + y(x1 - x2) + y1(x2 - x1) - x1(y2 - y1) = 0
      float dist =
        abs(other.position.x * (pos1.y - pos0.y) + other.position.y * (pos0.x - pos1.x) + pos0.y * pos1.x - pos0.x * pos1.y)
        / sqrt(findDistSq(pos0, pos1));
      if (dist < VERTEX_DIAMETER / 2 && dist > 0 && distToGraph < leastDist) {
        intersected = other;
        leastDist = distToGraph;
      }
    }
   // if (intersected != null) println(intersected.value);
    return intersected;
  }

  private float findDistSq(PVector p1, PVector p2) {
    return sq(p1.x - p2.x) + sq(p1.y - p2.y);
  }
}
