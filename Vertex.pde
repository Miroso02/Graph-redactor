public class Vertex {
  int value;
  PVector position;

  ArrayList<Vertex> linked = new ArrayList<Vertex>();

  public Vertex(int value, float x, float y) {
    this.value = value;
    position = new PVector(x, y);
  }
  public Vertex(int value, PVector position) {
    this.value = value;
    this.position = position.copy();
  }

  void display() {
    displayLinks();

    fill(255);
    strokeWeight(1);
    stroke(0);
    circle(position, VERTEX_DIAMETER);
    fill(0);
    text(value, position.x, position.y);
  }

  void addLinks(Vertex ...links) {
    for (Vertex link : links) {
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
    for (Vertex graph : linked) {
      boolean crossed = false;
      for (Vertex gLink: graph.linked) {
        if (gLink == this && graph != this) {
          if (DIRECTED) crossed = true;
          else graph.linked.remove(this);
          commonLink(graph, DIRECTED);
          break;
        }
      }
      if (crossed) continue;
      commonLink(graph, false);
    }
  }

  private void commonLink(Vertex graph, boolean imaginary) {
    PVector startPoint = this.position;
    PVector endPoint = graph.position;
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(startPoint);

    Vertex touched = linkTouchVertex(startPoint, endPoint);
    if (touched != null && getDistSq(touched.position, startPoint) < sq(VERTEX_DIAMETER)) return;
    
    if (startPoint == endPoint) {
      points.add(position.copy().add(VERTEX_DIAMETER / 2 + 5, VERTEX_DIAMETER / 2));
      PVector lastP = position.copy().add(VERTEX_DIAMETER / 2 + 10, -VERTEX_DIAMETER / 2);
      points.add(lastP);
      startPoint = lastP;
      touched = null;
    }
    
    if (imaginary) {
      if (touched == null || touched.value == graph.value) {
        vertexes.set(12, new Vertex(0, startPoint.copy().add(endPoint).div(2)));
        touched = vertexes.get(12);
        //touched.display();
      }
    }

    while (touched != null) {
      if (touched.value == graph.value) break;
      final float indent = VERTEX_DIAMETER * (0.75 + (float)(this.value + graph.value) / 30);
      
      PVector transfPoint = new PVector(0, 0);
      PVector touchedPos = touched.position.copy();
      
      if (startPoint.x >= touchedPos.x && startPoint.y < touchedPos.y) {
        transfPoint = touchedPos.add(indent, 0);
      } else if (startPoint.x <= touchedPos.x && startPoint.y > touchedPos.y) {
        transfPoint = touchedPos.add(-indent, 0);
      } else if (startPoint.x > touchedPos.x && startPoint.y >= touchedPos.y) {
        transfPoint = touchedPos.add(0, indent);
      } else if (startPoint.x < touchedPos.x && startPoint.y <= touchedPos.y) {
        transfPoint = touchedPos.add(0, -indent);
      }
      
      touched = linkTouchVertex(startPoint, transfPoint);
      if (touched != null) continue;
      
      points.add(transfPoint);
      startPoint = transfPoint;

      touched = linkTouchVertex(startPoint, graph.position);
    }
    
    vertexes.get(12).position.set(-100, 0);
    PVector lastPoint = findIntersectPoint(startPoint, endPoint);
    points.add(lastPoint);
    drawArrow(points);
  }

  private Vertex linkTouchVertex(PVector pos0, PVector pos1) {
    Vertex intersected = null;
    float leastDist = 5000;

    for (Vertex other: vertexes) {
      if (other.position.x - VERTEX_DIAMETER / 2 > max(pos0.x, pos1.x)
        || other.position.y - VERTEX_DIAMETER / 2 > max(pos0.y, pos1.y)
        || other.position.x + VERTEX_DIAMETER / 2 < min(pos0.x, pos1.x)
        || other.position.y + VERTEX_DIAMETER / 2 < min(pos0.y, pos1.y)) continue;
      if (other.value == this.value) continue;

      float distToVertex = getDist(other.position, pos0);
      // (x - x1) * (y2 - y1) = (y - y1) * (x2 - x1)
      // x(y2 - y1) + y(x1 - x2) + y1(x2 - x1) - x1(y2 - y1) = 0
      float dist = 
        abs(other.position.x * (pos1.y - pos0.y) + other.position.y * (pos0.x - pos1.x) + pos0.y * pos1.x - pos0.x * pos1.y)
        / sqrt(sq(pos1.x - pos0.x) + sq(pos1.y - pos0.y));
      if (dist < VERTEX_DIAMETER / 2/* && dist > 0*/ && distToVertex < leastDist) {
        intersected = other;
        leastDist = distToVertex;
      }
    }
    //if (intersected != null && this.value == 3) println(intersected.value);
    return intersected;
  }
  
  //----------------------------------------------------------
  
  float getDistSq(PVector p1, PVector p2) {
    return sq(p1.x - p2.x) + sq(p1.y - p2.y);
  }
  float getDist(PVector p1, PVector p2) {
    return sqrt(getDistSq(p1, p2));
  }
  private PVector findIntersectPoint(PVector p1, PVector p2) {
    float dist = getDist(p1, p2);
    final int r = VERTEX_DIAMETER / 2;
    float x = (p1.x * r + p2.x * (dist - r)) / dist;
    float y = (p1.y * r + p2.y * (dist - r)) / dist;
    return new PVector(x, y);
  }
  void drawArrow(ArrayList<PVector> points) {
    if (chosen == this) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
    }
    for (int i = 0; i < points.size() - 1; i++) {
      line(points.get(i), points.get(i + 1));
    }
    PVector pLast = points.get(points.size() - 1);
    PVector pPreLast = points.get(points.size() - 2);
    
    float k = -(pLast.x - pPreLast.x) / (pLast.y - pPreLast.y);
    Arrow arr = new Arrow();
    if (pLast.y < pPreLast.y) arr.rotate(atan(k));
    else arr.rotate(PI + atan(k));
    arr.translate(pLast.x, pLast.y);
    if (DIRECTED) arr.display();
  }
}
